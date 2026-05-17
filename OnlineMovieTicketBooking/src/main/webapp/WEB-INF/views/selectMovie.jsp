<%@ page import="com.cinebooking.models.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("UserController?action=login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Tickets | CineBooking</title>
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
        .page-title { font-size: 2rem; font-weight: 600; letter-spacing: 2px; text-align: center; margin-bottom: 10px; }
        .page-sub { color: var(--cinema-muted); text-align: center; margin-bottom: 40px; }
        .movie-card { background: var(--cinema-surface); border: 1px solid rgba(255,255,255,0.08); border-radius: 16px; padding: 24px; margin-bottom: 20px; }
        .movie-title { font-size: 1.1rem; font-weight: 600; margin-bottom: 6px; }
        .movie-detail { color: var(--cinema-muted); font-size: 0.85rem; margin-bottom: 4px; }
        .price-tag { color: var(--cinema-accent); font-weight: 600; margin-bottom: 16px; }
        .qty-input {
            background: #222;
            border: 1px solid rgba(255,255,255,0.15);
            border-radius: 8px;
            color: var(--cinema-text);
            padding: 6px 10px;
            width: 70px;
            text-align: center;
            font-size: 0.9rem;
        }
        .qty-input:focus { border-color: var(--cinema-accent); outline: none; }
        .btn-book {
            background-color: var(--cinema-accent);
            border: none;
            color: #fff;
            border-radius: 999px;
            padding: 10px 24px;
            font-weight: 600;
            letter-spacing: 1px;
            transition: 0.3s;
            box-shadow: 0 6px 20px var(--cinema-glow);
        }
        .btn-book:hover { filter: brightness(1.1); color: #fff; }
        .back-link { color: var(--cinema-muted); font-size: 0.85rem; text-decoration: none; }
        .back-link:hover { color: var(--cinema-text); }
    </style>
</head>
<body>
<div class="container">

    <div class="text-center mb-2">
        <a href="UserController?action=profile" class="back-link">← Back to Profile</a>
    </div>

    <div class="page-title">NOW SHOWING</div>
    <div class="page-sub">Select a movie and number of tickets</div>

    <div class="row justify-content-center">
        <div class="col-md-8">

            <!-- Movie 1 -->
            <div class="movie-card">
                <div class="movie-title">Avengers: Doomsday</div>
                <div class="movie-detail">Genre: Action &nbsp;|&nbsp; Hall A</div>
                <div class="movie-detail">Date: 2026-05-20 &nbsp;|&nbsp; Time: 10:00 AM</div>
                <div class="price-tag">LKR 800 per ticket</div>
                <div class="d-flex align-items-center gap-3">
                    <label style="font-size:0.85rem;color:var(--cinema-muted)">Tickets:</label>
                    <input type="number" class="qty-input" id="qty1" value="1" min="1" max="10" oninput="updateTotal('qty1','total1',800)">
                    <span style="font-size:0.85rem;color:var(--cinema-muted)">Total: <span id="total1" style="color:var(--cinema-accent);font-weight:600">LKR 800</span></span>
                    <button class="btn btn-book" onclick="book('Avengers: Doomsday','2026-05-20 10:00AM',800,'qty1')">BOOK NOW</button>
                </div>
            </div>

            <!-- Movie 2 -->
            <div class="movie-card">
                <div class="movie-title">Minecraft Movie</div>
                <div class="movie-detail">Genre: Adventure &nbsp;|&nbsp; Hall B</div>
                <div class="movie-detail">Date: 2026-05-21 &nbsp;|&nbsp; Time: 02:00 PM</div>
                <div class="price-tag">LKR 700 per ticket</div>
                <div class="d-flex align-items-center gap-3">
                    <label style="font-size:0.85rem;color:var(--cinema-muted)">Tickets:</label>
                    <input type="number" class="qty-input" id="qty2" value="1" min="1" max="10" oninput="updateTotal('qty2','total2',700)">
                    <span style="font-size:0.85rem;color:var(--cinema-muted)">Total: <span id="total2" style="color:var(--cinema-accent);font-weight:600">LKR 700</span></span>
                    <button class="btn btn-book" onclick="book('Minecraft Movie','2026-05-21 02:00PM',700,'qty2')">BOOK NOW</button>
                </div>
            </div>

            <!-- Movie 3 -->
            <div class="movie-card">
                <div class="movie-title">Sinners</div>
                <div class="movie-detail">Genre: Horror &nbsp;|&nbsp; Hall C</div>
                <div class="movie-detail">Date: 2026-05-22 &nbsp;|&nbsp; Time: 08:00 PM</div>
                <div class="price-tag">LKR 900 per ticket</div>
                <div class="d-flex align-items-center gap-3">
                    <label style="font-size:0.85rem;color:var(--cinema-muted)">Tickets:</label>
                    <input type="number" class="qty-input" id="qty3" value="1" min="1" max="10" oninput="updateTotal('qty3','total3',900)">
                    <span style="font-size:0.85rem;color:var(--cinema-muted)">Total: <span id="total3" style="color:var(--cinema-accent);font-weight:600">LKR 900</span></span>
                    <button class="btn btn-book" onclick="book('Sinners','2026-05-22 08:00PM',900,'qty3')">BOOK NOW</button>
                </div>
            </div>

            <!-- Movie 4 -->
            <div class="movie-card">
                <div class="movie-title">Final Destination: Bloodlines</div>
                <div class="movie-detail">Genre: Thriller &nbsp;|&nbsp; Hall A</div>
                <div class="movie-detail">Date: 2026-05-23 &nbsp;|&nbsp; Time: 07:30 PM</div>
                <div class="price-tag">LKR 750 per ticket</div>
                <div class="d-flex align-items-center gap-3">
                    <label style="font-size:0.85rem;color:var(--cinema-muted)">Tickets:</label>
                    <input type="number" class="qty-input" id="qty4" value="1" min="1" max="10" oninput="updateTotal('qty4','total4',750)">
                    <span style="font-size:0.85rem;color:var(--cinema-muted)">Total: <span id="total4" style="color:var(--cinema-accent);font-weight:600">LKR 750</span></span>
                    <button class="btn btn-book" onclick="book('Final Destination: Bloodlines','2026-05-23 07:30PM',750,'qty4')">BOOK NOW</button>
                </div>
            </div>

        </div>
    </div>
</div>

<script>
    function updateTotal(qtyId, totalId, pricePerTicket) {
        const qty = Math.max(1, parseInt(document.getElementById(qtyId).value) || 1);
        document.getElementById(totalId).textContent = 'LKR ' + (qty * pricePerTicket);
    }

    function book(movieName, showtime, pricePerTicket, qtyId) {
        const qty = Math.max(1, parseInt(document.getElementById(qtyId).value) || 1);
        const total = qty * pricePerTicket;
        const tickets = qty + ' ticket' + (qty > 1 ? 's' : '');
        const url = 'PaymentController?action=paymentForm'
            + '&movieName=' + encodeURIComponent(movieName)
            + '&showtime='  + encodeURIComponent(showtime)
            + '&seats='     + encodeURIComponent(tickets)
            + '&total='     + total;
        window.location.href = url;
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
