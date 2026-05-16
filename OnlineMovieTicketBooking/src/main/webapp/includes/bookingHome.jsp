<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="header.jsp" %>
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Movies</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        :root {
            --navy:       #0d1128;
            --navy-light: #151b3a;
            --navy-mid:   #1c2448;
            --gold:       #f5c518;
            --gold-dim:   #c9a214;
            --white:      #ffffff;
            --grey:       #8892b0;
            --card-radius: 12px;
        }
        body {
            background-color: #0b0f2f;
            color: white;
        }

        .section-title {
            margin: 30px 0;
            font-size: 28px;
            font-weight: bold;
        }

        .movie-card {
            background: var(--navy-light);
            border-radius: var(--card-radius);
            overflow: hidden;
            cursor: pointer;
            transition: transform .25s, box-shadow .25s;
            position: relative;
        }
        .movie-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 48px rgba(0,0,0,0.5);
        }
        .movie-card:hover .card-overlay { opacity: 1; }
        .movie-poster {
            width: 100%;
            aspect-ratio: 2/3;
            object-fit: cover;
            display: block;
        }
        .poster-placeholder {
            width: 100%;
            aspect-ratio: 2/3;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Bebas Neue', sans-serif;
            font-size: 1.4rem;
            letter-spacing: 2px;
            text-align: center;
            padding: 16px;
        }
        .card-overlay {
            position: absolute; inset: 0;
            background: linear-gradient(to top, rgba(13,17,40,0.95) 0%, rgba(13,17,40,0.2) 50%, transparent 100%);
            opacity: 0;
            transition: opacity .25s;
            display: flex; align-items: flex-end;
            padding: 20px;
        }
        .card-overlay .book-now {
            background: var(--gold);
            color: var(--navy);
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 0.85rem;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            cursor: pointer;
            width: 100%;
        }
        .card-info { padding: 14px 16px 16px; }
        .card-title {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 1rem;
            font-weight: 700;
            letter-spacing: 1px;
            text-transform: uppercase;
            margin-bottom: 4px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .card-status {
            font-size: 0.75rem;
            color: var(--grey);
            letter-spacing: 1px;
            text-transform: uppercase;
            font-weight: 500;
        }
        .card-status.now { color: #4ade80; }
        .card-status.soon { color: var(--gold); }

        /* genre pill on card */
        .card-genre {
            position: absolute;
            top: 12px; left: 12px;
            background: rgba(13,17,40,0.85);
            color: var(--gold);
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 0.65rem;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            padding: 3px 8px;
            border-radius: 3px;
            backdrop-filter: blur(4px);
        }

        .movie-card img {
            width: 100%;
            height: 400px;
            object-fit: cover;
        }

    </style>

</head>

<body>

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

                        <div class="card-overlay">
                            <button class="book-now" onclick="location.href='booking?action=bookMovie&movieID=${movie.id}'">BOOK NOW</button>
                        </div>

                    </div>

                </div>

            </div>

        </c:forEach>

    </div>

</div>

<%@ include file="footer.jsp" %>

</body>
</html>