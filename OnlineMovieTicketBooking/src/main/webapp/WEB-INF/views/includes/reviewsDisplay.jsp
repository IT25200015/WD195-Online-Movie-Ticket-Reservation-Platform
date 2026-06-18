<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cinebooking.models.Review" %>
<%@ page import="com.cinebooking.models.User" %>
<%
    // Retrieve movieId from attributes or parameter
    String movieId = request.getParameter("movieId");
    if (movieId == null) {
        movieId = (String) request.getAttribute("movieId");
    }

    // Retrieve reviews list - ensure these are filtered by movieId
    List<Review> reviewList = (List<Review>) request.getAttribute("reviewList");
    String averageRating = (String) request.getAttribute("averageRating");
    int reviewCount = (Integer) request.getAttribute("reviewCount");

    // Get logged-in user
    User loggedUser = (User) session.getAttribute("user");
%>

<!-- REVIEWS SECTION: Display reviews strictly filtered by movieId -->
<div class="mt-5 pt-4 border-top border-secondary">

    <!-- Reviews Header -->
    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
        <div>
            <h3 class="mb-1">User Reviews</h3>
            <p class="text-secondary mb-0">Read what other viewers think about this film.</p>
        </div>
        <div>
            <p class="text-secondary mb-2">
                <strong>Average Rating:</strong> <strong style="color: #e50914;"><%= averageRating != null ? averageRating : "N/A" %></strong>
                from <strong><%= reviewCount %></strong> review(s)
            </p>
            <% if (loggedUser != null) { %>
                <button type="button" class="btn btn-outline-danger btn-sm" data-bs-toggle="modal" data-bs-target="#reviewModal">
                    ★ Write a Review
                </button>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/UserController?action=login" class="btn btn-outline-danger btn-sm">
                    ★ Login to Review
                </a>
            <% } %>
        </div>
    </div>

    <!-- Reviews List: Only show reviews for this specific movieId -->
    <div>
        <%
            if (reviewList == null || reviewList.isEmpty()) {
        %>
            <div class="alert alert-dark border-secondary">
                <em>No reviews have been submitted yet. Be the first to share your thoughts!</em>
            </div>
        <%
            } else {
                // Filter reviews strictly by movieId before displaying
                for (Review review : reviewList) {
                    // Double-check: only display if movieId matches
                    if (review.getMovieId() != null && review.getMovieId().equals(movieId)) {
                        out.print(review.getDisplayCard());
                    }
                }
            }
        %>
    </div>
</div>

<!-- SUBMIT REVIEW MODAL -->
<div class="modal fade" id="reviewModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content bg-dark text-light border-secondary">

            <div class="modal-header border-secondary">
                <h5 class="modal-title">Write a Review for <%= request.getAttribute("movie") != null ?
                    ((com.cinebooking.models.Movie) request.getAttribute("movie")).getTitle() : "" %></h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body">
                <form method="post" action="${pageContext.request.contextPath}/reviews" class="row g-3">
                    <!-- Hidden fields -->
                    <input type="hidden" name="action" value="submit">
                    <input type="hidden" name="movieId" value="<%= movieId != null ? movieId : "" %>">

                    <!-- Rating -->
                    <div class="col-md-6">
                        <label class="form-label">Rating <span style="color: #e50914;">*</span></label>
                        <select name="rating" class="form-select" style="background: #222; border: 1px solid #333; color: #f5f5f5;" required>
                            <option value="">Select a rating...</option>
                            <option value="5">★★★★★ 5 - Excellent</option>
                            <option value="4">★★★★☆ 4 - Very Good</option>
                            <option value="3">★★★☆☆ 3 - Good</option>
                            <option value="2">★★☆☆☆ 2 - Fair</option>
                            <option value="1">★☆☆☆☆ 1 - Poor</option>
                        </select>
                    </div>

                    <!-- Title -->
                    <div class="col-md-6">
                        <label class="form-label">Review Title <span style="color: #e50914;">*</span></label>
                        <input type="text" name="title" class="form-control"
                               style="background: #222; border: 1px solid #333; color: #f5f5f5;"
                               maxlength="120" placeholder="Summarize your review..." required>
                    </div>

                    <!-- Body -->
                    <div class="col-12">
                        <label class="form-label">Your Review <span style="color: #e50914;">*</span></label>
                        <textarea name="body" rows="5" class="form-control"
                                  style="background: #222; border: 1px solid #333; color: #f5f5f5;"
                                  maxlength="2000" placeholder="Share your thoughts about this movie..." required></textarea>
                        <small class="text-secondary">Maximum 2000 characters</small>
                    </div>

                    <!-- Spoiler checkbox -->
                    <div class="col-12 form-check">
                        <input class="form-check-input" type="checkbox" name="isSpoiler" id="spoilerCheckModal">
                        <label class="form-check-label" for="spoilerCheckModal">
                            ⚠️ This review contains spoilers
                        </label>
                    </div>

                    <!-- Submit button -->
                    <div class="col-12">
                        <button type="submit" class="btn btn-danger w-100">
                            Post Review
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

