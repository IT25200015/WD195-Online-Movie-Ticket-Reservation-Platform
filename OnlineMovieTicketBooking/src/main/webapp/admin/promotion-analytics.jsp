<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Promotion Analytics - CineBooking</title>
    <jsp:include page="/includes/header.jsp" />
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/modern-promotions.css">
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Global Focus/autofill CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <style>
        body,
        .modern-ui {
            background-color: #121212;
            color: #f5f5f5;
        }

        .container {
            background-color: transparent;
        }

        .glass-card {
            background-color: #1a1a1a;
            color: #f5f5f5;
            border: 1px solid #2a2a2a;
        }

        .text-muted {
            color: #b9b9b9 !important;
        }
    </style>
</head>
    <jsp:include page="/includes/navbar.jsp" />
        </div>
    </nav>

    <div class="container py-5">

        <div class="d-flex justify-content-between align-items-center mb-5 pb-3 border-bottom">
            <div>
                <a href="${pageContext.request.contextPath}/admin/promotions" class="btn btn-sm btn-secondary-action mb-2 rounded-pill">
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
                        <h2 class="display-5 fw-bold m-0 text-white">${totalCodes != null ? totalCodes : 0}</h2>
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
                        <h2 class="display-5 fw-bold m-0 text-white">${totalRedemptions != null ? totalRedemptions : 0}</h2>
                    </div>
                </div>
            </div>

             <!-- Stat Card 3 -->
            <div class="col-md-12 col-lg-4">
                <div class="glass-card p-4 d-flex align-items-center h-100" style="background: #2b2b2b; color: white;">
                    <div class="dashboard-stat-icon text-primary me-4">
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
