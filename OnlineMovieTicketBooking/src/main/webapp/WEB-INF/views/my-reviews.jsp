<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<%@ page import="com.cinebooking.models.Review" %>
<%@ page import="com.cinebooking.models.User" %>
<%@ page import="com.cinebooking.models.PublicReview" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>My Reviews – CineBooking</title>
    <meta name="description" content="View and manage all reviews you have submitted on CineBooking.">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <style>
        :root {
            --cinema-bg: #0e0e0e;
            --cinema-surface: #181818;
            --cinema-accent: #e50914;
            --cinema-text: #f5f5f5;
            --cinema-muted: #aaa;
            --cinema-gold: #d4af37;
        }
        body {
            background-color: var(--cinema-bg);
            color: var(--cinema-text);
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
        }
        .page-header {
            background: linear-gradient(135deg, #181818 0%, #222 100%);
            border: 1px solid #252525;
            border-radius: 20px;
            padding: 32px;
            margin-bottom: 32px;
        }
        .stat-pill {
            background: rgba(229,9,20,0.1);
            border: 1px solid rgba(229,9,20,0.3);
            color: #f55;
            padding: 6px 16px;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        .review-card {
            background: var(--cinema-surface);
            border: 1px solid #252525;
            border-radius: 18px;
            padding: 24px;
            margin-bottom: 20px;
            transition: border-color 0.25s, box-shadow 0.25s;
        }
        .review-card:hover {
            border-color: rgba(229,9,20,0.35);
            box-shadow: 0 10px 32px rgba(229,9,20,0.1);
        }
        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.78rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .s-pending  { background: rgba(255,193,7,0.15);  color: #ffc107; border: 1px solid #ffc107; }
        .s-approved { background: rgba(25,135,84,0.2);   color: #75b798; border: 1px solid #198754; }
        .s-rejected { background: rgba(220,53,69,0.2);   color: #ea868f; border: 1px solid #dc3545; }
        .s-hidden   { background: rgba(108,117,125,0.2); color: #adb5bd; border: 1px solid #6c757d; }
        .star-rating i { color: var(--cinema-gold); font-size: 1rem; }
        .edit-window-open   { color: #75b798; font-size: 0.8rem; }
        .edit-window-closed { color: #ea868f; font-size: 0.8rem; }
        .meta-row { color: var(--cinema-muted); font-size: 0.82rem; }
        .empty-state { background: var(--cinema-surface); border: 2px dashed #333; border-radius: 18px; padding: 48px; text-align: center; }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">

<jsp:include page="/includes/navbar.jsp" />

<%
    User loggedUser = (User) session.getAttribute("user");
    List<Review> myReviewList = (List<Review>) request.getAttribute("myReviewList");
    Integer reviewCount = (Integer) request.getAttribute("reviewCount");
    if (reviewCount == null) reviewCount = 0;

    String error   = request.getParameter("error");
    String success = request.getParameter("success");
%>

<main class="container py-5 flex-grow-1">

    <!-- Page Header -->
    <div class="page-header">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
            <div>
                <h1 class="h2 fw-bold mb-1">
                    <i class="bi bi-chat-dots-fill me-2" style="color:#e50914;"></i>My Reviews
                </h1>
                <p class="text-secondary mb-0">Manage the reviews you've submitted to CineBooking.</p>
            </div>
            <div class="d-flex align-items-center gap-3 flex-wrap">
                <span class="stat-pill"><%= reviewCount %> Review<%= reviewCount != 1 ? "s" : "" %></span>
                <a href="${pageContext.request.contextPath}/movies" class="btn btn-outline-light btn-sm">
                    <i class="bi bi-collection-play"></i> Browse Movies
                </a>
            </div>
        </div>
    </div>

    <!-- Alerts -->
    <% if ("edit_window_expired".equals(error)) { %>
    <div class="alert alert-warning d-flex align-items-center gap-2">
        <i class="bi bi-clock-history"></i>
        <span>The 7-day edit window for this review has expired. You can no longer edit it.</span>
    </div>
    <% } else if ("delete_failed".equals(error)) { %>
    <div class="alert alert-danger">Failed to delete the review. Please try again.</div>
    <% } else if ("review_deleted".equals(success)) { %>
    <div class="alert alert-success"><i class="bi bi-check-circle me-2"></i>Review deleted successfully.</div>
    <% } %>

    <!-- Review Cards -->
    <%
        if (myReviewList == null || myReviewList.isEmpty()) {
    %>
    <div class="empty-state">
        <i class="bi bi-chat-dots" style="font-size:3rem; color:#444; display:block; margin-bottom:14px;"></i>
        <h4 class="fw-semibold mb-2">No reviews yet</h4>
        <p class="text-secondary mb-3">Share your thoughts about movies you've watched!</p>
        <a href="${pageContext.request.contextPath}/movies" class="btn btn-danger">
            <i class="bi bi-collection-play me-1"></i> Browse Movies
        </a>
    </div>
    <%
        } else {
            for (Review review : myReviewList) {
                String status = review.getStatus() == null ? "PENDING" : review.getStatus();
                String badgeClass = "s-pending";
                if      ("APPROVED".equalsIgnoreCase(status))  badgeClass = "s-approved";
                else if ("REJECTED".equalsIgnoreCase(status))  badgeClass = "s-rejected";
                else if ("HIDDEN".equalsIgnoreCase(status))    badgeClass = "s-hidden";

                // Determine 7-day edit window
                boolean withinWindow = true;
                int daysLeft = 7;
                try {
                    String sub = review.getSubmissionDate();
                    if (sub != null && sub.length() >= 10) {
                        LocalDate submitted = LocalDate.parse(sub.substring(0, 10));
                        long daysSince = ChronoUnit.DAYS.between(submitted, LocalDate.now());
                        daysLeft = (int)(7 - daysSince);
                        withinWindow = daysSince <= 7;
                    }
                } catch (Exception ignored) {}
    %>
    <div class="review-card" id="review-<%= review.getReviewId() %>">
        <div class="d-flex justify-content-between align-items-start flex-wrap gap-3">
            <div style="flex:1; min-width:220px;">
                <h5 class="fw-semibold mb-1"><%= PublicReview.escapeStatic(review.getTitle()) %></h5>
                <div class="meta-row mb-2">
                    Movie ID: <strong><%= review.getMovieId() %></strong>
                    &bull; Review ID: <code style="color:#888;font-size:0.75rem;"><%= review.getReviewId() %></code>
                </div>

                <!-- Status badges -->
                <div class="d-flex flex-wrap gap-2 mb-2">
                    <span class="status-badge <%= badgeClass %>">
                        <% if ("APPROVED".equalsIgnoreCase(status)) { %>
                        <i class="bi bi-check-circle-fill"></i>
                        <% } else if ("PENDING".equalsIgnoreCase(status)) { %>
                        <i class="bi bi-hourglass-split"></i>
                        <% } else if ("REJECTED".equalsIgnoreCase(status)) { %>
                        <i class="bi bi-x-circle-fill"></i>
                        <% } else { %>
                        <i class="bi bi-eye-slash-fill"></i>
                        <% } %>
                        <%= status %>
                    </span>
                    <% if (review.isVerified()) { %>
                    <span class="status-badge" style="background:rgba(13,110,253,0.2);color:#6ea8fe;border:1px solid #0d6efd;">
                        <i class="bi bi-check2-circle"></i> Verified Booking
                    </span>
                    <% } %>
                    <% if (review.isSpoiler()) { %>
                    <span class="status-badge s-rejected">
                        <i class="bi bi-exclamation-triangle"></i> Spoiler
                    </span>
                    <% } %>
                </div>

                <!-- 7-day edit window indicator -->
                <% if (withinWindow) { %>
                <div class="edit-window-open">
                    <i class="bi bi-pencil-square"></i>
                    Edit window open &mdash; <strong><%= daysLeft %></strong> day<%= daysLeft != 1 ? "s" : "" %> remaining
                </div>
                <% } else { %>
                <div class="edit-window-closed">
                    <i class="bi bi-lock-fill"></i> Edit window closed (7-day limit exceeded)
                </div>
                <% } %>
            </div>

            <!-- Star rating (right side) -->
            <div class="text-end">
                <div class="star-rating mb-1">
                    <% for (int i = 1; i <= 5; i++) { %>
                    <i class="bi <%= i <= review.getRating() ? "bi-star-fill" : "bi-star" %>"></i>
                    <% } %>
                </div>
                <small class="meta-row">Rating: <%= review.getRating() %>/5</small>
                <% if (review.getHelpfulCount() > 0) { %>
                <br><small style="color:#75b798;"><i class="bi bi-hand-thumbs-up"></i> <%= review.getHelpfulCount() %> helpful</small>
                <% } %>
            </div>
        </div>

        <!-- Review body -->
        <p class="mt-3 mb-3" style="color:#ccc; line-height:1.75; font-size:0.95rem;">
            <%= PublicReview.escapeStatic(review.getBody()) %>
        </p>

        <!-- Dates -->
        <div class="meta-row mb-3">
            <i class="bi bi-calendar3"></i> Submitted: <%= review.getSubmissionDate() %>
            <% if (review.getEditDate() != null && !review.getEditDate().isEmpty()) { %>
            &nbsp;&bull;&nbsp;<i class="bi bi-pencil"></i> Last edited: <%= review.getEditDate() %>
            <% } %>
        </div>

        <!-- Actions -->
        <div class="d-flex gap-2 flex-wrap">
            <% if (withinWindow) { %>
            <a href="${pageContext.request.contextPath}/reviews?action=editForm&movieId=<%= review.getMovieId() %>&reviewId=<%= review.getReviewId() %>"
               class="btn btn-sm btn-outline-warning">
                <i class="bi bi-pencil-fill"></i> Edit Review
            </a>
            <% } else { %>
            <button class="btn btn-sm btn-outline-secondary" disabled title="Edit window expired">
                <i class="bi bi-lock-fill"></i> Edit Locked
            </button>
            <% } %>

            <a href="${pageContext.request.contextPath}/reviews?action=view&movieId=<%= review.getMovieId() %>"
               class="btn btn-sm btn-outline-info">
                <i class="bi bi-eye"></i> View Movie Reviews
            </a>

            <form method="post" action="${pageContext.request.contextPath}/reviews" class="d-inline"
                  onsubmit="return confirm('Permanently delete this review?');">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="movieId" value="<%= review.getMovieId() %>">
                <input type="hidden" name="reviewId" value="<%= review.getReviewId() %>">
                <button type="submit" class="btn btn-sm btn-outline-danger">
                    <i class="bi bi-trash-fill"></i> Delete
                </button>
            </form>
        </div>
    </div>
    <%
            }
        }
    %>

</main>

<jsp:include page="/includes/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
