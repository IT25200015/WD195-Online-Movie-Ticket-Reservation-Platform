<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>

    <title>${movie.title}</title>

    <link href=
                  "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
          rel="stylesheet">
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
            font-family: Arial, sans-serif;
            color: var(--cinema-text);
            min-height: 100vh;
        }

        .movie-container {
            margin-top: 50px;
            margin-bottom: 50px;
            background: var(--cinema-surface);
            padding: 40px;
            border-radius: 20px;
            border: 1px solid #2a2a2a;
            box-shadow: 0 10px 30px rgba(0,0,0,0.4);
        }

        .movie-poster {
            width: 100%;
            height: 100%;
            max-height: 650px;
            object-fit: cover;
            border-radius: 18px;
            box-shadow: 0 12px 30px rgba(0,0,0,0.5);
        }

        .movie-title {
            font-size: 3rem;
            font-weight: bold;
            margin-bottom: 25px;
            color: #ffffff;
        }

        .movie-meta {
            font-size: 1.1rem;
            margin-bottom: 15px;
            color: var(--cinema-muted);
        }

        .movie-description {
            line-height: 1.9;
            margin-top: 30px;
            font-size: 1.05rem;
            color: var(--cinema-text);
        }

        .trailer-title {
            margin-top: 60px;
            margin-bottom: 20px;
            font-size: 2rem;
            font-weight: bold;
        }

        iframe {
            width: 100%;
            height: 500px;
            border: none;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
        }

    </style>

</head>

<body>

<jsp:include page="/includes/navbar.jsp" />

<div class="container movie-container">

    <div class="row">

        <div class="col-md-4">

            <img src="${pageContext.request.contextPath}/images/${movie.poster}"
                 class="movie-poster">

        </div>

        <div class="col-md-8">

            <div class="movie-title">
                ${movie.title}
            </div>

            <div class="movie-meta">
                <strong>Director:</strong>
                ${movie.director}
            </div>

            <div class="movie-meta">
                <strong>Duration:</strong>
                ${movie.duration}
            </div>

            <div class="movie-meta">
                <strong>Year:</strong>
                ${movie.year}
            </div>

            <div class="movie-description">
                ${movie.description}
            </div>

        </div>

    </div>


    <!-- TRAILER -->

    <div class="mt-5">

        <h3 class="trailer-title">
            Official Trailer
        </h3>

<%--        <iframe--%>
<%--                src="${movie.trailer}"--%>
<%--                allowfullscreen>--%>
<%--        </iframe>--%>

        <iframe width="560" height="315"
                src="https://www.youtube.com/embed/${movie.trailer}"
                title="YouTube video player" frameborder="0"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                referrerpolicy="strict-origin-when-cross-origin" allowfullscreen>

        </iframe>

    </div>

</div>

<jsp:include page="/includes/footer.jsp" />

</body>
</html>