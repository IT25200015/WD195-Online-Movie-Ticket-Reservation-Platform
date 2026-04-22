<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Promotion Analytics - CineBooking</title>
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

    <!-- Top Navbar Placeholder -->
    <nav class="navbar navbar-expand-lg navbar-dark border-bottom" style="background: var(--text-main)">
        <div class="container-fluid px-4">
            <a class="navbar-brand fw-bold" href="#"><i class="fa-solid fa-film text-warning me-2"></i>CineBooking Admin</a>
            <div class="d-flex text-white opacity-75">
                Promotion Analytics Dashboard
            </div>
        </div>
    </nav>

    <div class="container py-5">
        
        <div class="d-flex justify-content-between align-items-center mb-5 pb-3 border-bottom">
            <div>
                <a href="${pageContext.request.contextPath}/admin/promotions" class="btn btn-sm btn-outline-secondary mb-2 rounded-pill">
                    <i class="fa-solid fa-arrow-left me-1"></i> Back to Management
                </a>
                <h2 class="fw-bold m-0"><i class="fa-solid fa-chart-pie text-primary me-2"></i>Performance Overview</h2>
                <p class="text-muted mb-0">High-level insights into your discount campaigns</p>
            </div>
        </div>

        <div class="row g-4">
            <!-- Stat Card 1 -->
            <div class="col-md-6 col-lg-4">
                <div class="glass-card p-4 d-flex align-items-center h-100">
                    <div class="dashboard-stat-icon me-4">
                        <i class="fa-solid fa-tags"></i>
                    </div>
                    <div>
                        <p class="text-muted text-uppercase fw-bold mb-1 small">Total Campaigns Created</p>
                        <h2 class="display-5 fw-bold m-0 text-dark">${totalCodes != null ? totalCodes : 0}</h2>
                    </div>
                </div>
            </div>

            <!-- Stat Card 2 -->
            <div class="col-md-6 col-lg-4">
                <div class="glass-card p-4 d-flex align-items-center h-100">
                    <div class="dashboard-stat-icon me-4" style="background: rgba(16, 185, 129, 0.1); color: var(--accent-success);">
                        <i class="fa-solid fa-ticket-simple"></i>
                    </div>
                    <div>
                        <p class="text-muted text-uppercase fw-bold mb-1 small">Total Redemptions</p>
                        <h2 class="display-5 fw-bold m-0 text-dark">${totalRedemptions != null ? totalRedemptions : 0}</h2>
                    </div>
                </div>
            </div>
            
             <!-- Stat Card 3 -->
            <div class="col-md-12 col-lg-4">
                <div class="glass-card p-4 d-flex align-items-center h-100" style="background: linear-gradient(135deg, var(--primary-color), var(--secondary-color)); color: white;">
                    <div class="dashboard-stat-icon bg-white text-primary me-4">
                        <i class="fa-solid fa-crown"></i>
                    </div>
                    <div>
                        <p class="text-white opacity-75 text-uppercase fw-bold mb-1 small">Estimated Platform Savings Granted</p>
                        <h2 class="fw-bold m-0 text-white">Metrics Live Tracking</h2>
                        <small class="opacity-75">Connect ledger for exact $</small>
                    </div>
                </div>
            </div>
        </div>
        
    </div>

</body>
</html>
