<%@ page import="com.cinebooking.models.User" %>
<%@ page import="com.cinebooking.models.Payment" %>
<%@ page import="com.cinebooking.models.CardPayment" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("UserController?action=login");
        return;
    }
    Payment payment = (Payment) request.getAttribute("payment");
    if (payment == null) {
        response.sendRedirect("PaymentController?action=selectMovie");
        return;
    }
    // Polymorphism - using instanceof to check the actual type
    CardPayment cp = (payment instanceof CardPayment) ? (CardPayment) payment : null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Confirmed | CineBooking</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --cinema-bg: #121212;
            --cinema-surface: #1a1a1a;
            --cinema-accent: #e50914;
            --cinema-text: #f5f5f5;
            --cinema-muted: #b9b9b9;
            --cinema-glow: rgba(229, 9, 20, 0.35);
        }
        body { font-family: 'Poppins', sans-serif; background-color: var(--cinema-bg); color: var(--cinema-text); min-height: 100vh; display: flex; align-items: center; padding: 40px 0; }
        .card-surface { background: var(--cinema-surface); border: 1px solid rgba(255,255,255,0.08); border-radius: 16px; padding: 30px; }
        .check-icon { font-size: 3.5rem; color: #4caf50; }
        .txn-id { font-family: monospace; font-size: 1.1rem; color: var(--cinema-accent); letter-spacing: 2px; }
        .detail-row { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid rgba(255,255,255,0.06); font-size: 0.9rem; }
        .detail-row:last-child { border: none; }
        .detail-label { color: var(--cinema-muted); }
        .total-row { font-weight: 600; color: var(--cinema-accent); font-size: 1rem; }
        .btn-action {
            background: transparent;
            border: 1px solid rgba(255,255,255,0.25);
            color: var(--cinema-text);
            border-radius: 999px;
            padding: 9px 22px;
            font-size: 0.85rem;
            transition: 0.3s;
        }
        .btn-action:hover { background: rgba(255,255,255,0.08); color: var(--cinema-text); }
    </style>
</head>
<script>
    window.onload = async function() {
        console.log("Page loaded. Confirming bookings...");

        try {
            const response = await fetch("<%= request.getContextPath() %>/booking", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: "action=confirmBookings"
            });

            if (response.ok) {
                console.log("Bookings confirmed successfully!");
            } else {
                console.error("Server responded with status:", response.status);
            }
        } catch (error) {
            console.error("Network error occurred during confirmation:", error);
            alert("A network error occurred. Please check your connection and try again.");
        }
    };
</script>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6">

            <!-- Success header -->
            <div class="card-surface text-center mb-3">
                <div class="check-icon mb-2">✓</div>
                <h3 style="font-weight:600;letter-spacing:1px">BOOKING CONFIRMED!</h3>
                <p style="color:var(--cinema-muted);font-size:0.9rem">Your payment was processed successfully.</p>
                <div class="txn-id mb-1"><%= payment.getTransactionId() %></div>
                <small style="color:var(--cinema-muted)">Transaction ID</small>
            </div>

            <!-- Payment details -->
            <div class="card-surface mb-3">
                <div style="font-size:0.75rem;color:var(--cinema-muted);letter-spacing:2px;text-transform:uppercase;margin-bottom:14px">Payment Summary</div>

                <div class="detail-row">
                    <span class="detail-label">Payment Method</span>
                    <span><% if (cp != null) { %><%= cp.getCardType() %> <%= cp.getMaskedCardNumber() %><% } %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Date</span>
                    <span><%= payment.getPaymentDate() %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Subtotal</span>
                    <span>LKR <%= String.format("%.2f", payment.getAmount()) %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Discount</span>
                    <span style="color:#4caf50">- LKR <%= String.format("%.2f", payment.getDiscount()) %></span>
                </div>
                <div class="detail-row total-row">
                    <span>Total Paid</span>
                    <span>LKR <%= String.format("%.2f", payment.getFinalAmount()) %></span>
                </div>
            </div>

            <!-- Buttons -->
            <div class="d-flex gap-3 justify-content-center flex-wrap">
                <a href="booking?action=myBookings&page=history" class="btn btn-action">My Bookings</a>
                <a href="movies" class="btn btn-action">Book Another</a>
                <a href="UserController?action=profile" class="btn btn-action">Back to Profile</a>
            </div>

        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
