<%@ page import="com.cinebooking.models.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("UserController?action=login");
        return;
    }
    String movieName = request.getAttribute("movieName") != null ? (String) request.getAttribute("movieName") : "";
    String showtime  = request.getAttribute("showtime")  != null ? (String) request.getAttribute("showtime")  : "";
    String seats     = request.getAttribute("seats")     != null ? (String) request.getAttribute("seats")     : "";
    String total     = request.getAttribute("total")     != null ? (String) request.getAttribute("total")     : "0";
    String error     = (String) request.getAttribute("error");
    double totalD    = Double.parseDouble(total);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment | CineBooking</title>
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
        body { font-family: 'Poppins', sans-serif; background-color: var(--cinema-bg); color: var(--cinema-text); min-height: 100vh; padding: 40px 0; }
        .card-surface { background: var(--cinema-surface); border: 1px solid rgba(255,255,255,0.08); border-radius: 16px; padding: 30px; }
        .section-label { font-size: 0.75rem; color: var(--cinema-muted); letter-spacing: 2px; text-transform: uppercase; margin-bottom: 14px; border-bottom: 1px solid rgba(255,255,255,0.07); padding-bottom: 6px; }
        .custom-input { background-color: #222; border: 1px solid rgba(255,255,255,0.15); border-radius: 10px; color: var(--cinema-text) !important; padding: 10px 14px; }
        .custom-input::placeholder { color: rgba(255,255,255,0.35); }
        .custom-input:focus { border-color: var(--cinema-accent); box-shadow: 0 0 0 3px rgba(229,9,20,0.15); outline: none; background: #222; }
        .form-label { font-size: 0.82rem; color: var(--cinema-muted); margin-bottom: 5px; }
        .summary-row { display: flex; justify-content: space-between; font-size: 0.9rem; padding: 7px 0; border-bottom: 1px solid rgba(255,255,255,0.06); }
        .summary-row.total { font-weight: 600; color: var(--cinema-accent); font-size: 1rem; border: none; margin-top: 6px; }
        .btn-pay {
            background-color: var(--cinema-accent);
            border: none; color: #fff;
            border-radius: 999px;
            padding: 13px;
            font-weight: 700;
            letter-spacing: 1px;
            width: 100%;
            transition: 0.3s;
            box-shadow: 0 6px 20px var(--cinema-glow);
        }
        .btn-pay:hover { filter: brightness(1.1); color: #fff; }
        .back-link { color: var(--cinema-muted); font-size: 0.85rem; text-decoration: none; }
        .back-link:hover { color: var(--cinema-text); }
        .promo-hint { font-size: 0.75rem; color: var(--cinema-muted); margin-top: 4px; }
    </style>
</head>
<body>
<div class="container">

    <div class="text-center mb-3">
        <a href="PaymentController?action=selectMovie" class="back-link">← Back to Movies</a>
    </div>

    <div class="row justify-content-center g-4">

        <!-- Left: Summary -->
        <div class="col-md-4">
            <div class="card-surface">
                <div class="section-label">Booking Summary</div>
                <div class="summary-row"><span>Movie</span><span><%= movieName %></span></div>
                <div class="summary-row"><span>Showtime</span><span><%= showtime %></span></div>
                <div class="summary-row"><span>Tickets</span><span><%= seats %></span></div>
                <div class="summary-row"><span>Subtotal</span><span>LKR <%= String.format("%.2f", totalD) %></span></div>
                <div class="summary-row"><span>Discount</span><span id="discountDisplay">LKR 0.00</span></div>
                <div class="summary-row total"><span>Total</span><span id="finalDisplay">LKR <%= String.format("%.2f", totalD) %></span></div>
            </div>
            <div class="card-surface mt-3">
                <div class="section-label">Promo Codes</div>
                <p class="promo-hint"><code style="color:#e50914">MOVIE10</code> — 10% off</p>
                <p class="promo-hint"><code style="color:#e50914">CINE20</code> — 20% off</p>
            </div>
        </div>

        <!-- Right: Payment Form -->
        <div class="col-md-6">
            <div class="card-surface">
                <h5 class="mb-4" style="font-weight:600;letter-spacing:1px">PAYMENT DETAILS</h5>

                <% if (error != null) { %>
                    <div class="alert alert-danger py-2 small"><%= error %></div>
                <% } %>

                <form method="post" action="${pageContext.request.contextPath}/PaymentController">
                    <input type="hidden" name="action"    value="processPayment">
                    <input type="hidden" name="movieName" value="<%= movieName %>">
                    <input type="hidden" name="showtime"  value="<%= showtime %>">
                    <input type="hidden" name="seats"     value="<%= seats %>">
                    <input type="hidden" name="total"     value="<%= total %>">

                    <div class="section-label">Card Details</div>

                    <div class="mb-3">
                        <label class="form-label">Card Type</label>
                        <select name="cardType" class="form-control custom-input">
                            <option value="VISA">VISA</option>
                            <option value="MASTERCARD">Mastercard</option>
                            <option value="AMEX">Amex</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Card Holder Name</label>
                        <input type="text" name="cardHolderName" class="form-control custom-input" placeholder="As shown on card" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Card Number</label>
                        <input type="text" name="cardNumber" id="cardNumberInput" class="form-control custom-input" placeholder="1234 5678 9012 3456" maxlength="19" required oninput="formatCard(this)">
                    </div>

                    <div class="row">
                        <div class="col-6 mb-3">
                            <label class="form-label">Expiry Date</label>
                            <input type="text" name="expiry" class="form-control custom-input" placeholder="MM/YY" maxlength="5">
                        </div>
                        <div class="col-6 mb-3">
                            <label class="form-label">CVV</label>
                            <input type="password" name="cvv" class="form-control custom-input" placeholder="•••" maxlength="4">
                        </div>
                    </div>

                    <div class="section-label mt-2">Promo Code</div>
                    <div class="input-group mb-3">
                        <input type="text" name="promoCode" id="promoInput" class="form-control custom-input" placeholder="Enter promo code (optional)">
                        <button type="button" class="btn" style="background:var(--cinema-accent);color:#fff;border-radius:0 10px 10px 0" onclick="applyPromo()">Apply</button>
                    </div>
                    <div id="promoMsg" class="small mb-3"></div>

                    <button type="submit" class="btn btn-pay mt-2">🔒 PAY NOW</button>
                </form>
            </div>
        </div>

    </div>
</div>

<script>
    const baseTotal = <%= totalD %>;

    function formatCard(input) {
        let v = input.value.replace(/\D/g, '').substring(0, 16);
        input.value = (v.match(/.{1,4}/g) || []).join(' ');
    }

    function applyPromo() {
        const code = document.getElementById('promoInput').value.trim().toUpperCase();
        let discount = 0, msg = '';
        if      (code === 'MOVIE10') { discount = baseTotal * 0.10; msg = '<span style="color:#4caf50">✓ 10% discount applied!</span>'; }
        else if (code === 'CINE20') { discount = baseTotal * 0.20; msg = '<span style="color:#4caf50">✓ 20% discount applied!</span>'; }
        else if (code)              { msg = '<span style="color:#e50914">✗ Invalid promo code.</span>'; }

        document.getElementById('promoMsg').innerHTML = msg;
        document.getElementById('discountDisplay').textContent = 'LKR ' + discount.toFixed(2);
        document.getElementById('finalDisplay').textContent    = 'LKR ' + (baseTotal - discount).toFixed(2);
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
