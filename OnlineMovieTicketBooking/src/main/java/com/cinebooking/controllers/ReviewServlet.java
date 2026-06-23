package com.cinebooking.controllers;

import com.cinebooking.models.PublicReview;
import com.cinebooking.models.Review;
import com.cinebooking.models.User;
import com.cinebooking.models.VerifiedReview;
import com.cinebooking.services.BookingService;
import com.cinebooking.services.FileReviewService;
import com.cinebooking.services.MovieService;
import com.cinebooking.services.IReviewService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;


@WebServlet("/reviews")
public class ReviewServlet extends HttpServlet {

    private IReviewService reviewService;
    private BookingService bookingService;
    private MovieService movieService;

    @Override
    public void init() {
        String reviewsPath = getServletContext().getRealPath("/data/reviews.txt");
        String ratingsPath = getServletContext().getRealPath("/data/ratings.txt");
        String bookingsPath = getServletContext().getRealPath("/data/bookings.txt");
        String moviePath = getServletContext().getRealPath("/data/movies.txt");
        reviewService = new FileReviewService(reviewsPath, ratingsPath);
        bookingService = new BookingService(getServletContext().getRealPath("/data/seats.txt"), bookingsPath);
        movieService = new MovieService(moviePath);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User loggedUser = getLoggedUser(session);
        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/UserController?action=login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty() || "view".equalsIgnoreCase(action)) {
            showMovieReviews(request, response);
            return;
        }

        if ("editForm".equalsIgnoreCase(action)) {
            showEditForm(request, response, loggedUser);
            return;
        }

        if ("myReviews".equalsIgnoreCase(action)) {
            showMyReviews(request, response, loggedUser);
            return;
        }

        if ("adminReviews".equalsIgnoreCase(action)) {
            showAdminReviews(request, response, loggedUser);
            return;
        }

        if ("moderate".equalsIgnoreCase(action)) {
            showMovieReviews(request, response);
            return;
        }

        // Any unknown action falls back to the review list.
        showMovieReviews(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        User loggedUser = getLoggedUser(session);
        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/UserController?action=login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing action parameter.");
            return;
        }

