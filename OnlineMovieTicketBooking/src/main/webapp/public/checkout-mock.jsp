<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Summary - Component 03 Mock</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/modern-promotions.css">
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="modern-ui bg-light">

    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <!-- Mock Component 03 Panel -->
                <div class="glass-card p-4 p-md-5">
                    <div class="mb-4 text-center">
                        <i class="fa-solid fa-film fa-3x text-primary mb-3"></i>
                        <h2 class="fw-bold">Booking Summary</h2>
                        <p class="text-muted">Review your tickets before payment</p>
                    </div>

                    <div class="border rounded-3 p-3 mb-4 bg-white">
                        <div class="d-flex justify-content-between mb-2">
                            <span>Movie Ticket (x2)</span>
                            <span class="fw-semibold">Rs 1200.00</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Convenience Fee</span>
                            <span class="fw-semibold">Rs 150.00</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2 text-success" id="discountRow" style="display: none !important;">
                            <span>Promo Discount <span id="appliedPromoBadge" class="badge bg-success ms-2"></span></span>
                            <span class="fw-bold">- Rs <span id="discountAmount">0.00</span></span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between">
                            <span class="fw-bold fs-5">Total to Pay</span>
                            <span class="fw-bold fs-5 text-primary">Rs <span id="finalTotal">1350.00</span></span>
                        </div>
                    </div>

                    <!-- Promo Code Validation Widget (Our Component) -->
                    <div class="widget-container w-100 bg-white p-4 rounded-4 shadow-sm border mb-4">
                        <h5 class="fw-bold mb-3"><i class="fa-solid fa-tag text-warning me-2"></i>Have a Promo Code?</h5>
                        <form id="promoForm" onsubmit="applyPromo(event)">
                            <div class="promo-input-group">
                                <input type="text" class="form-control form-control-lg bg-light" id="promoCode" placeholder="Enter code here" required>
                                <button type="submit" class="btn btn-dark fw-bold px-4">Apply</button>
                            </div>
                        </form>
                        <div id="promoFeedback" class="mt-2 small fw-semibold" style="display: none;"></div>
                    </div>

                    <button class="btn btn-primary w-100 btn-lg rounded-pill fw-bold shadow-sm">
                        Proceed to Payment <i class="fa-solid fa-lock ms-2"></i>
                    </button>
                    
                    <div class="text-center mt-4">
                        <a href="${pageContext.request.contextPath}/deals" class="text-decoration-none small"><i class="fa-solid fa-arrow-left me-1"></i> Back to live deals</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- AJAX Validation Script -->
    <script>
        const originalTotal = 1350.00; // Mocked amount

        function applyPromo(e) {
            e.preventDefault();
            const code = document.getElementById('promoCode').value.trim();
            const feedbackEl = document.getElementById('promoFeedback');
            const submitBtn = e.target.querySelector('button');
            
            if(!code) return;

            // Loading state
            submitBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i>';
            submitBtn.disabled = true;

            const formData = new URLSearchParams();
            formData.append('promoCode', code);
            formData.append('bookingAmount', originalTotal);

            fetch('${pageContext.request.contextPath}/api/validate-promo', {
                method: 'POST',
                body: formData,
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                }
            })
            .then(response => response.json())
            .then(data => {
                feedbackEl.style.display = 'block';
                if(data.success) {
                    feedbackEl.className = 'mt-2 small fw-semibold text-success';
                    feedbackEl.innerHTML = '<i class="fa-solid fa-circle-check me-1"></i> ' + data.message;
                    
                    // Update UI Total
                    document.getElementById('discountRow').style.setProperty('display', 'flex', 'important');
                    document.getElementById('appliedPromoBadge').innerText = code;
                    document.getElementById('discountAmount').innerText = data.discount.toFixed(2);
                    document.getElementById('finalTotal').innerText = data.newTotal.toFixed(2);
                    
                } else {
                    feedbackEl.className = 'mt-2 small fw-semibold text-danger';
                    feedbackEl.innerHTML = '<i class="fa-solid fa-circle-xmark me-1"></i> ' + data.message;
                    
                    // Reset UI
                    document.getElementById('discountRow').style.setProperty('display', 'none', 'important');
                    document.getElementById('finalTotal').innerText = originalTotal.toFixed(2);
                }
            })
            .catch(error => {
                feedbackEl.style.display = 'block';
                feedbackEl.className = 'mt-2 small fw-semibold text-danger';
                feedbackEl.innerHTML = '<i class="fa-solid fa-triangle-exclamation me-1"></i> Error applying code.';
                console.error(error);
            })
            .finally(() => {
                submitBtn.innerHTML = 'Apply';
                submitBtn.disabled = false;
            });
        }
    </script>
</body>
</html>
