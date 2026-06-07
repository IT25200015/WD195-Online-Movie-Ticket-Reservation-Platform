<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Now Showing – CineBooking</title>
    <meta name="description" content="Browse all currently showing movies at CineBooking. Check ratings, reviews, and book your tickets instantly.">
    <jsp:include page="/includes/header.jsp" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

    <style>
        :root {
            --cinema-bg: #121212;
            --cinema-surface: #1a1a1a;
            --cinema-surface-2: #222222;
            --cinema-accent: #e50914;
            --cinema-text: #f5f5f5;
            --cinema-muted: #b9b9b9;
        }

        body {
            background-color: var(--cinema-bg);
            color: var(--cinema-text);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            font-family: 'Poppins', sans-serif;
        }

        .section-title {
            margin: 40px 0 24px;
            font-size: 1.75rem;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            border-left: 4px solid var(--cinema-accent);
            padding-left: 16px;
        }

        .movie-card {
            overflow: hidden;
            border-radius: 18px;
            background-color: var(--cinema-surface);
            border: 1px solid #2a2a2a;
            transition: transform 0.3s ease, box-shadow 0.3s ease, border-color 0.3s ease;
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .movie-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(229, 9, 20, 0.3);
            border-color: rgba(229, 9, 20, 0.5);
        }

        .movie-card .poster-wrapper {
            position: relative;
            overflow: hidden;
        }

        .movie-card img {
            width: 100%;
            height: 380px;
            object-fit: cover;
            transition: transform 0.4s ease;
        }

        .movie-card:hover img {
            transform: scale(1.04);
        }

        .poster-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(to bottom, transparent 60%, rgba(18,18,18,0.95));
            pointer-events: none;
        }

        .movie-info {
            padding: 16px;
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .movie-title-link {
            text-decoration: none;
            color: inherit;
        }

        .movie-title-text {
            font-size: 1.05rem;
            font-weight: 700;
            margin-bottom: 4px;
            color: #fff;
            line-height: 1.3;
        }

        .movie-meta {
            color: var(--cinema-muted);
            font-size: 0.82rem;
            margin-bottom: 3px;
        }

        .star-rating {
            display: flex;
            align-items: center;
            gap: 2px;
            margin-top: 8px;
        }

        .star-rating i {
            font-size: 0.9rem;
            color: #d4af37;
        }

        .star-rating .rating-score {
            font-size: 0.78rem;
            color: var(--cinema-muted);
            margin-left: 6px;
        }

        .book-btn {
            display: block;
            margin-top: auto;
            text-align: center;
            background: var(--cinema-accent);
            color: #fff;
            font-weight: 600;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
            padding: 9px 0;
            border-radius: 10px;
            text-decoration: none;
            transition: filter 0.25s ease, box-shadow 0.25s ease;
            margin-top: 12px;
        }

        .book-btn:hover {
            filter: brightness(1.15);
            box-shadow: 0 8px 20px rgba(229, 9, 20, 0.4);
            color: #fff;
        }

        a { text-decoration: none; }
    </style>
</head>
<body>

<jsp:include page="/includes/navbar.jsp" />

<%
    @SuppressWarnings("unchecked")
    java.util.Map<String, double[]> movieRatings =
            (java.util.Map<String, double[]>) request.getAttribute("movieRatings");
    if (movieRatings == null) movieRatings = new java.util.HashMap<>();
%>

<main class="flex-grow-1">
<div class="container pb-5">

    <div class="section-title">🎬 Now Showing</div>

    <div class="row g-4">

        <c:forEach var="movie" items="${movies}">
            <div class="col-6 col-md-4 col-lg-3">
                <div class="movie-card">

                    <div class="poster-wrapper">
                        <a href="${pageContext.request.contextPath}/movie-details?movieId=${movie.id}">
                            <img src="${pageContext.request.contextPath}/images/${movie.poster}"
                                 alt="${movie.title} Poster"
                                 loading="lazy">
                        </a>
                        <div class="poster-overlay"></div>
                    </div>

                    <div class="movie-info">
                        <a href="${pageContext.request.contextPath}/movie-details?movieId=${movie.id}"
                           class="movie-title-link">
                            <div class="movie-title-text">${movie.title}</div>
                        </a>
                        <div class="movie-meta">Director: ${movie.director}</div>
                        <div class="movie-meta">Year: ${movie.year}</div>
                        <div class="movie-meta">Duration: ${movie.duration}</div>

                        <%-- Dynamic star rating --%>
                        <%
                            String mid = String.valueOf(pageContext.getAttribute("movie") != null
                                ? ((com.cinebooking.models.Movie) pageContext.getAttribute("movie")).getId()
                                : 0);
                        %>
                        <c:set var="mid" value="${movie.id}" />
                        <c:set var="ratingData" value="${movieRatings[mid.toString()]}" />

                        <div class="star-rating">
                            <c:choose>
                                <c:when test="${movieRatings != null}">
                                    <%
                                        /* Use scriptlet to get rating from map for this movie */
                                        com.cinebooking.models.Movie currentMovie =
                                                (com.cinebooking.models.Movie) pageContext.getAttribute("movie");
                                        double[] rdata = null;
                                        if (currentMovie != null && movieRatings != null) {
                                            rdata = movieRatings.get(String.valueOf(currentMovie.getId()));
                                        }
                                        double avgStar  = (rdata != null) ? rdata[0] : 0.0;
                                        int    revCount = (rdata != null) ? (int) rdata[1] : 0;
                                        int    filled   = (int) Math.round(avgStar);
                                        for (int si = 1; si <= 5; si++) {
                                            if (si <= filled) {
                                    %>
                                        <i class="bi bi-star-fill"></i>
                                    <%  } else { %>
                                        <i class="bi bi-star" style="color:#444;"></i>
                                    <%  } } %>
                                    <span class="rating-score">
                                        <%= avgStar > 0 ? String.format("%.1f", avgStar) : "No ratings" %>
                                        <% if (revCount > 0) { %>(<%= revCount %>)<% } %>
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <i class="bi bi-star" style="color:#444;"></i>
                                    <i class="bi bi-star" style="color:#444;"></i>
                                    <i class="bi bi-star" style="color:#444;"></i>
                                    <i class="bi bi-star" style="color:#444;"></i>
                                    <i class="bi bi-star" style="color:#444;"></i>
                                    <span class="rating-score">No ratings</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <a href="${pageContext.request.contextPath}/showtimes?movieId=${movie.id}"
                           class="book-btn">🎟 Book Now</a>
                    </div>

                </div>
            </div>
        </c:forEach>

    </div>

</div>
</main>

<jsp:include page="/includes/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
