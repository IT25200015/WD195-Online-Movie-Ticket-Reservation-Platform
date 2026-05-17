<%@ page import="com.cinebooking.models.User" %>
<%@ page import="com.cinebooking.models.Payment" %>
<%@ page import="com.cinebooking.models.CardPayment" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("UserController?action=login");
        return;
    }
    List<Payment> myPayments = (List<Payment>) request.getAttribute("myPayments");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings | CineBooking</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --cinema-bg: #121212;
            --cinema-surface: #1a1a1a;
            --cinema-accent: #e50914;
            --cinema-text: #f5f5f5;
            --cinema-muted: #b9b9b9;
        }
        body { font-family: 'Poppins', sans-serif; background-color: var(--cinema-bg); color: var(--cinema-text); min-height: 100vh; padding: 40px 0; }
        .page-title { font-size: 1.8rem; font-weight: 600; letter-spacing: 2px; margin-bottom: 30px; }
        .booking-item { background: var(--cinema-surface); border: 1px solid rgba(255,255,255,0.08); border-radius: 12px; padding: 20px; margin-bottom: 14px; }
        .booking-txn { font-family: monospace; color: var(--cinema-accent); font-size: 0.85rem; }
        .booking-detail { color: var(--cinema-muted); font-size: 0.82rem; margin-top: 4px; }
        .booking-amount { font-weight: 600; font-size: 1rem; color: var(--cinema-text); }
        .badge-success { background: rgba(76,175,80,0.15); color: #4caf50; border: 1px solid #4caf50; border-radius: 20px; font-size: 0.72rem; padding: 2px 10px; }
        .btn-new {
            background-color: var(--cinema-accent);
            border: none; color: #fff;
            border-radius: 999px;
            padding: 9px 22px;
            font-size: 0.85rem;
            font-weight: 600;
            transition: 0.3s;
        }
        .btn-new:hover { filter: brightness(1.1); color: #fff; }
        .back-link { color: var(--cinema-muted); font-size: 0.85rem; text-decoration: none; }
        .back-link:hover { color: var(--cinema-text); }
        .empty-state { background: var(--cinema-surface); border-radius: 12px; padding: 50px; text-align: center; color: var(--cinema-muted); }
    </style>
</head>
<body>
<div class="container">

    <div class="mb-3">
        <a href="UserController?action=profile" class="back-link">← Back to Profile</a>
    </div>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div class="page-title">MY BOOKINGS</div>
        <a href="PaymentController?action=selectMovie" class="btn btn-new">+ BOOK NEW</a>
    </div>

    <% if (myPayments == null || myPayments.isEmpty()) { %>
        <div class="empty-state">
            <p style="font-size:2rem">🎟</p>
            <p>You haven't made any bookings yet.</p>
            <a href="PaymentController?action=selectMovie" class="btn btn-new mt-2">Browse Movies</a>
        </div>
    <% } else {
        // Show newest first
        for (int i = myPayments.size() - 1; i >= 0; i--) {
            Payment p = myPayments.get(i);
            CardPayment cp = (p instanceof CardPayment) ? (CardPayment) p : null;
    %>
        <div class="booking-item">
            <div class="d-flex justify-content-between align-items-start">
                <div>
                    <div class="booking-txn"><%= p.getTransactionId() %></div>
                    <div class="booking-detail">Date: <%= p.getPaymentDate() %></div>
                    <div class="booking-detail">Booking ID: <%= p.getBookingId() %></div>
                    <% if (cp != null) { %>
                        <div class="booking-detail">Card: <%= cp.getCardType() %> <%= cp.getMaskedCardNumber() %></div>
                    <% } %>
                </div>
                <div class="text-end">
                    <div class="booking-amount">LKR <%= String.format("%.2f", p.getFinalAmount()) %></div>
                    <% if (p.getDiscount() > 0) { %>
                        <div style="font-size:0.78rem;color:#4caf50">Saved LKR <%= String.format("%.2f", p.getDiscount()) %></div>
                    <% } %>
                    <div class="mt-2"><span class="badge-success"><%= p.getStatus() %></span></div>
                </div>
            </div>
        </div>
    <% } } %>

</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
