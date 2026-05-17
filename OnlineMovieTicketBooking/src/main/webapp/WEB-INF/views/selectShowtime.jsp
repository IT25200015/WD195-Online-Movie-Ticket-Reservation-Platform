<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.cinebooking.models.User" %>
<%@ page import="com.cinebooking.models.Showtime" %>

<%
    User sessionUser = (User) session.getAttribute("user");
    if (sessionUser == null) {
        response.sendRedirect("UserController?action=login");
        return;
    }
    Showtime[] showtimes = (Showtime[]) request.getAttribute("showtimes");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CineBooking | Select Movie</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        body { font-family: 'Poppins', sans-serif; background: linear-gradient(to right, #24243e, #302b63, #0f0c29); color: white; min-height: 100vh; }
        .glass-card { background: rgba(255,255,255,0.05); backdrop-filter: blur(10px); border: 1px solid rgba(255,255,255,0.1); border-radius: 15px; padding: 25px; transition: transform 0.2s, box-shadow 0.2s; }
        .glass-card:hover { transform: translateY(-4px); box-shadow: 0 12px 40px rgba(0,0,0,0.6); }
        .genre-badge { font-size: 0.75rem; padding: 4px 10px; border-radius: 20px; background: rgba(255,255,255,0.1); color: #ccc; }
        .price-tag { font-size: 0.85rem; color: #ffc107; }
        .btn-book { background: transparent; border: 1px solid #ffc107; color: #ffc107; border-radius: 0; letter-spacing: 1px; text-transform: uppercase; font-size: 0.85rem; transition: 0.3s; }
        .btn-book:hover { background: #ffc107; color: #000; }
        .page-title { font-size: 2rem; font-weight: 600; letter-spacing: 2px; }
        .navbar-custom { background: rgba(0,0,0,0.4); backdrop-filter: blur(10px); border-bottom: 1px solid rgba(255,255,255,0.1); }
    </style>
</head>
<body>

<nav class="navbar navbar-dark navbar-custom px-4 py-3">
    <a class="navbar-brand fw-bold fs-5" href="${pageContext.request.contextPath}/index.jsp">🎬 CineBooking</a>
    <div class="d-flex gap-3 align-items-center">
        <a href="${pageContext.request.contextPath}/PaymentController?action=myBookings" class="text-light text-decoration-none small"><i class="bi bi-ticket-perforated me-1"></i>My Bookings</a>
        <a href="${pageContext.request.contextPath}/UserController?action=profile" class="text-light text-decoration-none small"><i class="bi bi-person me-1"></i><%= sessionUser.getName() %></a>
    </div>
</nav>

<div class="container py-5">
    <div class="text-center mb-5">
        <h1 class="page-title">NOW SHOWING</h1>
        <p class="text-muted">Select a movie and showtime to continue</p>
    </div>

    <div class="row g-4">
        <% if (showtimes != null) { for (Showtime st : showtimes) { %>
        <div class="col-md-6 col-lg-4">
            <div class="glass-card h-100 d-flex flex-column">
                <div class="mb-2">
                    <span class="genre-badge"><%= st.getMovieGenre() %></span>
                </div>
                <h5 class="fw-600 mb-1"><%= st.getMovieName() %></h5>
                <p class="text-muted small mb-1"><i class="bi bi-calendar3 me-1"></i><%= st.getDate() %> &nbsp; <i class="bi bi-clock me-1"></i><%= st.getTime() %></p>
                <p class="text-muted small mb-2"><i class="bi bi-building me-1"></i><%= st.getHall() %> &nbsp; <i class="bi bi-people me-1"></i><%= st.getTotalSeats() %> seats</p>
                <div class="price-tag mb-3">
                    <i class="bi bi-tag me-1"></i>Standard: LKR <%= String.format("%.0f", st.getStandardPrice()) %> &nbsp;|&nbsp; Premium: LKR <%= String.format("%.0f", st.getPremiumPrice()) %>
                </div>
                <div class="mt-auto">
                    <a href="${pageContext.request.contextPath}/PaymentController?action=selectSeats&showtimeId=<%= st.getShowtimeId() %>"
                       class="btn btn-book w-100">Select Seats</a>
                </div>
            </div>
        </div>
        <% }} %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
