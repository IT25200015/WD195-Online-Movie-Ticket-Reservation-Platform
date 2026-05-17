<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.cinebooking.models.User" %>
<%@ page import="com.cinebooking.models.Payment" %>
<%@ page import="com.cinebooking.models.CardPayment" %>
<%@ page import="com.cinebooking.models.Booking" %>
<%@ page import="java.util.List" %>

<%
    User sessionUser = (User) session.getAttribute("user");
    if (sessionUser == null || !"Admin".equals(sessionUser.getRole())) {
        response.sendRedirect("UserController?action=login"); return;
    }
    List<Payment> allPayments = (List<Payment>) request.getAttribute("allPayments");
    List<Booking> allBookings = (List<Booking>) request.getAttribute("allBookings");
    double totalRevenue = 0;
    if (allPayments != null) { for (Payment p : allPayments) totalRevenue += p.getFinalAmount(); }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin | All Transactions</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        body { font-family: 'Poppins', sans-serif; background: linear-gradient(to right, #24243e, #302b63, #0f0c29); color: white; min-height: 100vh; }
        .glass-card { background: rgba(255,255,255,0.05); backdrop-filter: blur(10px); border: 1px solid rgba(255,255,255,0.1); border-radius: 15px; padding: 25px; }
        .stat-card { background: rgba(255,255,255,0.08); border-radius: 12px; padding: 20px; text-align: center; }
        .stat-num { font-size: 1.8rem; font-weight: 600; color: #ffc107; }
        .stat-label { font-size: 0.8rem; color: #aaa; letter-spacing: 1px; text-transform: uppercase; }
        .table { color: white; border-color: rgba(255,255,255,0.1); font-size: 0.85rem; }
        .table thead th { border-bottom: 1px solid rgba(255,255,255,0.2); color: #bbb; font-weight: 500; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 1px; }
        .table td { border-color: rgba(255,255,255,0.07); vertical-align: middle; }
        .table-hover tbody tr:hover { background: rgba(255,255,255,0.06); }
        .badge-success { background: rgba(76,175,80,0.2); color: #4caf50; border: 1px solid #4caf50; border-radius: 20px; font-size: 0.72rem; padding: 2px 8px; }
        .navbar-custom { background: rgba(0,0,0,0.4); backdrop-filter: blur(10px); border-bottom: 1px solid rgba(255,255,255,0.1); }
        .section-title { font-size: 0.75rem; color: #888; letter-spacing: 2px; text-transform: uppercase; margin-bottom: 16px; }
    </style>
</head>
<body>

<nav class="navbar navbar-dark navbar-custom px-4 py-3">
    <a class="navbar-brand fw-bold fs-5" href="${pageContext.request.contextPath}/index.jsp">🎬 CineBooking</a>
    <div class="d-flex gap-3">
        <a href="${pageContext.request.contextPath}/UserController?action=adminDashboard" class="text-light text-decoration-none small">← User Dashboard</a>
    </div>
</nav>

<div class="container py-4">
    <h2 class="fw-600 mb-4">Transaction Management</h2>

    <!-- Stats -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-num"><%= allPayments != null ? allPayments.size() : 0 %></div>
                <div class="stat-label">Total Transactions</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-num"><%= allBookings != null ? allBookings.size() : 0 %></div>
                <div class="stat-label">Total Bookings</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-num">LKR <%= String.format("%.0f", totalRevenue) %></div>
                <div class="stat-label">Total Revenue</div>
            </div>
        </div>
    </div>

    <!-- Payments Table -->
    <div class="glass-card mb-4">
        <div class="section-title">All Payments</div>
        <% if (allPayments == null || allPayments.isEmpty()) { %>
            <p class="text-muted text-center py-3">No payments yet.</p>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead><tr>
                    <th>Transaction ID</th><th>User</th><th>Method</th><th>Subtotal</th><th>Discount</th><th>Final</th><th>Status</th><th>Date</th>
                </tr></thead>
                <tbody>
                <% for (Payment p : allPayments) {
                    CardPayment cp = (p instanceof CardPayment) ? (CardPayment) p : null; %>
                <tr>
                    <td><span style="font-family:monospace;font-size:0.8rem"><%= p.getTransactionId() %></span></td>
                    <td><%= p.getUserEmail() %></td>
                    <td><% if (cp != null) { %><span class="badge bg-secondary"><%= cp.getCardType() %></span><% } %></td>
                    <td>LKR <%= String.format("%.2f", p.getAmount()) %></td>
                    <td style="color:<%= p.getDiscount()>0?"#4caf50":"#888" %>">- LKR <%= String.format("%.2f", p.getDiscount()) %></td>
                    <td style="color:#ffc107;font-weight:600">LKR <%= String.format("%.2f", p.getFinalAmount()) %></td>
                    <td><span class="badge-success"><%= p.getStatus() %></span></td>
                    <td style="font-size:0.8rem"><%= p.getPaymentDate() %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>

    <!-- Bookings Table -->
    <div class="glass-card">
        <div class="section-title">All Bookings</div>
        <% if (allBookings == null || allBookings.isEmpty()) { %>
            <p class="text-muted text-center py-3">No bookings yet.</p>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead><tr>
                    <th>Booking ID</th><th>User</th><th>Movie</th><th>Seats</th><th>Amount</th><th>Status</th><th>Date</th>
                </tr></thead>
                <tbody>
                <% for (Booking b : allBookings) { %>
                <tr>
                    <td><span style="font-family:monospace;font-size:0.8rem"><%= b.getBookingId() %></span></td>
                    <td><%= b.getUserEmail() %></td>
                    <td><%= b.getMovieName() %></td>
                    <td><%= b.getSelectedSeats() %> (<%= b.getNumberOfSeats() %>)</td>
                    <td style="color:#ffc107">LKR <%= String.format("%.2f", b.getTotalAmount()) %></td>
                    <td><span class="badge-success"><%= b.getStatus() %></span></td>
                    <td style="font-size:0.8rem"><%= b.getBookingDate() %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
