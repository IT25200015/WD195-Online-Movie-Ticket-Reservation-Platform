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
            overflow: hidden;
            border-radius: 10px;
            background-color: #1b1f4b;
            transition: transform 0.3s;
        }

        .movie-card:hover {
            transform: scale(1.03);
        }

        .movie-card img {
            width: 100%;
            height: 400px;
            object-fit: cover;
        }

        .movie-info {
            padding: 15px;
        }

        .title {
            font-size: 20px;
            font-weight: bold;
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

                    <img src="${pageContext.request.contextPath}/images/${movie.poster}">

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

<%@ include file="footer.jsp" %>

</body>
</html>