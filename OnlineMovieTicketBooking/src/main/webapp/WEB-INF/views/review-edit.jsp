<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.cinebooking.models.Review" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Edit Review - CineBooking</title>
    <jsp:include page="/includes/header.jsp" />
    <style>
        body {
            background-color: #121212;
            color: #f5f5f5;
            font-family: 'Poppins', sans-serif;
        }

        .form-container {
            background-color: #1a1a1a;
            border: 1px solid #2a2a2a;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.35);
            padding: 2.5rem;
            max-width: 700px;
            margin: 0 auto;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            font-weight: 600;
            color: #f5f5f5;
            margin-bottom: 0.75rem;
            display: block;
        }

        .form-control,
        .form-select {
            background-color: #2a2a2a;
            border: 1px solid #404040;
            color: #f5f5f5;
            border-radius: 12px;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            transition: all 0.25s ease;
        }

        .form-control:focus,
        .form-select:focus {
            background-color: #2a2a2a;
            border-color: #e50914;
            color: #f5f5f5;
            box-shadow: 0 0 0 0.2rem rgba(229, 9, 20, 0.25);
        }

        .form-control::placeholder {
            color: #999999;
        }

        .star-rating {
            font-size: 2rem;
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }

        .star-rating i {
            cursor: pointer;
            color: #d4af37;
            transition: transform 0.2s ease;
        }

        .star-rating i:hover {
            transform: scale(1.2);
        }

        .spoiler-checkbox {
            width: 18px;
            height: 18px;
            margin-right: 0.5rem;
            cursor: pointer;
        }

        .checkbox-label {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
            color: #f5f5f5;
            font-weight: 500;
        }

        .btn-primary {
            background-color: #e50914;
            border-color: #e50914;
            color: #ffffff;
            font-weight: 600;
            padding: 0.75rem 2rem;
            border-radius: 12px;
            transition: all 0.25s ease;
        }

        .btn-primary:hover,
        .btn-primary:focus {
            background-color: #cc0812;
            border-color: #cc0812;
            transform: scale(1.02);
            box-shadow: 0 10px 20px rgba(229, 9, 20, 0.35);
            color: #ffffff;
        }

        .btn-outline-secondary {
            color: #b9b9b9;
            border-color: #404040;
            font-weight: 600;
            padding: 0.75rem 2rem;
            border-radius: 12px;
            transition: all 0.25s ease;
        }

        .btn-outline-secondary:hover {
            background-color: #2a2a2a;
            border-color: #b9b9b9;
            color: #b9b9b9;
        }

        .form-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .form-subtitle {
            color: #b9b9b9;
            margin-bottom: 2rem;
            font-size: 1rem;
        }

        .alert-danger {
            background-color: rgba(220, 53, 69, 0.1);
            border: 1px solid #dc3545;
            color: #f5a5a5;
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }

        .textarea-counter {
            font-size: 0.85rem;
            color: #999999;
            margin-top: 0.5rem;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">

<jsp:include page="/includes/navbar.jsp" />

<main class="container py-5 flex-grow-1">
    <%
        Review editingReview = (Review) request.getAttribute("editingReview");
        String movieId = (String) request.getAttribute("movieId");

        if (editingReview == null) {
    %>
        <div class="alert alert-danger">
            <i class="bi bi-exclamation-circle"></i> Review not found.
        </div>
        <a href="${pageContext.request.contextPath}/reviews?action=myReviews" class="btn btn-outline-light">Back to My Reviews</a>
    <%
        } else {
    %>
        <div class="form-container">
            <div class="mb-4">
                <h1 class="form-title">✏️ Edit Your Review</h1>
                <p class="form-subtitle">Update your thoughts about this movie</p>
            </div>

            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-danger">
                    <i class="bi bi-exclamation-triangle-fill"></i> An error occurred while updating your review. Please try again.
                </div>
            <% } %>

            <form method="post" action="${pageContext.request.contextPath}/reviews" class="needs-validation">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="movieId" value="<%= movieId %>">
                <input type="hidden" name="reviewId" value="<%= editingReview.getReviewId() %>">

                <!-- Rating Section -->
                <div class="form-group">
                    <label class="form-label">Rating (1-5 stars)</label>
                    <div class="star-rating" id="ratingInput">
                        <input type="hidden" name="rating" id="ratingValue" value="<%= editingReview.getRating() %>">
                        <i class="bi bi-star-fill" data-rating="1" style="cursor: pointer;"></i>
                        <i class="bi bi-star-fill" data-rating="2" style="cursor: pointer;"></i>
                        <i class="bi bi-star-fill" data-rating="3" style="cursor: pointer;"></i>
                        <i class="bi bi-star-fill" data-rating="4" style="cursor: pointer;"></i>
                        <i class="bi bi-star-fill" data-rating="5" style="cursor: pointer;"></i>
                    </div>
                    <small class="text-secondary">Click stars to set your rating</small>
                </div>

                <!-- Title -->
                <div class="form-group">
                    <label for="reviewTitle" class="form-label">Review Title</label>
                    <input type="text" class="form-control" id="reviewTitle" name="title"
                           value="<%= editingReview.getTitle() %>" maxlength="100" required>
                    <small class="text-secondary">Brief headline for your review (max 100 characters)</small>
                </div>

                <!-- Review Body -->
                <div class="form-group">
                    <label for="reviewBody" class="form-label">Your Review</label>
                    <textarea class="form-control" id="reviewBody" name="body" rows="6"
                              maxlength="1000" required><%= editingReview.getBody() %></textarea>
                    <div class="textarea-counter">
                        <span id="charCount">0</span> / 1000 characters
                    </div>
                    <small class="text-secondary">Share your detailed thoughts about the movie</small>
                </div>

                <!-- Spoiler Warning -->
                <div class="form-group">
                    <label class="checkbox-label">
                        <input type="checkbox" class="spoiler-checkbox" name="isSpoiler" value="true"
                               <% if (editingReview.isSpoiler()) { %> checked <% } %>>
                        <span><i class="bi bi-exclamation-circle"></i> This review contains spoilers</span>
                    </label>
                </div>

                <!-- Status Info -->
                <div class="form-group">
                    <div style="background-color: #2a2a2a; border: 1px solid #404040; border-radius: 12px; padding: 1rem;">
                        <small class="text-secondary d-block mb-2"><i class="bi bi-info-circle"></i> Review Status Information</small>
                        <p class="mb-0" style="font-size: 0.95rem;">
                            Status: <strong class="text-warning"><%= editingReview.getStatus() %></strong>
                        </p>
                        <% if (editingReview.isVerified()) { %>
                            <p class="mb-0" style="font-size: 0.95rem;">
                                <span class="badge bg-success">✓ Verified Booking</span> - This review is from a confirmed ticket purchase
                            </p>
                        <% } %>
                        <p class="mb-0" style="font-size: 0.95rem; color: #999999; margin-top: 0.5rem;">
                            Created: <%= editingReview.getSubmissionDate() %>
                        </p>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="d-flex gap-3 mt-4">
                    <button type="submit" class="btn btn-primary flex-fill">
                        <i class="bi bi-check-lg"></i> Save Changes
                    </button>
                    <a href="${pageContext.request.contextPath}/reviews?action=myReviews" class="btn btn-outline-secondary flex-fill">
                        <i class="bi bi-x-lg"></i> Cancel
                    </a>
                </div>
            </form>
        </div>
    <%
        }
    %>
