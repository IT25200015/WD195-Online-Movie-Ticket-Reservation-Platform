<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cinebooking.models.Review" %>
<%@ page import="com.cinebooking.models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Movie Reviews - CineBooking</title>
    <jsp:include page="/includes/header.jsp" />
    <style>
        body {
            background-color: #121212;
            color: #f5f5f5;
            font-family: 'Poppins', sans-serif;
        }

        .review-header {
            background: linear-gradient(135deg, #1a1a1a 0%, #2a2a2a 100%);
            border: 1px solid #2a2a2a;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.35);
            padding: 2.5rem;
            margin-bottom: 2rem;
        }

        .rating-display {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .rating-score {
            font-size: 3rem;
            font-weight: 700;
            color: #e50914;
        }

        .rating-stars {
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        .rating-stars i {
            color: #d4af37;
            font-size: 1.5rem;
        }

        .rating-stats {
            color: #b9b9b9;
            font-size: 0.95rem;
        }

        .add-review-btn {
            background-color: #e50914;
            color: #ffffff;
            border-radius: 12px;
            padding: 0.75rem 1.5rem;
            border: none;
            font-weight: 600;
            transition: all 0.25s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .add-review-btn:hover {
            background-color: #cc0812;
            transform: scale(1.05);
            box-shadow: 0 10px 20px rgba(229, 9, 20, 0.35);
            color: #ffffff;
            text-decoration: none;
        }

        .review-card {
            background-color: #1a1a1a;
            border: 1px solid #2a2a2a;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.35);
            padding: 1.75rem;
            margin-bottom: 1.5rem;
            transition: all 0.25s ease;
        }

        .review-card:hover {
            border-color: #e50914;
            box-shadow: 0 15px 40px rgba(229, 9, 20, 0.2);
        }

        .review-header-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 1rem;
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }

        .review-title {
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: #f5f5f5;
        }

        .review-author {
            font-size: 0.95rem;
            color: #b9b9b9;
            margin-bottom: 0.75rem;
        }

        .review-meta {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            align-items: center;
            margin-bottom: 1rem;
        }

        .review-rating {
            display: flex;
            gap: 0.25rem;
            font-size: 1.25rem;
        }

        .review-rating i {
            color: #d4af37;
        }

        .badge-custom {
            display: inline-block;
            padding: 0.35rem 0.75rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .badge-pending {
            background-color: rgba(255, 193, 7, 0.2);
            color: #ffc107;
            border: 1px solid #ffc107;
        }

        .badge-approved {
            background-color: rgba(25, 135, 84, 0.2);
            color: #198754;
            border: 1px solid #198754;
        }

        .badge-rejected {
            background-color: rgba(220, 53, 69, 0.2);
            color: #dc3545;
            border: 1px solid #dc3545;
        }

        .badge-verified {
            background-color: rgba(13, 110, 253, 0.2);
            color: #0d6efd;
            border: 1px solid #0d6efd;
        }

        .badge-spoiler {
            background-color: rgba(220, 53, 69, 0.2);
            color: #dc3545;
            border: 1px solid #dc3545;
        }

        .review-body {
            font-size: 1rem;
            line-height: 1.6;
            color: #e0e0e0;
            margin-bottom: 1rem;
        }

        .review-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
            padding-top: 1rem;
            border-top: 1px solid #2a2a2a;
        }

        .review-timestamp {
            font-size: 0.9rem;
            color: #999999;
        }

        .empty-state {
            background-color: #1a1a1a;
            border: 2px dashed #404040;
            border-radius: 18px;
            padding: 3rem 2rem;
            text-align: center;
        }

        .empty-state-icon {
            font-size: 3rem;
            color: #404040;
            margin-bottom: 1rem;
        }

        .empty-state-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #f5f5f5;
            margin-bottom: 0.5rem;
        }

        .empty-state-text {
            color: #b9b9b9;
            margin-bottom: 1.5rem;
        }

        .page-title-section {
            margin-bottom: 2rem;
        }

        .page-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .page-subtitle {
            color: #b9b9b9;
            margin-bottom: 0;
        }

        .sort-filter-bar {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            align-items: center;
        }

        .filter-select {
            background-color: #1a1a1a;
            border: 1px solid #2a2a2a;
            color: #f5f5f5;
            padding: 0.5rem 1rem;
            border-radius: 12px;
            cursor: pointer;
        }

        .filter-select:focus {
            outline: none;
            border-color: #e50914;
            box-shadow: 0 0 0 2px rgba(229, 9, 20, 0.2);
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">

<jsp:include page="/includes/navbar.jsp" />

<main class="container py-5 flex-grow-1">
    <%
        String movieId = (String) request.getAttribute("movieId");
        List<Review> reviewList = (List<Review>) request.getAttribute("reviewList");
        String averageRating = (String) request.getAttribute("averageRating");
        Integer reviewCount = (Integer) request.getAttribute("reviewCount");

        User loggedUser = (User) session.getAttribute("user");
        boolean isLoggedIn = loggedUser != null;

        if (reviewCount == null) reviewCount = 0;
        if (averageRating == null) averageRating = "0.00";
    %>

    <!-- Page Header -->
    <div class="page-title-section">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
            <div>
                <h1 class="page-title">🎬 Reviews</h1>
                <p class="page-subtitle">See what other movie lovers think about this film</p>
            </div>
            <% if (isLoggedIn) { %>
                <button type="button" class="add-review-btn" data-bs-toggle="modal" data-bs-target="#reviewModal">
                    <i class="bi bi-pencil-square"></i> Add Your Review
                </button>
            <% } %>
        </div>
    </div>

    <!-- Rating Summary Card -->
    <div class="review-header">
        <div class="rating-display">
            <div class="rating-score"><%= averageRating %></div>
            <div>
                <div class="rating-stars">
                    <%
                        double avgRating = Double.parseDouble(averageRating);
                        for (int i = 1; i <= 5; i++) {
                    %>
                        <i class="bi <%= i <= (int)avgRating ? "bi-star-fill" : "bi-star" %>"></i>
                    <%
                        }
                    %>
                </div>
                <div class="rating-stats">
                    <strong><%= reviewCount %></strong> review<%= reviewCount != 1 ? "s" : "" %>
                </div>
            </div>
        </div>
        <p class="text-secondary mb-0">
            <i class="bi bi-info-circle"></i>
            Based on <%= reviewCount %> community review<%= reviewCount != 1 ? "s" : "" %> from verified and public submissions.
        </p>
    </div>

    <!-- Reviews List -->
    <%
        if (reviewList == null || reviewList.isEmpty()) {
    %>
        <div class="empty-state">
            <div class="empty-state-icon">
                <i class="bi bi-chat-dots"></i>
            </div>
            <div class="empty-state-title">No reviews yet</div>
            <p class="empty-state-text">Be the first to share your thoughts about this movie!</p>
            <% if (isLoggedIn) { %>
                <button type="button" class="add-review-btn" data-bs-toggle="modal" data-bs-target="#reviewModal">
                    <i class="bi bi-pencil-square"></i> Write a Review
                </button>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/UserController?action=login" class="add-review-btn">
                    <i class="bi bi-box-arrow-in-right"></i> Login to Review
                </a>
            <% } %>
        </div>
    <%
        } else {
            for (Review review : reviewList) {
                String status = review.getStatus() == null ? "PENDING" : review.getStatus();
                String statusBadgeClass = "badge-pending";
                if ("APPROVED".equalsIgnoreCase(status)) statusBadgeClass = "badge-approved";
                else if ("REJECTED".equalsIgnoreCase(status)) statusBadgeClass = "badge-rejected";

                // Only show APPROVED reviews to regular users, all reviews to admins
                boolean isAdmin = isLoggedIn && "Admin".equalsIgnoreCase(loggedUser.getRole());
                if (!isAdmin && !"APPROVED".equalsIgnoreCase(status)) {
                    continue;
                }
    %>
        <div class="review-card">
            <div class="review-header-row">
                <div style="flex: 1; min-width: 200px;">
                    <h5 class="review-title"><%= review.getTitle() %></h5>
                    <p class="review-author">
                        <i class="bi bi-person-circle"></i>
                        <%= review.getUserId() %>
                    </p>
                </div>
                <div style="text-align: right;">
                    <div class="review-rating">
                        <%
                            for (int i = 1; i <= 5; i++) {
                        %>
                            <i class="bi <%= i <= review.getRating() ? "bi-star-fill" : "bi-star" %>"></i>
                        <%
                            }
                        %>
                    </div>
                    <small class="review-meta" style="display: block;">Rating: <%= review.getRating() %>/5</small>
                </div>
            </div>

            <div class="review-meta">
                <span class="badge-custom <%= statusBadgeClass %>">
                    <% if ("APPROVED".equalsIgnoreCase(status)) { %>
                        <i class="bi bi-check-circle"></i>
                    <% } else if ("PENDING".equalsIgnoreCase(status)) { %>
                        <i class="bi bi-hourglass-split"></i>
                    <% } else { %>
                        <i class="bi bi-x-circle"></i>
                    <% } %>
                    <%= status %>
                </span>
                <% if (review.isVerified()) { %>
                    <span class="badge-custom badge-verified">
                        <i class="bi bi-check2-circle"></i> Verified Booking
                    </span>
                <% } %>
                <% if (review.isSpoiler()) { %>
                    <span class="badge-custom badge-spoiler">
                        <i class="bi bi-exclamation-triangle"></i> Spoiler Alert
                    </span>
                <% } %>
            </div>

            <p class="review-body"><%= review.getBody() %></p>

            <div class="review-footer">
                <div>
                    <div class="review-timestamp">
                        <i class="bi bi-calendar-event"></i>
                        Submitted: <%= review.getSubmissionDate() %>
                    </div>
                    <% if (review.getEditDate() != null && !review.getEditDate().isEmpty()) { %>
                        <div class="review-timestamp">
                            <i class="bi bi-pencil"></i>
                            Edited: <%= review.getEditDate() %>
                        </div>
                    <% } %>
                </div>
                <%
                    boolean isReviewAuthor = isLoggedIn && loggedUser.getEmail() != null &&
                                            loggedUser.getEmail().equalsIgnoreCase(review.getUserId());
                    if (isReviewAuthor) {
                %>
                    <div style="display: flex; gap: 0.5rem;">
                        <a href="${pageContext.request.contextPath}/reviews?action=editForm&movieId=<%= review.getMovieId() %>&reviewId=<%= review.getReviewId() %>"
                           class="btn btn-sm btn-outline-warning" title="Edit this review">
                            <i class="bi bi-pencil"></i> Edit
                        </a>
                        <form method="post" action="${pageContext.request.contextPath}/reviews" style="display: inline;"
                              onsubmit="return confirm('Are you sure you want to delete this review?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="movieId" value="<%= review.getMovieId() %>">
                            <input type="hidden" name="reviewId" value="<%= review.getReviewId() %>">
                            <button type="submit" class="btn btn-sm btn-outline-danger" title="Delete this review">
                                <i class="bi bi-trash"></i> Delete
                            </button>
                        </form>
                    </div>
                <% } %>
            </div>
        </div>
    <%
            }
        }
    %>
</main>

<% if (isLoggedIn) { %>
<div class="modal fade" id="reviewModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content bg-dark text-light border-secondary">
            <div class="modal-header border-secondary">
                <h5 class="modal-title">Write a Review</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form method="post" action="${pageContext.request.contextPath}/reviews" class="row g-3">
                    <input type="hidden" name="action" value="submit">
                    <input type="hidden" name="movieId" value="<%= movieId %>">
                    <div class="col-md-6">
                        <label class="form-label">Rating</label>
                        <select name="rating" class="form-select" required>
                            <option value="5">5 - Excellent</option>
                            <option value="4">4 - Very Good</option>
                            <option value="3">3 - Good</option>
                            <option value="2">2 - Fair</option>
                            <option value="1">1 - Poor</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Title</label>
                        <input type="text" name="title" class="form-control" maxlength="120" required>
                    </div>
                    <div class="col-12">
                        <label class="form-label">Review</label>
                        <textarea name="body" rows="5" class="form-control" maxlength="2000" required></textarea>
                    </div>
                    <div class="col-12 form-check">
                        <input class="form-check-input" type="checkbox" name="isSpoiler" id="reviewSpoilerCheck">
                        <label class="form-check-label" for="reviewSpoilerCheck">Contains spoilers</label>
                    </div>
                    <div class="col-12 d-flex justify-content-end gap-2">
                        <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">Post Review</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<% } %>

<jsp:include page="/includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

