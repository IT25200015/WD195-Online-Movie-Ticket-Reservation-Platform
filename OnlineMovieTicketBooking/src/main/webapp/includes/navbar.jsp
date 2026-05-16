<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    .cinema-navbar {
        background-color: #121212;
    }

    .cinema-navbar .navbar-brand,
    .cinema-navbar .nav-link {
        color: #e6e6e6;
        transition: color 0.25s ease;
    }

    .cinema-navbar .nav-link:hover,
    .cinema-navbar .nav-link:focus {
        color: #e50914;
    }

    .cinema-navbar .navbar-nav {
        list-style: none;
    }

    .cinema-login-btn {
        background-color: #e50914;
        color: #ffffff;
        border-radius: 999px;
        padding: 8px 20px;
        border: none;
        transition: transform 0.25s ease, box-shadow 0.25s ease;
    }

    .cinema-login-btn:hover,
    .cinema-login-btn:focus {
        transform: scale(1.05);
        box-shadow: 0 10px 20px rgba(229, 9, 20, 0.35);
        color: #ffffff;
    }
</style>

<nav class="navbar navbar-expand-lg navbar-dark shadow cinema-navbar">
    <div class="container">
<%--        <a class="navbar-brand fw-bold" href="index.jsp">🎬 CineBooking</a>--%>
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/home">🎬 CineBooking</a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-lg-center gap-lg-2">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/movies">Movies</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/booking">Book Tickets</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/booking?action=myBookings">My Bookings</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/deals">Offers</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/reviews.jsp">Reviews</a></li>
                <li class="nav-item"><a class="cinema-login-btn ms-lg-3" href="${pageContext.request.contextPath}/UserController?action=login">Login</a></li>
            </ul>
        </div>
    </div>
</nav>