</main>

<jsp:include page="/includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Star rating system
    document.addEventListener('DOMContentLoaded', function() {
        const stars = document.querySelectorAll('#ratingInput i');
        const ratingInput = document.getElementById('ratingValue');
        const currentRating = parseInt(ratingInput.value) || 0;

        function updateStars(rating) {
            stars.forEach((star, index) => {
                if (index < rating) {
                    star.classList.add('bi-star-fill');
                    star.classList.remove('bi-star');
                } else {
                    star.classList.remove('bi-star-fill');
                    star.classList.add('bi-star');
                }
            });
        }

        // Set initial rating display
        updateStars(currentRating);

        // Click handler for star rating
        stars.forEach(star => {
            star.addEventListener('click', function() {
                const rating = this.getAttribute('data-rating');
                ratingInput.value = rating;
                updateStars(rating);
            });

            star.addEventListener('mouseover', function() {
                const rating = this.getAttribute('data-rating');
                updateStars(rating);
            });
        });

        document.getElementById('ratingInput').addEventListener('mouseleave', function() {
            updateStars(ratingInput.value);
        });

        // Character counter for textarea
        const textarea = document.getElementById('reviewBody');
        const charCount = document.getElementById('charCount');
        textarea.addEventListener('input', function() {
            charCount.textContent = this.value.length;
        });
        charCount.textContent = textarea.value.length;
    });
</script>
</body>
</html>

