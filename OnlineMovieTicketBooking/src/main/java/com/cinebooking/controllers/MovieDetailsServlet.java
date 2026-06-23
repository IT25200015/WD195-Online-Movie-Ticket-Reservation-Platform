package com.cinebooking.controllers;

import com.cinebooking.models.Movie;
import com.cinebooking.models.Review;
import com.cinebooking.services.FileReviewService;
import com.cinebooking.services.MovieService;
import com.cinebooking.services.IReviewService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/movie-details")
public class MovieDetailsServlet
        extends HttpServlet {

    private MovieService movieService;
    private IReviewService reviewService;

    @Override
    public void init() {

        String path =
                getServletContext()
                        .getRealPath("/data/movies.txt");
        String reviewsPath = getServletContext().getRealPath("/data/reviews.txt");
        String ratingsPath = getServletContext().getRealPath("/data/ratings.txt");

        movieService = new MovieService(path);
        reviewService = new FileReviewService(reviewsPath, ratingsPath);
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String movieIdParam = request.getParameter("movieId");
        if (movieIdParam == null || movieIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "movieId is required.");
            return;
        }

        int movieId;
        try {
            movieId = Integer.parseInt(movieIdParam.trim());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "movieId must be numeric.");
            return;
        }

        Movie movie =
                movieService.getMovieById(movieId);

        if (movie == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Movie not found.");
            return;
        }

        request.setAttribute("movie", movie);
        request.setAttribute("movieId", String.valueOf(movieId));
        List<Review> reviewList = reviewService.getMovieReviews(String.valueOf(movieId));
        request.setAttribute("reviewList", reviewList);
        request.setAttribute("reviewCount", reviewList.size());

        // Standard average
        double avg = reviewList.stream().mapToDouble(Review::getRating).average().orElse(0.0);
        request.setAttribute("averageRating",
                String.format(java.util.Locale.US, "%.1f", avg));

        // Weighted average (VerifiedReview = 1.5x)
        double wAvg = reviewService.getWeightedAverageRating(String.valueOf(movieId));
        request.setAttribute("weightedAverageRating",
                String.format(java.util.Locale.US, "%.1f", wAvg));

        // Rating distribution counts [star5, star4, star3, star2, star1]
        int[] dist = new int[5];
        for (Review r : reviewList) {
            int s = r.getRating();
            if (s >= 1 && s <= 5) dist[5 - s]++;
        }
        request.setAttribute("ratingDist", dist);

        // Forward to WEB-INF so JSP directives are parsed properly
        request.getRequestDispatcher("/WEB-INF/views/movieDetails.jsp")
                .forward(request, response);
    }
}