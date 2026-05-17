<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Active Deals & Promotions | CineBooking</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/modern-promotions.css">
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Global Focus/Autofill Styling -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body class="modern-ui">

    <!-- Premium Hero Section -->
    <header class="hero-section">
        <div class="container position-relative z-1 text-center">
            <span class="badge bg-dark text-light rounded-pill px-3 py-2 mb-3 fw-bold fade-in" style="font-size: 0.9rem;">
                <i class="fa-solid fa-sparkles me-2"></i>LIMITED TIME OFFERS
            </span>
            <h1 class="display-3 fw-bold mb-3 fade-in" style="letter-spacing: -2px;">Unlock Premium Movie Experiences</h1>
            <p class="lead opacity-75 mb-4 fade-in" style="max-width: 600px; margin: 0 auto;">
                Apply these exclusive codes at checkout and enjoy the magic of cinema for less.
            </p>
        </div>
        <div class="hero-shape"></div>
    </header>

    <div class="container py-4">
        <div class="row g-4 justify-content-center">
            <c:choose>
                <c:when test="${empty activePromotions}">
                        <div class="col-md-8 text-center py-5 glass-card fade-in">
                        <div class="mb-4">
                            <i class="fa-solid fa-ticket-simple fa-4x text-muted opacity-25"></i>
                        </div>
                        <h3 class="fw-bold">No Active Promotions</h3>
                        <p class="text-muted">We're preparing something special. Check back later for upcoming seasonal deals and blockbuster offers!</p>
                            <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary-action rounded-pill mt-3">Back to Home</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="promo" items="${activePromotions}" varStatus="status">
                        <div class="col-md-6 col-lg-4 fade-in" style="animation-delay: ${status.index * 0.1}s">
                            <div class="glass-card d-flex flex-column p-4">
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <div class="promo-badge">${promo.promoCode}</div>
                                    <div class="text-muted small">
                                        <%
                                            com.cinebooking.models.Promotion p = (com.cinebooking.models.Promotion)pageContext.getAttribute("promo");
                                            java.time.LocalDate today = java.time.LocalDate.now();
                                            if (today.isBefore(p.getStartDate())) {
                                        %>
                                            <span class="badge bg-warning text-dark border"><i class="fa-solid fa-hourglass-start me-1"></i> Coming Soon: ${promo.startDate}</span>
                                        <% } else { %>
                                            <i class="fa-regular fa-clock me-1"></i> Ends ${promo.endDate}
                                        <% } %>
                                    </div>
                                </div>
                                
                                <div class="mb-4">
                                    <h2 class="fw-bold text-white mb-2">
                                        <c:choose>
                                            <c:when test="${promo.promotionType == 'PERCENTAGE'}">
                                                Flat ${promo.discountValue}% OFF
                                            </c:when>
                                            <c:when test="${promo.promotionType == 'FIXED'}">
                                                Rs ${promo.discountValue} OFF
                                            </c:when>
                                            <c:when test="${promo.promotionType == 'SEASONAL'}">
                                                ${promo.seasonName} Special: ${promo.discountValue}% OFF
                                            </c:when>
                                        </c:choose>
                                    </h2>
                                    <p class="text-muted">
                                        Valid on all movies currently screening at CineBooking. 
                                        <c:if test="${promo.minimumAmount > 0}">
                                            <span class="d-block mt-2 small fw-bold text-primary">
                                                <i class="fa-solid fa-circle-info me-1"></i> Min. booking: Rs ${promo.minimumAmount}
                                            </span>
                                        </c:if>
                                    </p>
                                </div>

                                <div class="mt-auto pt-3 border-top d-flex gap-2">
                                    <button class="btn btn-primary-action flex-grow-1 rounded-pill copy-btn" data-code="${promo.promoCode}">
                                        <i class="fa-regular fa-copy me-2"></i>Copy Code
                                    </button>
                                    <a href="${pageContext.request.contextPath}/public/checkout-mock.jsp" class="btn btn-primary-action rounded-circle" style="width: 45px; height: 45px; display: flex; align-items: center; justify-content: center;">
                                        <i class="fa-solid fa-arrow-right"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
        
        <div class="mt-5 pt-5 text-center fade-in">
            <p class="text-muted small mb-3">Questions about our promotions?</p>
            <div class="d-flex justify-content-center gap-3">
                <a href="#" class="text-decoration-none text-primary fw-bold small">Terms & Conditions</a>
                <span class="text-muted">•</span>
                <a href="#" class="text-decoration-none text-primary fw-bold small">Support Center</a>
            </div>
        </div>
    </div>

    <!-- Script for copy to clipboard -->
    <script>
        document.querySelectorAll('.copy-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                const code = this.getAttribute('data-code');
                navigator.clipboard.writeText(code).then(() => {
                    const originalHTML = this.innerHTML;
                    this.innerHTML = '<i class="fa-solid fa-check me-2"></i>Copied!';
                    this.classList.replace('btn-primary-action', 'btn-secondary-action');

                    setTimeout(() => {
                        this.innerHTML = originalHTML;
                        this.classList.replace('btn-secondary-action', 'btn-primary-action');
                    }, 2000);
                });
            });
        });
    </script>
</body>
</html>
