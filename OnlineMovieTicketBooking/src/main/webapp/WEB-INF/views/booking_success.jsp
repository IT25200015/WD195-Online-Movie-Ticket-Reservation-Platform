<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Successful | CineBooking</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;900&family=Space+Mono:wght@400;700&display=swap" rel="stylesheet">
    <!-- QR Code Library -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>

    <style>
        :root {
            --bg: #0a0a0f;
            --surface: rgba(19, 19, 26, 0.7);
            --border: rgba(255, 255, 255, 0.1);
            --accent: #e50914;
            --text: #f0f0f5;
            --muted: #8888a0;
            --gold: #f5c518;
            --mono: 'Space Mono', monospace;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg);
            color: var(--text);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            background-image: 
                radial-gradient(circle at 15% 50%, rgba(229, 9, 20, 0.15), transparent 25%),
                radial-gradient(circle at 85% 30%, rgba(245, 197, 24, 0.1), transparent 25%);
        }

        .ticket-card {
            background: var(--surface);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 40px;
            max-width: 500px;
            width: 100%;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5), 0 0 20px rgba(229, 9, 20, 0.2);
            position: relative;
            overflow: hidden;
        }

        .ticket-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 5px;
            background: linear-gradient(90deg, var(--accent), var(--gold));
        }

        .success-icon {
            font-size: 3rem;
            color: #4ade80;
            text-align: center;
            margin-bottom: 10px;
            animation: popIn 0.5s cubic-bezier(0.34,1.56,0.64,1) both;
        }

        @keyframes popIn {
            from { transform: scale(0); opacity: 0; }
            to   { transform: scale(1); opacity: 1; }
        }

        .ticket-title {
            text-align: center;
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 30px;
            letter-spacing: 1px;
        }

        .ticket-detail {
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px dashed rgba(255, 255, 255, 0.15);
            padding-bottom: 15px;
        }

        .ticket-detail:last-of-type {
            border-bottom: none;
        }

        .detail-label {
            color: var(--muted);
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .detail-value {
            font-weight: 600;
            font-size: 1.1rem;
            text-align: right;
        }

        .detail-value.price {
            color: var(--gold);
            font-family: var(--mono);
            font-size: 1.3rem;
        }

        .qr-section {
            background: rgba(0, 0, 0, 0.3);
            border-radius: 12px;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            margin: 25px 0;
            border: 1px solid var(--border);
        }

        #qrcode {
            background: white;
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 10px;
        }

        .btn-home {
            background: var(--accent);
            color: white;
            border: none;
            width: 100%;
            padding: 12px;
            border-radius: 10px;
            font-weight: 600;
            letter-spacing: 1px;
            transition: all 0.3s;
            text-decoration: none;
            display: block;
            text-align: center;
        }

        .btn-home:hover {
            background: #f6121d;
            box-shadow: 0 5px 15px rgba(229, 9, 20, 0.4);
            color: white;
            transform: translateY(-2px);
        }

        /* Hidden elements to hold data for JS */
        #qr-data-movie, #qr-data-seats, #qr-data-price {
            display: none;
        }
    </style>
</head>
<body>

    <div class="ticket-card">
        <div class="success-icon">
            <i class="bi bi-check-circle-fill"></i>
        </div>
        <h1 class="ticket-title">Digital E-Ticket</h1>

        <div class="ticket-detail">
            <div class="detail-label">Movie Name</div>
            <div class="detail-value">${bookedMovieName}</div>
        </div>

        <div class="ticket-detail">
            <div class="detail-label">Booked Seats</div>
            <div class="detail-value">${bookedSeats}</div>
        </div>

        <div class="ticket-detail">
            <div class="detail-label">Total Price</div>
            <div class="detail-value price">LKR ${totalPrice}</div>
        </div>

        <div class="qr-section">
            <div id="qrcode"></div>
            <small class="text-muted mt-2">Scan at the cinema entrance</small>
        </div>

        <a href="${pageContext.request.contextPath}/home" class="btn-home">
            <i class="bi bi-house-door-fill me-2"></i> Go Back to Home
        </a>

        <!-- Data holders for JS -->
        <span id="qr-data-movie">${bookedMovieName}</span>
        <span id="qr-data-seats">${bookedSeats}</span>
        <span id="qr-data-price">${totalPrice}</span>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Fetch data from hidden spans
            const movie = document.getElementById('qr-data-movie').innerText.trim();
            const seats = document.getElementById('qr-data-seats').innerText.trim();
            const price = document.getElementById('qr-data-price').innerText.trim();

            // Format QR Code String
            const qrText = "Movie: " + movie + " | Seats: " + seats + " | Price: LKR " + price;

            // Generate QR Code
            new QRCode(document.getElementById("qrcode"), {
                text: qrText,
                width: 128,
                height: 128,
                colorDark : "#000000",
                colorLight : "#ffffff",
                correctLevel : QRCode.CorrectLevel.H
            });
        });

        // Call the confirm endpoint (moved from confirmation.jsp)
        window.addEventListener('load', async function() {
            try {
                const response = await fetch("${pageContext.request.contextPath}/booking", {
                    method: "POST",
                    headers: { "Content-Type": "application/x-www-form-urlencoded" },
                    body: "action=confirmBookings"
                });
                if (response.ok) {
                    console.log("Bookings confirmed successfully!");
                }
            } catch (error) {
                console.error("Network error occurred during confirmation:", error);
            }
        });
    </script>
</body>
</html>
