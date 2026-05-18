<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>About | CINEBOOKING</title>
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

        .about-hero {
            background: linear-gradient(135deg, rgba(229, 9, 20, 0.08), rgba(0, 0, 0, 0.6));
            border-radius: 18px;
            padding: 36px;
            border: 1px solid rgba(255, 255, 255, 0.08);
            box-shadow: 0 18px 45px rgba(0, 0, 0, 0.4);
        }

        .about-title {
            font-size: clamp(2rem, 4vw, 2.8rem);
            font-weight: 700;
        }

        .about-subtitle {
            color: var(--cinema-muted);
            margin-top: 12px;
            max-width: 720px;
        }

        .feature-card {
            background: var(--cinema-surface);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 16px;
            padding: 24px;
            height: 100%;
            transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease;
        }

        .feature-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 16px 32px rgba(0, 0, 0, 0.35);
            border-color: rgba(229, 9, 20, 0.35);
        }

        .feature-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            background: rgba(229, 9, 20, 0.12);
            color: var(--cinema-accent);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            margin-bottom: 16px;
        }

        .feature-title {
            font-weight: 600;
            margin-bottom: 10px;
        }

        .feature-text {
            color: var(--cinema-muted);
            font-size: 0.95rem;
            line-height: 1.6;
        }
    </style>
</head>
<body class="cinema-page">
<jsp:include page="/includes/navbar.jsp" />

<main class="flex-grow-1 container mt-5">
    <section class="about-hero mb-5">
        <h1 class="about-title">About CINEBOOKING</h1>
        <p class="about-subtitle">We deliver a premium, seamless blockbuster experience with curated showtimes, intuitive booking, and cinematic presentation that makes every night feel like opening night.</p>
    </section>

    <section>
        <div class="row g-4">
            <div class="col-12 col-md-4">
                <div class="feature-card">
                    <div class="feature-icon"><i class="bi bi-film"></i></div>
                    <h5 class="feature-title">Latest Movies</h5>
                    <p class="feature-text">Discover the newest releases and trending titles with rich previews and detailed showtimes.</p>
                </div>
            </div>
            <div class="col-12 col-md-4">
                <div class="feature-card">
                    <div class="feature-icon"><i class="bi bi-stars"></i></div>
                    <h5 class="feature-title">Exclusive Offers</h5>
                    <p class="feature-text">Unlock member perks, curated promotions, and cinematic bundles tailored for movie lovers.</p>
                </div>
            </div>
            <div class="col-12 col-md-4">
                <div class="feature-card">
                    <div class="feature-icon"><i class="bi bi-lightning"></i></div>
                    <h5 class="feature-title">Instant Booking</h5>
                    <p class="feature-text">Reserve your seats in seconds with a smooth checkout and real-time availability.</p>
                </div>
            </div>
        </div>
    </section>
</main>

<jsp:include page="/includes/footer.jsp" />
</body>
</html>

