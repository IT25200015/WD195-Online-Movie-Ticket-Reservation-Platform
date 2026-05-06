<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>CineBooking | Home</title>
    <%@ include file="includes/header.jsp" %>
    <style>
        :root {
            --cinema-bg: #121212;
            --cinema-surface: #1a1a1a;
            --cinema-surface-2: #222222;
            --cinema-accent: #e50914;
            --cinema-text: #f5f5f5;
            --cinema-muted: #b9b9b9;
            --cinema-glow: rgba(229, 9, 20, 0.35);
        }

        body.cinema-body {
            background-color: var(--cinema-bg);
            color: var(--cinema-text);
        }

        .cinema-hero {
            position: relative;
            margin-top: 88px;
            border-radius: 18px;
            overflow: hidden;
            min-height: 420px;
            display: grid;
            align-items: center;
            background-image: linear-gradient(120deg, rgba(0, 0, 0, 0.72) 20%, rgba(0, 0, 0, 0.3) 65%),
                url("https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?q=80&w=1600&auto=format&fit=crop");
            background-size: cover;
            background-position: center;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.45);
            animation: fadeUp 0.9s ease-out both;
        }

        .cinema-hero::after {
            content: "";
            position: absolute;
            inset: 0;
            background: linear-gradient(180deg, rgba(0, 0, 0, 0.08), rgba(0, 0, 0, 0.5));
        }

        .hero-content {
            position: relative;
            z-index: 1;
            padding: 48px 56px;
            max-width: 620px;
        }

        .hero-title {
            font-size: clamp(2.3rem, 4vw, 3.6rem);
            font-weight: 700;
            letter-spacing: 0.5px;
            margin-bottom: 12px;
        }

        .hero-subtitle {
            color: var(--cinema-muted);
            font-size: 1.05rem;
            margin-bottom: 24px;
        }

        .hero-tags {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }

        .hero-tag {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.15);
            color: var(--cinema-text);
            padding: 6px 14px;
            border-radius: 999px;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .hero-actions {
            display: flex;
            gap: 14px;
            flex-wrap: wrap;
        }

        .cinema-btn {
            border-radius: 999px;
            padding: 12px 26px;
            font-weight: 600;
            border: none;
            background: var(--cinema-accent);
            color: #fff;
            box-shadow: 0 12px 24px var(--cinema-glow);
            transition: transform 0.3s ease, box-shadow 0.3s ease, filter 0.3s ease;
        }

        .cinema-btn:hover {
            transform: translateY(-2px) scale(1.02);
            box-shadow: 0 16px 34px rgba(229, 9, 20, 0.45);
            filter: brightness(1.05);
        }

        .cinema-btn.secondary {
            background: transparent;
            border: 1px solid rgba(255, 255, 255, 0.35);
            color: var(--cinema-text);
            box-shadow: none;
        }

        .cinema-section {
            margin-top: 56px;
            animation: fadeIn 0.8s ease-out both;
        }

        .section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
        }

        .section-title {
            font-size: 1.6rem;
            font-weight: 700;
        }

        .section-subtitle {
            color: var(--cinema-muted);
        }

        .movie-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 24px;
        }

        .movie-card {
            background: var(--cinema-surface);
            border-radius: 16px;
            padding: 16px;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.35);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            animation: fadeUp 0.8s ease-out both;
        }

        .movie-card:hover {
            transform: translateY(-6px) scale(1.02);
            box-shadow: 0 16px 40px var(--cinema-glow);
        }

        .movie-poster {
            border-radius: 12px;
            overflow: hidden;
            aspect-ratio: 2 / 3;
            background: var(--cinema-surface-2);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--cinema-muted);
            font-size: 0.9rem;
            margin-bottom: 16px;
            transition: transform 0.35s ease, box-shadow 0.35s ease;
        }

        .movie-card:hover .movie-poster {
            transform: scale(1.05);
            box-shadow: 0 12px 24px rgba(255, 255, 255, 0.08);
        }

        .movie-title {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 6px;
        }

        .movie-meta {
            color: var(--cinema-muted);
            font-size: 0.9rem;
            margin-bottom: 12px;
        }

        .movie-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .ghost-btn {
            border-radius: 999px;
            padding: 8px 18px;
            border: 1px solid rgba(255, 255, 255, 0.25);
            color: var(--cinema-text);
            background: transparent;
            font-size: 0.85rem;
        }

        @keyframes fadeUp {
            from {
                opacity: 0;
                transform: translateY(18px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }

        @media (max-width: 1200px) {
            .movie-grid {
                grid-template-columns: repeat(3, minmax(0, 1fr));
            }
        }

        @media (max-width: 992px) {
            .cinema-hero {
                margin-top: 76px;
                min-height: 360px;
            }

            .hero-content {
                padding: 36px;
            }

            .movie-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 768px) {
            .movie-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body class="cinema-body">
<%@ include file="includes/navbar.jsp" %>

<div class="container">
    <section class="cinema-hero">
        <div class="hero-content">
            <div class="hero-tags">
                <span class="hero-tag">Sci-Fi</span>
                <span class="hero-tag">Thriller</span>
                <span class="hero-tag">Adventure</span>
            </div>
            <h1 class="hero-title">Welcome to CineBooking</h1>
            <p class="hero-subtitle">Book premium movie experiences with a cinematic view, curated showtimes, and instant access.</p>
            <div class="hero-actions">
                <a class="cinema-btn" href="${pageContext.request.contextPath}/UserController?action=register" role="button">Buy Ticket</a>
                <button class="cinema-btn secondary" type="button">Watch Trailer</button>
            </div>
        </div>
    </section>

    <section class="cinema-section">
        <div class="section-header">
            <div>
                <div class="section-title">Now Showing</div>
                <div class="section-subtitle">Discover the latest releases and fan favorites.</div>
            </div>
        </div>

        <div class="movie-grid">
            <article class="movie-card">
                <div class="movie-poster">Poster</div>
                <div class="movie-title">Interstellar Reunion</div>
                <div class="movie-meta">Sci-Fi • 2h 40m</div>
                <div class="movie-actions">
                    <button class="ghost-btn" type="button">Details</button>
                    <button class="ghost-btn" type="button">Showtimes</button>
                </div>
            </article>

            <article class="movie-card">
                <div class="movie-poster">Poster</div>
                <div class="movie-title">Echoes of Midnight</div>
                <div class="movie-meta">Mystery • 1h 55m</div>
                <div class="movie-actions">
                    <button class="ghost-btn" type="button">Details</button>
                    <button class="ghost-btn" type="button">Showtimes</button>
                </div>
            </article>

            <article class="movie-card">
                <div class="movie-poster">Poster</div>
                <div class="movie-title">Neon Horizon</div>
                <div class="movie-meta">Action • 2h 10m</div>
                <div class="movie-actions">
                    <button class="ghost-btn" type="button">Details</button>
                    <button class="ghost-btn" type="button">Showtimes</button>
                </div>
            </article>

            <article class="movie-card">
                <div class="movie-poster">Poster</div>
                <div class="movie-title">Aurora Rising</div>
                <div class="movie-meta">Drama • 2h 05m</div>
                <div class="movie-actions">
                    <button class="ghost-btn" type="button">Details</button>
                    <button class="ghost-btn" type="button">Showtimes</button>
                </div>
            </article>
        </div>
    </section>
</div>

<%@ include file="includes/footer.jsp" %>
</body>
</html>

