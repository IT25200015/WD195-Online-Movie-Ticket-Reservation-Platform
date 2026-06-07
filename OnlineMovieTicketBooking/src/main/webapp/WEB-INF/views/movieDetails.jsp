<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cinebooking.models.Review" %>
<%@ page import="com.cinebooking.models.User" %>
<%@ page import="com.cinebooking.models.Movie" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>${movie.title} – CineBooking</title>
    <meta name="description" content="Watch ${movie.title} directed by ${movie.director}. Book your tickets now at CineBooking.">
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
            --cinema-surface-2: #222222;
            --cinema-accent: #e50914;
            --cinema-accent-glow: rgba(229, 9, 20, 0.3);
            --cinema-text: #f5f5f5;
            --cinema-muted: #aaaaaa;
            --cinema-gold: #d4af37;
        }

        body {
            background-color: var(--cinema-bg);
            font-family: 'Poppins', sans-serif;
            color: var(--cinema-text);
            min-height: 100vh;
        }

        /* ── Hero banner ─────────────────────────────────────────── */
        .movie-hero {
            background: var(--cinema-surface);
            border: 1px solid #252525;
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0,0,0,0.6);
            margin-top: 40px;
            margin-bottom: 40px;
        }

        .movie-poster {
            width: 100%;
            max-height: 520px;
            object-fit: cover;
            border-radius: 0;
        }

        @media (min-width: 768px) {
            .movie-poster { border-radius: 24px 0 0 24px; }
        }

        .movie-info-panel {
            padding: 36px 32px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .movie-title {
            font-size: 2.5rem;
            font-weight: 700;
            line-height: 1.2;
            color: #ffffff;
            margin-bottom: 16px;
        }

        .movie-meta-row {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.92rem;
            color: var(--cinema-muted);
            margin-bottom: 10px;
        }

        .movie-meta-row .meta-icon { color: var(--cinema-accent); }

        .movie-genre-badge {
            display: inline-block;
            background: rgba(229,9,20,0.15);
            border: 1px solid rgba(229,9,20,0.4);
            color: #f55;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            margin-bottom: 20px;
        }

        .movie-description {
            line-height: 1.85;
            font-size: 0.95rem;
            color: #cccccc;
            margin-bottom: 28px;
        }

        .book-btn-lg {
            background: var(--cinema-accent);
            color: #fff;
            padding: 14px 32px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 1rem;
            letter-spacing: 0.5px;
            border: none;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.25s ease;
            box-shadow: 0 8px 24px var(--cinema-accent-glow);
        }

        .book-btn-lg:hover {
            filter: brightness(1.1);
            box-shadow: 0 12px 32px var(--cinema-accent-glow);
            color: #fff;
            transform: translateY(-2px);
        }

        /* ── Inline rating widget ─────────────────────────────────── */
        .rating-inline {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
            padding: 12px 16px;
            background: var(--cinema-surface-2);
            border-radius: 14px;
            border: 1px solid #2a2a2a;
        }

        .rating-score-large {
            font-size: 2.2rem;
            font-weight: 700;
            color: var(--cinema-accent);
            line-height: 1;
        }

        .star-row i { color: var(--cinema-gold); font-size: 1rem; }
        .rating-count { font-size: 0.8rem; color: var(--cinema-muted); }

        /* ── Trailer ──────────────────────────────────────────────── */
        .trailer-section {
            margin: 48px 0;
        }

        .section-heading {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-heading::after {
            content: '';
            flex: 1;
            height: 1px;
            background: rgba(255,255,255,0.1);
        }

        .trailer-frame {
            width: 100%;
            height: 500px;
            border: none;
            border-radius: 20px;
            box-shadow: 0 16px 48px rgba(0,0,0,0.6);
        }

        /* ── Ratings summary widget ───────────────────────────────── */
        .ratings-widget {
            background: var(--cinema-surface);
            border: 1px solid #252525;
            border-radius: 20px;
            padding: 28px;
            margin-bottom: 32px;
        }

        .rating-big { font-size: 3.5rem; font-weight: 700; color: var(--cinema-accent); line-height: 1; }
        .rating-out { font-size: 1rem; color: var(--cinema-muted); }

        .dist-bar-label { font-size: 0.8rem; color: var(--cinema-muted); min-width: 40px; }

        .dist-bar-track {
            flex: 1;
            height: 8px;
            background: #2a2a2a;
            border-radius: 4px;
            overflow: hidden;
        }

        .dist-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #d4af37, #e50914);
            border-radius: 4px;
            transition: width 0.6s ease;
        }

        .dist-count { font-size: 0.8rem; color: var(--cinema-muted); min-width: 28px; text-align: right; }

        /* ── Review cards ─────────────────────────────────────────── */
        .review-card {
            background: var(--cinema-surface);
            border: 1px solid #252525;
            border-radius: 18px;
            padding: 22px;
            margin-bottom: 20px;
            transition: border-color 0.25s ease, box-shadow 0.25s ease;
        }

        .review-card:hover {
            border-color: rgba(229,9,20,0.4);
            box-shadow: 0 10px 32px rgba(229,9,20,0.12);
        }

        .review-stars i { color: var(--cinema-gold); font-size: 1.1rem; }

        .badge-verified   { background: rgba(13,110,253,0.2); color: #6ea8fe; border: 1px solid #0d6efd; }
        .badge-spoiler    { background: rgba(220,53,69,0.2);  color: #ea868f; border: 1px solid #dc3545; }
        .badge-approved   { background: rgba(25,135,84,0.2);  color: #75b798; border: 1px solid #198754; }
        .badge-pending    { background: rgba(255,193,7,0.15); color: #ffc107; border: 1px solid #ffc107; }
        .badge-rejected   { background: rgba(220,53,69,0.2);  color: #ea868f; border: 1px solid #dc3545; }
        .custom-badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }

        .no-reviews-box {
            background: var(--cinema-surface);
            border: 2px dashed #333;
            border-radius: 18px;
            padding: 48px;
            text-align: center;
            color: var(--cinema-muted);
        }

        .add-review-btn {
            background: var(--cinema-accent);
            color: #fff;
            padding: 10px 24px;
            border: none;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.9rem;
            cursor: pointer;
            transition: all 0.25s ease;
        }

        .add-review-btn:hover { filter: brightness(1.1); color: #fff; }
    </style>
</head>
<body>

<jsp:include page="/includes/navbar.jsp" />

<%
    Movie movie      = (Movie)  request.getAttribute("movie");
    String movieId   = (String) request.getAttribute("movieId");
    String avgRating = (String) request.getAttribute("averageRating");
    String wAvgStr   = (String) request.getAttribute("weightedAverageRating");
    Integer reviewCount = (Integer) request.getAttribute("reviewCount");
    List<Review> reviewList = (List<Review>) request.getAttribute("reviewList");
    int[] ratingDist = (int[]) request.getAttribute("ratingDist");
    User  loggedUser = (User)   session.getAttribute("user");
    boolean isAdmin  = loggedUser != null && "Admin".equalsIgnoreCase(loggedUser.getRole());

    if (reviewCount == null) reviewCount = 0;
    if (avgRating == null)   avgRating   = "0.0";
    if (ratingDist == null)  ratingDist  = new int[5];

    double avgD = 0.0;
    try { avgD = Double.parseDouble(avgRating); } catch (Exception ignored) {}
    int filledStars = (int) Math.round(avgD);
%>

<div class="container">

    <!-- ═══ MOVIE HERO ═══════════════════════════════════════════════ -->
    <div class="movie-hero">
        <div class="row g-0">
            <div class="col-md-4">
                <img src="${pageContext.request.contextPath}/images/${movie.poster}"
                     alt="${movie.title} Poster"
                     class="movie-poster">
            </div>

            <div class="col-md-8 movie-info-panel">

                <!-- Inline rating widget -->
                <div class="rating-inline">
                    <div class="rating-score-large"><%= avgRating %></div>
                    <div>
                        <div class="star-row">
                            <% for (int i = 1; i <= 5; i++) { %>
                                <i class="bi <%= i <= filledStars ? "bi-star-fill" : "bi-star" %>"></i>
                            <% } %>
                        </div>
                        <div class="rating-count mt-1">
                            <%= reviewCount %> review<%= reviewCount != 1 ? "s" : "" %>
                            <% if (wAvgStr != null) { %>
                                &bull; Weighted: <strong style="color:#e50914"><%= wAvgStr %></strong>
                            <% } %>
                        </div>
                    </div>
                </div>

                <h1 class="movie-title">${movie.title}</h1>

                <div class="movie-meta-row">
                    <i class="bi bi-person-fill meta-icon"></i>
                    <strong>Director:</strong>&nbsp;${movie.director}
                </div>
                <div class="movie-meta-row">
                    <i class="bi bi-clock meta-icon"></i>
                    <strong>Duration:</strong>&nbsp;${movie.duration}
                </div>
                <div class="movie-meta-row">
                    <i class="bi bi-calendar3 meta-icon"></i>
                    <strong>Year:</strong>&nbsp;${movie.year}
                </div>

                <p class="movie-description mt-3">${movie.description}</p>

                <div class="d-flex gap-3 flex-wrap">
                    <a href="${pageContext.request.contextPath}/showtimes?movieId=${movie.id}"
                       class="book-btn-lg">
                        <i class="bi bi-ticket-perforated"></i> Book Tickets
                    </a>
                    <% if (loggedUser != null) { %>
                    <button class="add-review-btn" data-bs-toggle="modal" data-bs-target="#reviewModal">
                        <i class="bi bi-pencil-square"></i> Write a Review
                    </button>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <!-- ═══ TRAILER ══════════════════════════════════════════════════ -->
    <div class="trailer-section">
        <div class="section-heading"><i class="bi bi-play-circle-fill" style="color:#e50914"></i> Official Trailer</div>
        <iframe class="trailer-frame"
                src="https://www.youtube.com/embed/${movie.trailer}"
                title="YouTube video player"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                referrerpolicy="strict-origin-when-cross-origin" allowfullscreen>
        </iframe>
    </div>

    <!-- ═══ RATINGS SUMMARY WIDGET ════════════════════════════════════ -->
    <div class="section-heading"><i class="bi bi-bar-chart-fill" style="color:#d4af37"></i> Community Ratings</div>
    <div class="ratings-widget">
        <div class="row align-items-center">
            <!-- Left: big score -->
            <div class="col-md-3 text-center mb-3 mb-md-0">
                <div class="rating-big"><%= avgRating %></div>
                <div class="rating-out">out of 5</div>
                <div class="star-row mt-2">
                    <% for (int i = 1; i <= 5; i++) { %>
                        <i class="bi <%= i <= filledStars ? "bi-star-fill" : "bi-star" %>"
                           style="color:#d4af37; font-size:1.2rem;"></i>
                    <% } %>
                </div>
                <div class="rating-count mt-1"><%= reviewCount %> review<%= reviewCount != 1 ? "s" : "" %></div>
            </div>
            <!-- Right: distribution bars -->
            <div class="col-md-9">
                <% int[] starLabels = {5,4,3,2,1};
                   for (int si = 0; si < 5; si++) {
                       int cnt  = ratingDist[si];
                       int pct  = reviewCount > 0 ? (int) Math.round(cnt * 100.0 / reviewCount) : 0;
                %>
                <div class="d-flex align-items-center gap-2 mb-2">
                    <span class="dist-bar-label"><i class="bi bi-star-fill" style="color:#d4af37;font-size:0.75rem;"></i> <%= starLabels[si] %></span>
                    <div class="dist-bar-track">
                        <div class="dist-bar-fill" style="width:<%= pct %>%"></div>
                    </div>
                    <span class="dist-count"><%= cnt %></span>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- ═══ REVIEWS SECTION ════════════════════════════════════════════ -->
    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
        <div class="section-heading mb-0" style="flex:1">
            <i class="bi bi-chat-quote-fill" style="color:#e50914"></i> User Reviews
        </div>
        <% if (loggedUser != null) { %>
        <button class="add-review-btn" data-bs-toggle="modal" data-bs-target="#reviewModal">
            <i class="bi bi-pencil-square"></i> Add Review
        </button>
        <% } else { %>
        <a href="${pageContext.request.contextPath}/UserController?action=login"
           class="add-review-btn">
            <i class="bi bi-box-arrow-in-right"></i> Login to Review
        </a>
        <% } %>
    </div>

    <%
        // Error / success alerts
        String error   = request.getParameter("error");
        String success = request.getParameter("success");
    %>
    <% if ("already_reviewed".equals(error)) { %>
    <div class="alert alert-warning">You have already submitted a review for this movie.</div>
    <% } else if ("save_failed".equals(error)) { %>
    <div class="alert alert-danger">Failed to save your review. Please try again.</div>
    <% } else if ("review_submitted".equals(success)) { %>
    <div class="alert alert-success">Your review has been submitted and is pending moderation.</div>
    <% } %>

    <%
        if (reviewList == null || reviewList.isEmpty()) {
    %>
    <div class="no-reviews-box">
        <i class="bi bi-chat-dots" style="font-size:3rem; color:#444; display:block; margin-bottom:12px;"></i>
        <h5>No reviews yet</h5>
        <p class="mb-3">Be the first to share your thoughts about this movie!</p>
        <% if (loggedUser != null) { %>
        <button class="add-review-btn" data-bs-toggle="modal" data-bs-target="#reviewModal">
            <i class="bi bi-pencil-square"></i> Write a Review
        </button>
        <% } %>
    </div>
    <%
        } else {
            boolean hasShownReview = false;
            for (Review review : reviewList) {
                String status = review.getStatus() == null ? "PENDING" : review.getStatus();
                // Regular users only see APPROVED; admins see all
                if (!isAdmin && !"APPROVED".equalsIgnoreCase(status)) continue;
                hasShownReview = true;

                String statusBadgeClass = "badge-pending";
                if ("APPROVED".equalsIgnoreCase(status))  statusBadgeClass = "badge-approved";
                else if ("REJECTED".equalsIgnoreCase(status)) statusBadgeClass = "badge-rejected";

                boolean isOwner = loggedUser != null && loggedUser.getEmail() != null
                                  && loggedUser.getEmail().equalsIgnoreCase(review.getUserId());
    %>
        <div class="review-card">
            <div class="d-flex justify-content-between align-items-start flex-wrap gap-3">
                <div>
                    <h5 class="fw-semibold mb-1"><%= com.cinebooking.models.PublicReview.escapeStatic(review.getTitle()) %></h5>
                    <div class="review-meta" style="font-size:0.88rem; color:#888;">
                        <i class="bi bi-person-circle"></i>
                        <%= review.getUserId() %>
                    </div>
                </div>
                <div class="text-end">
                    <div class="review-stars">
                        <% for (int ri = 1; ri <= 5; ri++) { %>
                            <i class="bi <%= ri <= review.getRating() ? "bi-star-fill" : "bi-star" %>"></i>
                        <% } %>
                    </div>
                    <small style="color:#888"><%= review.getRating() %>/5</small>
                </div>
            </div>

            <div class="d-flex flex-wrap gap-2 mt-2 mb-2">
                <span class="custom-badge <%= statusBadgeClass %>"><%= status %></span>
                <% if (review.isVerified()) { %>
                    <span class="custom-badge badge-verified"><i class="bi bi-check2-circle"></i> Verified Booking</span>
                <% } %>
                <% if (review.isSpoiler()) { %>
                    <span class="custom-badge badge-spoiler"><i class="bi bi-exclamation-triangle"></i> Spoiler</span>
                <% } %>
                <% if (review.getHelpfulCount() > 0) { %>
                    <span class="custom-badge" style="background:#1a2a1a;color:#75b798;border:1px solid #198754;">
                        <i class="bi bi-hand-thumbs-up"></i> <%= review.getHelpfulCount() %> Helpful
                    </span>
                <% } %>
            </div>

            <p style="color:#ddd; line-height:1.7; font-size:0.95rem;"><%= review.getBody() %></p>

            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 pt-2"
                 style="border-top:1px solid #252525; font-size:0.82rem; color:#666;">
                <span><i class="bi bi-calendar3"></i> <%= review.getSubmissionDate() %>
                <% if (review.getEditDate() != null && !review.getEditDate().isEmpty()) { %>
                    &bull; <i class="bi bi-pencil"></i> Edited <%= review.getEditDate() %>
                <% } %>
                </span>

                <div class="d-flex gap-2">
                    <!-- Upvote -->
                    <form method="post" action="${pageContext.request.contextPath}/reviews" class="d-inline">
                        <input type="hidden" name="action" value="upvote">
                        <input type="hidden" name="reviewId" value="<%= review.getReviewId() %>">
                        <input type="hidden" name="movieId" value="<%= movieId %>">
                        <button type="submit" class="btn btn-sm btn-outline-success py-0 px-2"
                                title="Mark as helpful">
                            <i class="bi bi-hand-thumbs-up"></i>
                        </button>
                    </form>
                    <!-- Report -->
                    <form method="post" action="${pageContext.request.contextPath}/reviews" class="d-inline">
                        <input type="hidden" name="action" value="report">
                        <input type="hidden" name="reviewId" value="<%= review.getReviewId() %>">
                        <input type="hidden" name="movieId" value="<%= movieId %>">
                        <button type="submit" class="btn btn-sm btn-outline-warning py-0 px-2"
                                title="Report this review"
                                onclick="return confirm('Report this review?')">
                            <i class="bi bi-flag"></i>
                        </button>
                    </form>
                    <% if (isOwner) { %>
                    <a href="${pageContext.request.contextPath}/reviews?action=editForm&movieId=<%= review.getMovieId() %>&reviewId=<%= review.getReviewId() %>"
                       class="btn btn-sm btn-outline-primary py-0 px-2" title="Edit your review">
                        <i class="bi bi-pencil"></i>
                    </a>
                    <form method="post" action="${pageContext.request.contextPath}/reviews" class="d-inline"
                          onsubmit="return confirm('Delete this review?')">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="movieId" value="<%= review.getMovieId() %>">
                        <input type="hidden" name="reviewId" value="<%= review.getReviewId() %>">
                        <button type="submit" class="btn btn-sm btn-outline-danger py-0 px-2">
                            <i class="bi bi-trash"></i>
                        </button>
                    </form>
                    <% } %>
                </div>
            </div>
        </div>
    <%
            }
            if (!hasShownReview) {
    %>
        <div class="no-reviews-box">
            <i class="bi bi-chat-dots" style="font-size:3rem; color:#444; display:block; margin-bottom:12px;"></i>
            <p>No approved reviews yet. Check back soon!</p>
        </div>
    <%  }
        }
    %>

</div><!-- /container -->

<!-- ═══ SUBMIT REVIEW MODAL ═══════════════════════════════════════════ -->
<% if (loggedUser != null) { %>
<div class="modal fade" id="reviewModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content" style="background:#181818; border:1px solid #333; color:#f5f5f5;">
            <div class="modal-header" style="border-bottom:1px solid #333;">
                <h5 class="modal-title fw-bold">
                    <i class="bi bi-pencil-square me-2" style="color:#e50914;"></i>
                    Write a Review — ${movie.title}
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form method="post" action="${pageContext.request.contextPath}/reviews" class="row g-3">
                    <input type="hidden" name="action" value="submit">
                    <input type="hidden" name="movieId" value="<%= movieId %>">

                    <!-- Interactive star selector -->
                    <div class="col-12">
                        <label class="form-label fw-semibold">Your Rating <span style="color:#e50914">*</span></label>
                        <div class="d-flex gap-2 align-items-center mb-1" id="starSelector">
                            <% for (int s = 1; s <= 5; s++) { %>
                            <i class="bi bi-star star-btn"
                               data-val="<%= s %>"
                               style="font-size:2rem; color:#444; cursor:pointer; transition:color 0.15s;"></i>
                            <% } %>
                            <span id="starLabel" class="ms-2" style="color:#888; font-size:0.9rem;">Select a rating</span>
                        </div>
                        <input type="hidden" name="rating" id="ratingInput" required>
                    </div>

                    <div class="col-md-12">
                        <label class="form-label fw-semibold">Review Title <span style="color:#e50914">*</span></label>
                        <input type="text" name="title" class="form-control"
                               style="background:#222; border:1px solid #333; color:#f5f5f5;"
                               maxlength="120" placeholder="Give your review a catchy title..." required>
                    </div>

                    <div class="col-12">
                        <label class="form-label fw-semibold">Your Review <span style="color:#e50914">*</span></label>
                        <textarea name="body" rows="5" class="form-control"
                                  style="background:#222; border:1px solid #333; color:#f5f5f5;"
                                  maxlength="2000" id="reviewBody"
                                  placeholder="Share what you loved, hated, or found memorable..." required></textarea>
                        <div class="d-flex justify-content-between mt-1">
                            <small style="color:#666;">Maximum 2000 characters</small>
                            <small id="charCount" style="color:#888;">0 / 2000</small>
                        </div>
                    </div>

                    <div class="col-12 form-check ms-2">
                        <input class="form-check-input" type="checkbox" name="isSpoiler" id="spoilerCheck">
                        <label class="form-check-label" for="spoilerCheck" style="color:#aaa;">
                            <i class="bi bi-exclamation-triangle" style="color:#ffc107;"></i>
                            This review contains spoilers
                        </label>
                    </div>

                    <div class="col-12 d-flex justify-content-end gap-2">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger px-4 fw-bold">
                            <i class="bi bi-send-fill me-1"></i> Post Review
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<% } %>

<jsp:include page="/includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    /* ── Interactive Star Selector ────────────────────────────── */
    const stars  = document.querySelectorAll('.star-btn');
    const rInput = document.getElementById('ratingInput');
    const label  = document.getElementById('starLabel');
    const labels = ['', 'Poor ★', 'Fair ★★', 'Good ★★★', 'Very Good ★★★★', 'Excellent ★★★★★'];

    function paintStars(val) {
        stars.forEach(s => {
            s.className = 'bi star-btn ' + (parseInt(s.dataset.val) <= val ? 'bi-star-fill' : 'bi-star');
            s.style.color = parseInt(s.dataset.val) <= val ? '#d4af37' : '#444';
        });
    }

    stars.forEach(s => {
        s.addEventListener('mouseover', () => paintStars(parseInt(s.dataset.val)));
        s.addEventListener('mouseout',  () => paintStars(parseInt(rInput.value) || 0));
        s.addEventListener('click', () => {
            const v = parseInt(s.dataset.val);
            rInput.value = v;
            label.textContent = labels[v];
            label.style.color = '#d4af37';
            paintStars(v);
        });
    });

    /* ── Character counter ────────────────────────────────────── */
    const tbody = document.getElementById('reviewBody');
    const cnt   = document.getElementById('charCount');
    if (tbody && cnt) {
        tbody.addEventListener('input', () => {
            cnt.textContent = tbody.value.length + ' / 2000';
        });
    }
</script>
</body>
</html>
