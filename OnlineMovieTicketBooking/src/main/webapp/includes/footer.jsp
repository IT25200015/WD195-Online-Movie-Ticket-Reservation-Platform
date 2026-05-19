<footer class="cinema-footer">
    <div class="container py-5">
        <div class="row g-4">
            <div class="col-12 col-md-6 col-lg-3">
                <div class="brand-block">
                    <div class="brand-logo">CINE<span>BOOKING</span></div>
                    <p class="brand-tagline mb-0">Book your next blockbuster in seconds with a premium, seamless experience.</p>
                </div>
            </div>
            <div class="col-12 col-md-6 col-lg-3">
                <h6 class="footer-title">Quick Links</h6>
                <ul class="footer-links list-unstyled mb-0">
                    <li><a href="${pageContext.request.contextPath}/movies">Movies</a></li>
                    <li><a href="${pageContext.request.contextPath}/deals">Offers</a></li>
                    <li><a href="${pageContext.request.contextPath}/booking">Buy Tickets</a></li>
                    <li><a href="${pageContext.request.contextPath}/about.jsp">About Us</a></li>
                    <li><a href="${pageContext.request.contextPath}/contact.jsp">Contact Us</a></li>
                </ul>
            </div>
            <div class="col-12 col-md-6 col-lg-3">
                <h6 class="footer-title">Contact Info</h6>
                <div class="footer-contact">support@cinebooking.lk</div>
                <div class="footer-contact">Hotline: +94 11 234 5678</div>
            </div>
            <div class="col-12 col-md-6 col-lg-3">
                <h6 class="footer-title">Follow Us</h6>
                <div class="social-links">
                    <a href="#" aria-label="Facebook" class="social-icon"><i class="bi bi-facebook"></i></a>
                    <a href="#" aria-label="Instagram" class="social-icon"><i class="bi bi-instagram"></i></a>
                    <a href="#" aria-label="Twitter" class="social-icon"><i class="bi bi-twitter"></i></a>
                </div>
            </div>
        </div>
    </div>
    <div class="footer-bottom">
        <div class="container">
            <p class="mb-0">&copy; 2026 Online Movie Ticket Platform - Project Group-195</p>
        </div>
    </div>
</footer>

<style>
    .cinema-footer {
        background-color: #1a1a1a;
        color: #b9b9b9;
        margin-top: auto;
        font-family: "Poppins", sans-serif;
    }

    .brand-logo {
        font-size: 1.4rem;
        font-weight: 700;
        color: #f1f1f1;
        letter-spacing: 1px;
    }

    .brand-logo span {
        color: #e50914;
    }

    .brand-tagline {
        margin-top: 12px;
        font-size: 0.95rem;
        line-height: 1.5;
        color: #b9b9b9;
    }

    .footer-title {
        font-size: 0.95rem;
        font-weight: 600;
        color: #f1f1f1;
        margin-bottom: 12px;
        text-transform: uppercase;
        letter-spacing: 0.08em;
    }

    .footer-links li + li {
        margin-top: 8px;
    }

    .footer-links a {
        color: #b9b9b9;
        text-decoration: none;
        transition: color 0.2s ease-in-out;
    }

    .footer-links a:hover {
        color: #e50914;
    }

    .footer-contact {
        font-size: 0.95rem;
        margin-bottom: 8px;
    }

    .social-links {
        display: flex;
        gap: 12px;
    }

    .social-icon {
        width: 38px;
        height: 38px;
        border-radius: 50%;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        color: #f1f1f1;
        background: rgba(255, 255, 255, 0.08);
        text-decoration: none;
        transition: transform 0.2s ease, background 0.2s ease;
        font-size: 1.1rem;
    }

    .social-icon:hover {
        background: #e50914;
        transform: translateY(-2px);
    }

    .footer-bottom {
        border-top: 1px solid rgba(255, 255, 255, 0.1);
        padding: 16px 0 22px;
        text-align: center;
        font-size: 0.9rem;
    }
</style>
