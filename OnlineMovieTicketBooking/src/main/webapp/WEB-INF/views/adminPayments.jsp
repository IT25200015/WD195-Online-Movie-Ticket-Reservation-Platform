<%@ page import="com.cinebooking.models.User" %>
<%@ page import="com.cinebooking.models.Payment" %>
<%@ page import="com.cinebooking.models.CardPayment" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    User sessionUser = (User) session.getAttribute("user");
    if (sessionUser == null || !"Admin".equals(sessionUser.getRole())) {
        response.sendRedirect("UserController?action=login");
        return;
    }
    List<Payment> allPayments = (List<Payment>) request.getAttribute("allPayments");
    double totalRevenue = 0;
    int totalTransactions = 0;
    if (allPayments != null) {
        totalTransactions = allPayments.size();
        for (Payment p : allPayments) totalRevenue += p.getFinalAmount();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Transaction Management | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; background: linear-gradient(to right, #24243e, #302b63, #0f0c29); color: white; min-height: 100vh; }
        .dashboard-container { margin-top: 40px; margin-bottom: 40px; }
        .brand-title { font-size: 2rem; font-weight: 600; letter-spacing: 2px; text-transform: uppercase; color: #ffffff; margin-bottom: 5px; }
        .brand-subtitle { color: #bbb; font-size: 1rem; letter-spacing: 1px; margin-bottom: 40px; }
        .glass-card { background: rgba(255,255,255,0.05); backdrop-filter: blur(10px); border: 1px solid rgba(255,255,255,0.1); border-radius: 15px; padding: 25px; box-shadow: 0 8px 32px 0 rgba(0,0,0,0.8); }
        .stat-card { background: rgba(255,255,255,0.08); border-radius: 12px; padding: 20px; text-align: center; }
        .stat-num { font-size: 1.8rem; font-weight: 600; color: #ffc107; }
        .stat-label { font-size: 0.78rem; color: #aaa; letter-spacing: 1px; text-transform: uppercase; }
        .table { color: white; border-color: rgba(255,255,255,0.1); font-size: 0.85rem; }
        .table thead th { border-bottom: 2px solid rgba(255,255,255,0.2); color: #bbb; font-weight: 600; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 1px; }
        .table td { border-color: rgba(255,255,255,0.07); vertical-align: middle; }
        .table-hover tbody tr:hover { background-color: rgba(255,255,255,0.06); color: white; }
        .custom-btn-warning { background: transparent; border: 1px solid #ffc107; color: #ffc107; transition: 0.3s; padding: 5px 15px; font-size: 0.85rem; border-radius: 0; letter-spacing: 1px; text-transform: uppercase; text-decoration: none; }
        .custom-btn-warning:hover { background: #ffc107; color: #000; }
    </style>
</head>
<body>

<jsp:include page="/includes/navbar.jsp" />

<div class="container dashboard-container">
    <div class="row mb-4">
        <div class="col text-center">
            <h1 class="brand-title">Transaction Management</h1>
            <p class="brand-subtitle">View all payments processed through CineBooking.</p>
            <a href="UserController?action=adminDashboard" class="custom-btn-warning">← Back to User Dashboard</a>
        </div>
    </div>

    <!-- Stats -->
    <div class="row g-3 mb-4">
        <div class="col-md-6">
            <div class="stat-card">
                <div class="stat-num"><%= totalTransactions %></div>
                <div class="stat-label">Total Transactions</div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="stat-card">
                <div class="stat-num">LKR <%= String.format("%.0f", totalRevenue) %></div>
                <div class="stat-label">Total Revenue</div>
            </div>
        </div>
    </div>

    <div class="glass-card">
        <h3 class="mb-4" style="font-weight:300;letter-spacing:1px">ALL PAYMENTS</h3>
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead>
                    <tr>
                        <th>Transaction ID</th>
                        <th>User</th>
                        <th>Card</th>
                        <th>Subtotal</th>
                        <th>Discount</th>
                        <th>Total Paid</th>
                        <th>Status</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody>
                <% if (allPayments == null || allPayments.isEmpty()) { %>
                    <tr><td colspan="8" class="text-center text-muted">No payments yet.</td></tr>
                <% } else {
                    for (Payment p : allPayments) {
                        CardPayment cp = (p instanceof CardPayment) ? (CardPayment) p : null;
                %>
                    <tr>
                        <td><span style="font-family:monospace;font-size:0.8rem"><%= p.getTransactionId() %></span></td>
                        <td><%= p.getUserEmail() %></td>
                        <td><% if (cp != null) { %><span class="badge bg-secondary"><%= cp.getCardType() %></span><% } %></td>
                        <td>LKR <%= String.format("%.2f", p.getAmount()) %></td>
                        <td style="color:<%= p.getDiscount()>0?"#4caf50":"#888" %>">- LKR <%= String.format("%.2f", p.getDiscount()) %></td>
                        <td style="color:#ffc107;font-weight:600">LKR <%= String.format("%.2f", p.getFinalAmount()) %></td>
                        <td><span class="badge bg-success"><%= p.getStatus() %></span></td>
                        <td style="font-size:0.8rem"><%= p.getPaymentDate() %></td>
                    </tr>
                <% } } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
