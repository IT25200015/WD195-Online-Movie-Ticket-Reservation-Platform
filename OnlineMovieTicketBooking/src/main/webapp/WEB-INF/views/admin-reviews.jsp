<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.cinebooking.models.Review" %>
<%@ page import="com.cinebooking.models.User" %>
<%@ page import="com.cinebooking.models.PublicReview" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Admin Review Moderation – CineBooking</title>
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
            background: linear-gradient(135deg, #181818, #1f1f1f);
            border: 1px solid #252525;
            border-radius: 20px;
            padding: 28px 32px;
            margin-bottom: 28px;
        }
        .filter-bar {
            background: var(--cinema-surface);
            border: 1px solid #252525;
            border-radius: 14px;
            padding: 16px 20px;
            margin-bottom: 28px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            align-items: center;
        }
        .filter-btn {
            border: 1px solid #333;
            background: #222;
            color: #aaa;
            border-radius: 50px;
            padding: 6px 18px;
            font-size: 0.82rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }
        .filter-btn:hover, .filter-btn.active {
            background: var(--cinema-accent);
            border-color: var(--cinema-accent);
            color: #fff;
        }
        .filter-btn.f-pending.active  { background:#ffc107; border-color:#ffc107; color:#111; }
        .filter-btn.f-approved.active { background:#198754; border-color:#198754; color:#fff; }
        .filter-btn.f-rejected.active { background:#dc3545; border-color:#dc3545; color:#fff; }
        .filter-btn.f-hidden.active   { background:#6c757d; border-color:#6c757d; color:#fff; }

        .review-card {
            background: var(--cinema-surface);
            border: 1px solid #252525;
            border-radius: 18px;
            padding: 22px 24px;
            margin-bottom: 16px;
            transition: border-color 0.25s, box-shadow 0.25s;
        }
        .review-card:hover { border-color: rgba(229,9,20,0.3); box-shadow: 0 8px 28px rgba(229,9,20,0.08); }
        .review-card.hidden-review { opacity: 0.6; }

        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.78rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .s-pending  { background: rgba(255,193,7,0.15);  color:#ffc107; border:1px solid #ffc107; }
        .s-approved { background: rgba(25,135,84,0.2);   color:#75b798; border:1px solid #198754; }
        .s-rejected { background: rgba(220,53,69,0.2);   color:#ea868f; border:1px solid #dc3545; }
        .s-hidden   { background: rgba(108,117,125,0.2); color:#adb5bd; border:1px solid #6c757d; }

        .star-row i { color: var(--cinema-gold); font-size:0.9rem; }
        .meta-row { font-size:0.8rem; color:#666; }

        .action-form { display:inline; }

        .pagination-bar { margin-top: 32px; display: flex; gap: 8px; align-items: center; flex-wrap:wrap; }
        .page-btn {
            background:#222; border:1px solid #333; color:#aaa;
            border-radius:8px; padding:6px 14px; font-size:0.82rem; cursor:pointer;
            transition:all 0.2s;
        }
        .page-btn.active, .page-btn:hover { background:var(--cinema-accent); border-color:var(--cinema-accent); color:#fff; }

        .report-badge { background:rgba(255,100,0,0.15); color:#ff6428; border:1px solid #ff6428; }

        .stat-chip {
            background: rgba(229,9,20,0.1);
            border: 1px solid rgba(229,9,20,0.25);
            color: #f55;
            padding: 5px 14px;
            border-radius: 50px;
            font-size: 0.82rem;
            font-weight: 600;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">

<jsp:include page="/includes/navbar.jsp" />

<%
    List<Review> allReviewList = (List<Review>) request.getAttribute("allReviewList");
    Integer reviewCount = (Integer) request.getAttribute("reviewCount");
    if (reviewCount == null) reviewCount = 0;
    if (allReviewList == null) allReviewList = new ArrayList<>();

    // Count by status
    int cPending = 0, cApproved = 0, cRejected = 0, cHidden = 0;
    for (Review r : allReviewList) {
        String s = r.getStatus() == null ? "PENDING" : r.getStatus().toUpperCase();
        if ("PENDING".equals(s))  cPending++;
        else if ("APPROVED".equals(s)) cApproved++;
        else if ("REJECTED".equals(s)) cRejected++;
        else if ("HIDDEN".equals(s))   cHidden++;
    }

    String error   = request.getParameter("error");
    String success = request.getParameter("success");
%>

<main class="container py-5 flex-grow-1">

    <!-- Page Header -->
    <div class="page-header">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
            <div>
                <h1 class="h2 fw-bold mb-1">
                    <i class="bi bi-shield-check me-2" style="color:#e50914;"></i>
                    Admin Moderation Panel
                </h1>
                <p class="text-secondary mb-0">
                    Review all submitted feedback and update moderation status.
                </p>
            </div>
            <div class="d-flex gap-2 flex-wrap">
                <span class="stat-chip"><%= reviewCount %> Total</span>
                <span class="stat-chip" style="color:#ffc107;border-color:rgba(255,193,7,0.3);background:rgba(255,193,7,0.1);">
                    <i class="bi bi-hourglass-split"></i> <%= cPending %> Pending
                </span>
                <span class="stat-chip" style="color:#75b798;border-color:rgba(25,135,84,0.3);background:rgba(25,135,84,0.1);">
                    <i class="bi bi-check-circle"></i> <%= cApproved %> Approved
                </span>
            </div>
        </div>
    </div>

    <!-- Alerts -->
    <% if ("delete_failed".equals(error)) { %>
    <div class="alert alert-danger">Failed to delete the review. Please try again.</div>
    <% } else if ("review_deleted".equals(success)) { %>
    <div class="alert alert-success"><i class="bi bi-check-circle me-2"></i>Review deleted successfully.</div>
    <% } %>

    <!-- Filter Bar -->
    <div class="filter-bar">
        <span style="color:#aaa;font-size:0.82rem;font-weight:600;">FILTER:</span>
        <button class="filter-btn active" onclick="filterReviews('ALL', this)">
            All (<%= reviewCount %>)
        </button>
        <button class="filter-btn f-pending" onclick="filterReviews('PENDING', this)">
            <i class="bi bi-hourglass-split"></i> Pending (<%= cPending %>)
        </button>
        <button class="filter-btn f-approved" onclick="filterReviews('APPROVED', this)">
            <i class="bi bi-check-circle"></i> Approved (<%= cApproved %>)
        </button>
        <button class="filter-btn f-rejected" onclick="filterReviews('REJECTED', this)">
            <i class="bi bi-x-circle"></i> Rejected (<%= cRejected %>)
        </button>
        <button class="filter-btn f-hidden" onclick="filterReviews('HIDDEN', this)">
            <i class="bi bi-eye-slash"></i> Hidden (<%= cHidden %>)
        </button>
        <div class="ms-auto">
            <input type="text" id="searchInput" class="form-control form-control-sm"
                   style="background:#222;border:1px solid #333;color:#f5f5f5;width:200px;"
                   placeholder="🔍 Search reviews..." onkeyup="searchReviews(this.value)">
        </div>
    </div>

    <!-- No reviews -->
    <% if (allReviewList.isEmpty()) { %>
    <div class="review-card text-center py-5">
        <i class="bi bi-inbox" style="font-size:3rem;color:#444;"></i>
        <p class="text-secondary mt-3">No reviews are available for moderation.</p>
    </div>
    <%
        } else {
            for (Review review : allReviewList) {
                String status = review.getStatus() == null ? "PENDING" : review.getStatus().toUpperCase();
                String badgeClass = "s-pending";
                if      ("APPROVED".equals(status)) badgeClass = "s-approved";
                else if ("REJECTED".equals(status)) badgeClass = "s-rejected";
                else if ("HIDDEN".equals(status))   badgeClass = "s-hidden";
                boolean isHidden = "HIDDEN".equals(status);
    %>
    <div class="review-card <%= isHidden ? "hidden-review" : "" %>"
         data-status="<%= status %>"
         data-searchtext="<%= PublicReview.escapeStatic(review.getTitle() + " " + review.getUserId() + " " + review.getBody()).toLowerCase() %>">

        <div class="d-flex justify-content-between align-items-start flex-wrap gap-3">
            <div style="flex:1; min-width:220px;">
                <h5 class="fw-semibold mb-1"><%= PublicReview.escapeStatic(review.getTitle()) %></h5>
                <div class="meta-row mb-2">
                    Movie ID: <strong><%= review.getMovieId() %></strong>
                    &bull; User: <strong><%= review.getUserId() %></strong>
                    &bull; ID: <code style="font-size:0.73rem;color:#666;"><%= review.getReviewId() %></code>
                </div>
                <div class="d-flex flex-wrap gap-2 mb-1">
                    <span class="status-badge <%= badgeClass %>">
                        <%= status %>
                    </span>
                    <% if (review.isVerified()) { %>
                    <span class="status-badge" style="background:rgba(13,110,253,0.2);color:#6ea8fe;border:1px solid #0d6efd;">
                        <i class="bi bi-check2-circle"></i> Verified
                    </span>
                    <% } %>
                    <% if (review.isSpoiler()) { %>
                    <span class="status-badge s-rejected"><i class="bi bi-exclamation-triangle"></i> Spoiler</span>
                    <% } %>
                    <% if (review.getReportCount() > 0) { %>
                    <span class="status-badge report-badge">
                        <i class="bi bi-flag-fill"></i> <%= review.getReportCount() %> Report<%= review.getReportCount() != 1 ? "s" : "" %>
                    </span>
                    <% } %>
                </div>
            </div>
            <div class="text-end">
                <div class="star-row">
                    <% for (int i = 1; i <= 5; i++) { %>
                    <i class="bi <%= i <= review.getRating() ? "bi-star-fill" : "bi-star" %>"></i>
                    <% } %>
                </div>
                <small class="meta-row"><%= review.getRating() %>/5</small>
                <br>
                <small class="meta-row">
                    <i class="bi bi-hand-thumbs-up"></i> <%= review.getHelpfulCount() %> helpful
                </small>
            </div>
        </div>

        <p class="mt-3 mb-2" style="color:#ccc; line-height:1.7; font-size:0.93rem;">
            <%= PublicReview.escapeStatic(review.getBody()) %>
        </p>

        <div class="meta-row mb-3">
            <i class="bi bi-calendar3"></i> Submitted: <%= review.getSubmissionDate() %>
            <% if (review.getEditDate() != null && !review.getEditDate().isEmpty()) { %>
            &bull; <i class="bi bi-pencil"></i> Edited: <%= review.getEditDate() %>
            <% } %>
        </div>

        <!-- Moderation Actions -->
        <div class="d-flex flex-wrap gap-2 pt-2" style="border-top:1px solid #252525;">

            <!-- Set PENDING -->
            <form class="action-form" method="post" action="${pageContext.request.contextPath}/reviews">
                <input type="hidden" name="action" value="updateStatus">
                <input type="hidden" name="reviewId" value="<%= review.getReviewId() %>">
                <input type="hidden" name="movieId" value="<%= review.getMovieId() %>">
                <input type="hidden" name="status" value="PENDING">
                <button type="submit" class="btn btn-sm btn-outline-warning">
                    <i class="bi bi-hourglass-split"></i> Pending
                </button>
            </form>

            <!-- Set APPROVED -->
            <form class="action-form" method="post" action="${pageContext.request.contextPath}/reviews">
                <input type="hidden" name="action" value="updateStatus">
                <input type="hidden" name="reviewId" value="<%= review.getReviewId() %>">
                <input type="hidden" name="movieId" value="<%= review.getMovieId() %>">
                <input type="hidden" name="status" value="APPROVED">
                <button type="submit" class="btn btn-sm btn-outline-success">
                    <i class="bi bi-check-circle-fill"></i> Approve
                </button>
            </form>

            <!-- Set REJECTED -->
            <form class="action-form" method="post" action="${pageContext.request.contextPath}/reviews">
                <input type="hidden" name="action" value="updateStatus">
                <input type="hidden" name="reviewId" value="<%= review.getReviewId() %>">
                <input type="hidden" name="movieId" value="<%= review.getMovieId() %>">
                <input type="hidden" name="status" value="REJECTED">
                <button type="submit" class="btn btn-sm btn-outline-danger">
                    <i class="bi bi-x-circle-fill"></i> Reject
                </button>
            </form>

            <!-- Set HIDDEN -->
            <form class="action-form" method="post" action="${pageContext.request.contextPath}/reviews">
                <input type="hidden" name="action" value="updateStatus">
                <input type="hidden" name="reviewId" value="<%= review.getReviewId() %>">
                <input type="hidden" name="movieId" value="<%= review.getMovieId() %>">
                <input type="hidden" name="status" value="HIDDEN">
                <button type="submit" class="btn btn-sm btn-outline-secondary">
                    <i class="bi bi-eye-slash-fill"></i> Hide
                </button>
            </form>

            <!-- DELETE (permanent) -->
            <form class="action-form" method="post" action="${pageContext.request.contextPath}/reviews"
                  onsubmit="return confirm('Permanently delete this review? This cannot be undone.');">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="movieId" value="<%= review.getMovieId() %>">
                <input type="hidden" name="reviewId" value="<%= review.getReviewId() %>">
                <button type="submit" class="btn btn-sm btn-danger ms-2">
                    <i class="bi bi-trash-fill"></i> Delete
                </button>
            </form>

            <a href="${pageContext.request.contextPath}/reviews?action=view&movieId=<%= review.getMovieId() %>"
               class="btn btn-sm btn-outline-light ms-auto">
                <i class="bi bi-eye"></i> View Movie
            </a>
        </div>
    </div>
    <%
            }
        }
    %>

</main>

<jsp:include page="/includes/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function filterReviews(status, btn) {
        // Update active button
        document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');

        document.querySelectorAll('.review-card[data-status]').forEach(card => {
            if (status === 'ALL' || card.dataset.status === status) {
                card.style.display = '';
            } else {
                card.style.display = 'none';
            }
        });
    }

    function searchReviews(query) {
        const q = query.toLowerCase().trim();
        document.querySelectorAll('.review-card[data-status]').forEach(card => {
            const text = card.dataset.searchtext || '';
            card.style.display = (q === '' || text.includes(q)) ? '' : 'none';
        });
    }
</script>
</body>
</html>
