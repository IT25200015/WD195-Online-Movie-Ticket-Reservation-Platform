<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Contact | CINEBOOKING</title>
    <jsp:include page="/includes/header.jsp" />
    <style>
        :root {
            --cinema-bg: #121212;
            --cinema-surface: #1a1a1a;
            --cinema-surface-2: #222222;
            --cinema-accent: #e50914;
            --cinema-text: #f5f5f5;
            --cinema-muted: #b9b9b9;
        }

        body.cinema-page {
            background-color: var(--cinema-bg);
            color: var(--cinema-text);
        }

        .cinema-hero-title {
            font-size: clamp(2rem, 4vw, 2.8rem);
            font-weight: 700;
            margin-bottom: 10px;
        }

        .cinema-hero-subtitle {
            color: var(--cinema-muted);
            margin-bottom: 28px;
        }

        .cinema-card {
            background: var(--cinema-surface);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 16px;
            box-shadow: 0 16px 40px rgba(0, 0, 0, 0.35);
        }

        .cinema-card .card-body {
            padding: 28px;
        }

        .cinema-input {
            background-color: var(--cinema-surface-2);
            border: 1px solid rgba(255, 255, 255, 0.12);
            color: var(--cinema-text);
        }

        .cinema-input:focus {
            border-color: var(--cinema-accent);
            box-shadow: 0 0 0 3px rgba(229, 9, 20, 0.2);
            background-color: var(--cinema-surface-2);
            color: var(--cinema-text);
        }

        .cinema-btn {
            background: var(--cinema-accent);
            color: #ffffff;
            border: none;
            border-radius: 999px;
            padding: 12px 28px;
            font-weight: 600;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .cinema-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 24px rgba(229, 9, 20, 0.35);
        }

        .contact-detail {
            display: flex;
            gap: 14px;
            align-items: flex-start;
            padding: 14px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
        }

        .contact-detail:last-child {
            border-bottom: none;
        }

        .contact-icon {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            background: rgba(229, 9, 20, 0.15);
            color: var(--cinema-accent);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
        }

        .contact-label {
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--cinema-muted);
        }

        .contact-value {
            font-weight: 600;
            color: var(--cinema-text);
        }

        label,
        .form-label,
        .cinema-card h4,
        .cinema-card h5 {
            color: #b9b9b9;
            font-weight: 500;
        }

        .cinema-input,
        .form-control {
            color: #ffffff !important;
            background-color: #222222;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .cinema-input::placeholder,
        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.4) !important;
        }

        .cinema-input:focus,
        .form-control:focus {
            color: #ffffff !important;
            background-color: #222222;
            border-color: rgba(255, 255, 255, 0.2);
            box-shadow: 0 0 0 3px rgba(229, 9, 20, 0.2);
        }
    </style>
</head>
<body class="cinema-page">
<jsp:include page="/includes/navbar.jsp" />

<main class="flex-grow-1 container mt-5">
    <div class="mb-4">
        <h1 class="cinema-hero-title">Contact CINEBOOKING</h1>
        <p class="cinema-hero-subtitle">Have questions about showtimes or premium bookings? We are ready to help.</p>
    </div>

    <div class="row g-4">
        <div class="col-12 col-lg-7">
            <div class="card cinema-card h-100">
                <div class="card-body">
                    <h4 class="mb-3">Send us a message</h4>
                    <form>
                        <div class="mb-3">
                            <label class="form-label">Name</label>
                            <input type="text" class="form-control cinema-input" placeholder="Your full name" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" class="form-control cinema-input" placeholder="you@example.com" />
                        </div>
                        <div class="mb-4">
                            <label class="form-label">Message</label>
                            <textarea class="form-control cinema-input" rows="5" placeholder="Tell us how we can help"></textarea>
                        </div>
                        <button type="submit" class="cinema-btn">Send Message</button>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-12 col-lg-5">
            <div class="card cinema-card h-100">
                <div class="card-body">
                    <h4 class="mb-3">Contact details</h4>
                    <div class="contact-detail">
                        <span class="contact-icon"><i class="bi bi-envelope"></i></span>
                        <div>
                            <div class="contact-label">Email</div>
                            <div class="contact-value">support@cinebooking.lk</div>
                        </div>
                    </div>
                    <div class="contact-detail">
                        <span class="contact-icon"><i class="bi bi-telephone"></i></span>
                        <div>
                            <div class="contact-label">Hotline</div>
                            <div class="contact-value">+94 11 234 5678</div>
                        </div>
                    </div>
                    <div class="contact-detail">
                        <span class="contact-icon"><i class="bi bi-geo-alt"></i></span>
                        <div>
                            <div class="contact-label">Address</div>
                            <div class="contact-value">No. 88, Galle Road, Colombo 03, Sri Lanka</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
</body>
</html>
