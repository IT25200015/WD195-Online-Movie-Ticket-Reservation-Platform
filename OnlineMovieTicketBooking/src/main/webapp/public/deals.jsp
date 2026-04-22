<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Active Deals & Promotions - CineBooking</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/modern-promotions.css">
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="modern-ui">

    <div class="container py-5">
        <div class="text-center mb-5">
            <h1 class="display-4 fw-bold">Current Movie Deals</h1>
            <p class="lead text-muted">Apply these codes at checkout for amazing discounts!</p>
        </div>

        <div class="row g-4">
            <c:choose>
                <c:when test="${empty activePromotions}">
                    <div class="col-12 text-center py-5 glass-card">
                        <i class="fa-solid fa-ticket fa-3x text-muted mb-3"></i>
                        <h3>No Active Promotions Right Now</h3>
                        <p class="text-muted">Check back later for seasonal discounts and offers.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="promo" items="${activePromotions}">
                        <div class="col-md-6 col-lg-4">
                            <div class="glass-card h-100 p-4 d-flex flex-column">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <span class="promo-badge fs-5">${promo.promoCode}</span>
                                    <span class="badge bg-light text-dark border"><i class="fa-regular fa-clock me-1"></i> Valid till ${promo.endDate}</span>
                                </div>
                                <h3 class="fw-bold mb-2">
                                    <c:choose>
                                        <c:when test="${promo.promotionType == 'PERCENTAGE'}">
                                            ${promo.discountValue}% OFF
                                        </c:when>
                                        <c:when test="${promo.promotionType == 'FIXED'}">
                                            Rs ${promo.discountValue} OFF
                                        </c:when>
                                        <c:when test="${promo.promotionType == 'SEASONAL'}">
                                            ${promo.seasonName} Special: ${promo.discountValue}% OFF
                                        </c:when>
                                    </c:choose>
                                </h3>
                                <p class="text-muted flex-grow-1">
                                    Enjoy this exclusive discount on your next movie ticket booking.
                                    <c:if test="${promo.minimumAmount > 0}">
                                        <br><small><i class="fa-solid fa-circle-info text-info me-1"></i> Minimum booking amount: Rs ${promo.minimumAmount}</small>
                                    </c:if>
                                </p>
                                <div class="mt-3 text-center">
                                    <button class="btn btn-outline-primary w-100 rounded-pill copy-btn" data-code="${promo.promoCode}">
                                        <i class="fa-regular fa-copy me-2"></i> Copy Code
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
        
        <div class="mt-5 text-center">
            <a href="${pageContext.request.contextPath}/public/checkout-mock.jsp" class="btn btn-modern rounded-pill px-4 py-2">
                Simulate Checkout System <i class="fa-solid fa-arrow-right ms-2"></i>
            </a>
        </div>
    </div>

    <!-- Script for copy to clipboard -->
    <script>
        document.querySelectorAll('.copy-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                const code = this.getAttribute('data-code');
                navigator.clipboard.writeText(code).then(() => {
                    const originalHTML = this.innerHTML;
                    this.innerHTML = '<i class="fa-solid fa-check me-2"></i> Copied!';
                    this.classList.replace('btn-outline-primary', 'btn-success');
                    
                    setTimeout(() => {
                        this.innerHTML = originalHTML;
                        this.classList.replace('btn-success', 'btn-outline-primary');
                    }, 2000);
                });
            });
        });
    </script>
</body>
</html>