        switch (action.toLowerCase()) {
            case "submit"       -> handleSubmit(request, response, loggedUser);
            case "edit"         -> handleEdit(request, response, loggedUser);
            case "delete"       -> handleDelete(request, response, loggedUser);
            case "updatestatus" -> handleUpdateStatus(request, response, loggedUser);
            case "upvote"       -> handleUpvote(request, response);
            case "report"       -> handleReport(request, response);
            default             -> response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                                       "Unsupported review action.");
        }
    }

    /**
     * Shows the reviews for a specific movie and prepares data for a Bootstrap 5 page.
     */
    private void showMovieReviews(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String movieId = request.getParameter("movieId");
        if (movieId == null || movieId.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "movieId is required.");
            return;
        }

        List<Review> reviews = reviewService.getMovieReviews(movieId);
        double averageRating = calculateAverageRating(reviews);

        // Rating distribution [index 0 = 5-star, index 4 = 1-star]
        int[] dist = new int[5];
        for (Review r : reviews) {
            int s = r.getRating();
            if (s >= 1 && s <= 5) dist[5 - s]++;
        }

        request.setAttribute("movieId", movieId);
        request.setAttribute("reviewList", reviews);
        request.setAttribute("averageRating", String.format(java.util.Locale.US, "%.1f", averageRating));
        request.setAttribute("reviewCount", reviews.size());
        request.setAttribute("ratingDist", dist);
        request.getRequestDispatcher("/WEB-INF/views/reviews.jsp").forward(request, response);
    }

    /**
     * Loads a review into an edit form.
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response, User loggedUser)
            throws ServletException, IOException {

        String movieId  = request.getParameter("movieId");
        String reviewId = request.getParameter("reviewId");

        if (movieId == null || reviewId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "movieId and reviewId are required.");
            return;
        }

        Review target = findReviewById(movieId, reviewId);
        if (target == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Review not found.");
            return;
        }

        if (isUnauthorizedToModerateReview(loggedUser, target)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You are not allowed to edit this review.");
            return;
        }

        // Determine if the 7-day edit window is still open (admins exempt)
        boolean editWindowOpen = "admin".equalsIgnoreCase(loggedUser.getRole())
                || ((FileReviewService) reviewService).isEditWindowOpen(target);

        request.setAttribute("editingReview", target);
        request.setAttribute("movieId", movieId);
        request.setAttribute("editWindowOpen", editWindowOpen);
        request.getRequestDispatcher("/WEB-INF/views/review-edit.jsp").forward(request, response);
    }

    /**
     * Creates a new review and chooses the correct class based on confirmed booking status.
     * Enforces the anti-duplicate rule: one review per (user x movie).
     */
    private void handleSubmit(HttpServletRequest request, HttpServletResponse response, User loggedUser)
            throws IOException {

        String movieId     = request.getParameter("movieId");
        String ratingStr   = request.getParameter("rating");
        String title       = request.getParameter("title");
        String body        = request.getParameter("body");
        String spoilerValue= request.getParameter("isSpoiler");

        if (movieId == null || movieId.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "movieId is required.");
            return;
        }

        // Anti-duplicate enforcement: one review per user per movie
        if (reviewService.hasUserReviewedMovie(loggedUser.getEmail(), movieId)) {
            response.sendRedirect(request.getContextPath()
                    + "/reviews?action=view&movieId=" + movieId + "&error=already_reviewed");
            return;
        }

        int rating = parseRating(ratingStr);
        if (rating < 1 || rating > 5) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "rating must be between 1 and 5.");
            return;
        }

        boolean spoiler          = "true".equalsIgnoreCase(spoilerValue) || "on".equalsIgnoreCase(spoilerValue);
        boolean verifiedBooking  = hasConfirmedBooking(request, loggedUser, movieId);

        Review review = verifiedBooking ? new VerifiedReview() : new PublicReview();
        review.setMovieId(movieId);
        review.setUserId(loggedUser.getEmail());
        review.setRating(rating);
        review.setTitle(title);
        review.setBody(body);
        review.setSpoiler(spoiler);
        review.setStatus("PENDING");
        review.setVerified(verifiedBooking);

        Review saved = reviewService.submitReview(review);
        if (saved == null) {
            response.sendRedirect(request.getContextPath()
                    + "/reviews?action=view&movieId=" + movieId + "&error=save_failed");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/reviews?action=view&movieId=" + movieId
                + "&success=review_submitted");
    }

    /**
     * Edits an existing review.
     * Enforces the 7-day edit window from the original submission date.
     */
    private void handleEdit(HttpServletRequest request, HttpServletResponse response, User loggedUser)
            throws IOException {

        String movieId    = request.getParameter("movieId");
        String reviewId   = request.getParameter("reviewId");
        String ratingStr  = request.getParameter("rating");
        String title      = request.getParameter("title");
        String body       = request.getParameter("body");
        String spoilerValue = request.getParameter("isSpoiler");

        if (movieId == null || reviewId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "movieId and reviewId are required.");
            return;
        }

        Review existing = findReviewById(movieId, reviewId);
        if (existing == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Review not found.");
            return;
        }

        if (isUnauthorizedToModerateReview(loggedUser, existing)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You are not allowed to edit this review.");
            return;
        }

        // 7-day edit window enforcement (admins are exempt)
        boolean withinWindow = "admin".equalsIgnoreCase(loggedUser.getRole())
                || ((FileReviewService) reviewService).isEditWindowOpen(existing);

        if (!withinWindow) {
            response.sendRedirect(request.getContextPath()
                    + "/reviews?action=myReviews&error=edit_window_expired");
            return;
        }

        int rating = parseRating(ratingStr);
        if (rating < 1 || rating > 5) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "rating must be between 1 and 5.");
            return;
        }

        Review updated = existing.isVerified() ? new VerifiedReview() : new PublicReview();
        updated.setReviewId(existing.getReviewId());
        updated.setMovieId(existing.getMovieId());
        updated.setUserId(existing.getUserId());
        updated.setRating(rating);
        updated.setTitle(title);
        updated.setBody(body);
        updated.setSpoiler("true".equalsIgnoreCase(spoilerValue) || "on".equalsIgnoreCase(spoilerValue));
        updated.setStatus("PENDING");
        updated.setVerified(existing.isVerified());

        if (reviewService.editReview(updated)) {
            response.sendRedirect(request.getContextPath()
                    + "/reviews?action=view&movieId=" + movieId + "&success=review_updated");
        } else {
            response.sendRedirect(request.getContextPath()
                    + "/reviews?action=editForm&movieId=" + movieId
                    + "&reviewId=" + reviewId + "&error=edit_failed");
        }
    }

    /**
     * Deletes a review. Enforces ownership or admin privilege.
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response, User loggedUser)
            throws IOException {

        String movieId  = request.getParameter("movieId");
        String reviewId = request.getParameter("reviewId");

        if (movieId == null || reviewId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "movieId and reviewId are required.");
            return;
        }

        Review existing = findReviewById(movieId, reviewId);
        if (existing == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Review not found.");
            return;
        }

        if (isUnauthorizedToModerateReview(loggedUser, existing)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You are not allowed to delete this review.");
            return;
        }

        String redirectAction = "admin".equalsIgnoreCase(loggedUser.getRole()) ? "adminReviews" : "myReviews";

        if (reviewService.deleteReview(reviewId)) {
            response.sendRedirect(request.getContextPath()
                    + "/reviews?action=" + redirectAction + "&success=review_deleted");
        } else {
            response.sendRedirect(request.getContextPath()
                    + "/reviews?action=" + redirectAction + "&error=delete_failed");
        }
    }

    /**
     * Shows only the logged-in user's reviews.
     */
    private void showMyReviews(HttpServletRequest request, HttpServletResponse response, User loggedUser)
            throws ServletException, IOException {

        List<Review> myReviews = new java.util.ArrayList<>();
        for (Review review : reviewService.getAllReviews()) {
            if (loggedUser.getEmail() != null
                    && loggedUser.getEmail().equalsIgnoreCase(review.getUserId())) {
                myReviews.add(review);
            }
        }

        request.setAttribute("myReviewList", myReviews);
        request.setAttribute("reviewCount", myReviews.size());
        request.getRequestDispatcher("/WEB-INF/views/my-reviews.jsp").forward(request, response);
    }

    /**
     * Shows all reviews for administrators with moderation controls.
     */
    private void showAdminReviews(HttpServletRequest request, HttpServletResponse response, User loggedUser)
            throws ServletException, IOException {

        if (!"admin".equalsIgnoreCase(loggedUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/UserController?action=login");
            return;
        }

        List<Review> allReviews = reviewService.getAllReviews();
        request.setAttribute("allReviewList", allReviews);
        request.setAttribute("reviewCount", allReviews.size());
        request.getRequestDispatcher("/WEB-INF/views/admin-reviews.jsp").forward(request, response);
    }

    /**
     * Handles admin moderation changes: PENDING, APPROVED, REJECTED, HIDDEN.
     */
    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response, User loggedUser)
            throws IOException {

        if (!"admin".equalsIgnoreCase(loggedUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Only administrators can update review status.");
            return;
        }

        String reviewId        = request.getParameter("reviewId");
        String status          = request.getParameter("status");
        String redirectMovieId = request.getParameter("movieId");

        if (reviewService.updateReviewStatus(reviewId, status)) {
            if (redirectMovieId != null && !redirectMovieId.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath()
                        + "/reviews?action=adminReviews&movieId=" + redirectMovieId);
            } else {
                response.sendRedirect(request.getContextPath() + "/reviews?action=adminReviews");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unable to update review status.");
        }
    }

    /**
     * Checks whether the logged-in user has a confirmed booking for this movie.
     * Used to determine VerifiedReview vs PublicReview.
     */
    private boolean hasConfirmedBooking(HttpServletRequest request, User loggedUser, String movieId) {
        if (loggedUser == null || movieId == null || movieId.trim().isEmpty()) return false;

        int movieNumericId;
        try {
            movieNumericId = Integer.parseInt(movieId.trim());
        } catch (NumberFormatException ex) {
            return false;
        }

        com.cinebooking.models.Movie movie;
        try {
            movie = movieService.getMovieById(movieNumericId);
        } catch (IOException e) {
            return false;
        }

        if (movie == null) return false;
        String movieTitle = movie.getTitle();
        if (movieTitle == null || movieTitle.trim().isEmpty()) return false;

        List<com.cinebooking.models.Booking> confirmedBookings =
                bookingService.getConfirmedBookingsByEmail(loggedUser.getEmail());
        for (com.cinebooking.models.Booking booking : confirmedBookings) {
            if (booking.getMovieName() != null
                    && booking.getMovieName().equalsIgnoreCase(movieTitle)) {
                return true;
            }
        }

        HttpSession session = request.getSession(false);
        if (session != null) {
            Object confirmedBookingMovies = session.getAttribute("confirmedBookingMovieTitles");
            if (confirmedBookingMovies instanceof List<?> list) {
                for (Object item : list) {
                    if (movieTitle.equalsIgnoreCase(String.valueOf(item))) return true;
                }
            }
        }
        return false;
    }

    /** Increments the helpful/upvote counter for a review. */
    private void handleUpvote(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String reviewId = request.getParameter("reviewId");
        String movieId  = request.getParameter("movieId");
        if (reviewId != null) reviewService.upvoteReview(reviewId);
        response.sendRedirect(request.getContextPath()
                + "/reviews?action=view&movieId=" + (movieId != null ? movieId : ""));
    }

    /** Records a user report on a review. Auto-hides at threshold 5. */
    private void handleReport(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String reviewId = request.getParameter("reviewId");
        String movieId  = request.getParameter("movieId");
        if (reviewId != null) reviewService.reportReview(reviewId);
        response.sendRedirect(request.getContextPath()
                + "/reviews?action=view&movieId=" + (movieId != null ? movieId : ""));
    }

    private User getLoggedUser(HttpSession session) {
        if (session == null) return null;
        Object user = session.getAttribute("user");
        return (user instanceof User) ? (User) user : null;
    }

    private int parseRating(String ratingStr) {
        try {
            return Integer.parseInt(ratingStr);
        } catch (Exception e) {
            return 0;
        }
    }

    /** Weighted average: Verified reviews carry 1.5x weight, Public carry 1.0x. */
    private double calculateAverageRating(List<Review> reviews) {
        if (reviews == null || reviews.isEmpty()) return 0.0;
        double weightedSum = 0.0, totalWeight = 0.0;
        for (Review review : reviews) {
            double w = review.isVerified() ? 1.5 : 1.0;
            weightedSum += review.getRating() * w;
            totalWeight += w;
        }
        return totalWeight == 0 ? 0.0 : weightedSum / totalWeight;
    }

    private Review findReviewById(String movieId, String reviewId) {
        // Search all reviews to support admin operations across movies
        for (Review review : reviewService.getAllReviews()) {
            if (reviewId.equals(review.getReviewId())) return review;
        }
        return null;
    }

    private boolean isUnauthorizedToModerateReview(User loggedUser, Review review) {
        if (loggedUser == null || review == null) return true;
        if ("admin".equalsIgnoreCase(loggedUser.getRole())) return false;
        return loggedUser.getEmail() == null
                || !loggedUser.getEmail().equalsIgnoreCase(review.getUserId());
    }
}
