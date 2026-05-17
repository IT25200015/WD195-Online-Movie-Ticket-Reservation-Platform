<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>

    <title>Showtimes</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
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
            color: var(--cinema-text);
        }

        .showtime-card {
            background: var(--cinema-surface);
            border-radius: 16px;
            padding: 25px;
            border: 1px solid #2a2a2a;
            box-shadow: 0 10px 25px rgba(0,0,0,0.4);
        }

        .showtime-title {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 20px;
        }

        .btn-showtime {
            background: transparent;
            border: 1px solid var(--cinema-accent);
            color: var(--cinema-text);
            padding: 10px 18px;
            border-radius: 50px;
            margin: 8px;
            transition: 0.3s ease;
            font-weight: 500;
        }

        .btn-showtime:hover {
            background: var(--cinema-accent);
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(229, 9, 20, 0.4);
        }

        .day-label {
            display: block;
            font-size: 0.85rem;
            color: var(--cinema-muted);
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