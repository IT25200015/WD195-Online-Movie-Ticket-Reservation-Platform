<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Movies</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">

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
        }

        .section-title {
            margin: 30px 0;
            font-size: 28px;
            font-weight: bold;
            letter-spacing: 1px;
        }

        .movie-card {
            overflow: hidden;
            border-radius: 16px;
            background-color: var(--cinema-surface);
            border: 1px solid #2a2a2a;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .movie-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 30px rgba(0, 0, 0, 0.45);
        }

        .movie-card img {
            width: 100%;
            height: 400px;
            object-fit: cover;
        }

        .movie-info {
            padding: 16px;
        }

        .title {
            font-size: 20px;
            font-weight: bold;
        }

        .movie-info p {
            color: var(--cinema-muted);
            margin-bottom: 6px;
        }

        a {
            text-decoration: none;
        }

    </style>

</head>

<body>

<jsp:include page="/includes/navbar.jsp" />

<div class="container">

    <div class="section-title">
        NOW SHOWING
    </div>

    <div class="row">

        <c:forEach var="movie" items="${movies}">

            <div class="col-md-3 mb-4">

                <div class="movie-card">

                    <a href="${pageContext.request.contextPath}/showtimes?movieId=${movie.id}">

                        <img src="${pageContext.request.contextPath}/images/${movie.poster}">

                    </a>

                    <div class="movie-info">

                        <div class="title">
                                ${movie.title}
                        </div>

                        <p>
                            Director: ${movie.director}
                        </p>

                        <p>
                            Year: ${movie.year}
                        </p>

                    </div>

                </div>

            </div>

        </c:forEach>

    </div>

</div>

<jsp:include page="/includes/footer.jsp" />

</body>
</html>