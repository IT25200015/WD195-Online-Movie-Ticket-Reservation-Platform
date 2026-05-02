<%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 21/03/2026
  Time: 19:18
  To change this template use File | Settings | File Templates.
--%>
<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<html>--%>
<%--<head>--%>
<%--    <title>Title</title>--%>
<%--</head>--%>
<%--<body>--%>

<%--</body>--%>
<%--</html>--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ include file="header.jsp" %>
<%@ include file="navbar.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Movies</title>

    <!-- Bootstrap -->
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
            position: relative;
            overflow: hidden;
            border-radius: 10px;
            transition: transform 0.3s;
        }

        .movie-card:hover {
            transform: scale(1.05);
        }

        .movie-card img {
            width: 100%;
            height: 400px;
            object-fit: cover;
        }

        .movie-info {
            position: absolute;
            bottom: 0;
            background: rgba(0,0,0,0.7);
            width: 100%;
            padding: 10px;
        }

        .title {
            font-weight: bold;
        }
    </style>
</head>

<body>

<div class="container">
    <div class="section-title">NOW SHOWING</div>

    <div class="row">

        <!-- Movie 1 -->
        <div class="col-md-3 mb-4">
            <div class="movie-card">
                <img src="../images/movie1.jpg">
                <div class="movie-info">
                    <div class="title">ABC</div>
                    <small>In Theaters Now</small>
                </div>
            </div>
        </div>

        <!-- Movie 2 -->
        <div class="col-md-3 mb-4">
            <div class="movie-card">
                <img src="../images/movie2.jpg">
                <div class="movie-info">
                    <div class="title">Super Mario Galaxy</div>
                    <small>In Theaters Now</small>
                </div>
            </div>
        </div>

        <!-- Movie 3 -->
        <div class="col-md-3 mb-4">
            <div class="movie-card">
                <img src="../images/movie3.jpg">
                <div class="movie-info">
                    <div class="title">Project Hail Mary</div>
                    <small>In Theaters Now</small>
                </div>
            </div>
        </div>

        <!-- Movie 4 -->
        <div class="col-md-3 mb-4">
            <div class="movie-card">
                <img src="../images/movie4.jpg">
                <div class="movie-info">
                    <div class="title">Hoppers</div>
                    <small>In Theaters Now</small>
                </div>
            </div>
        </div>

    </div>
</div>

<%@ include file="footer.jsp" %>

</body>
</html>