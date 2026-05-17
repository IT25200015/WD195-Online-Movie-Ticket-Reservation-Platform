<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>

    <title>Showtimes</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>
        body {
            background-color: #121212;
            color: white;
        }

        .showtime-card {
            background: #1f1f1f;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.4);
        }

        .showtime-title {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 20px;
        }

        .btn-showtime {
            background: transparent;
            border: 1px solid #e50914;
            color: white;
            padding: 10px 18px;
            border-radius: 50px;
            margin: 8px;
            transition: 0.3s ease;
            font-weight: 500;
        }

        .btn-showtime:hover {
            background: #e50914;
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(229, 9, 20, 0.4);
        }

        .day-label {
            display: block;
            font-size: 0.85rem;
            color: #b9b9b9;
        }

        .time-label {
            font-size: 1rem;
            font-weight: 600;
        }
    </style>

</head>

<body>

<jsp:include page="/includes/navbar.jsp" />

<div class="container mt-5">

    <div class="showtime-card">

        <div class="showtime-title">
            🎬 Movie Showtimes
        </div>

        <c:if test="${empty showtimes}">
            <p class="text-muted">No showtimes available.</p>
        </c:if>

        <div class="d-flex flex-wrap">

            <c:forEach var="show" items="${showtimes}">

                <button class="btn-showtime">

                    <span class="day-label">
                            ${show.day}
                    </span>

                    <span class="time-label">
                            ${show.time}
                    </span>

                </button>

            </c:forEach>

        </div>

    </div>

</div>

<jsp:include page="/includes/footer.jsp" />

</body>
</html>