<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cinebooking.models.User" %>
<%@ page import="com.cinebooking.models.Customer" %>
<%@ page import="com.cinebooking.models.Admin" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // Security Check: Only allow access if the session user is not null and their role is "Admin"
    User sessionUser = (User) session.getAttribute("user");
    if (sessionUser == null || !"Admin".equals(sessionUser.getRole())) {
        response.sendRedirect("UserController?action=login");
        return; // Stop the rest of the page from loading
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        :root {
            --cinema-bg: #121212;
            --cinema-surface: #1a1a1a;
            --cinema-surface-2: #222222;
            --cinema-accent: #e50914;
            --cinema-text: #f5f5f5;
            --cinema-muted: #b9b9b9;
            --cinema-glow: rgba(229, 9, 20, 0.35);
            --cinema-border: #333333;
            --cinema-row-hover: #2a2a2a;
        }

        html,
        body {
            background-color: #121212 !important;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: #121212 !important;
            color: var(--cinema-text);
            min-height: 100vh;
        }

        .container,
        .container-fluid,
        .dashboard-container {
            background-color: #121212 !important;
        }

        .dashboard-container {
            background-color: #121212;
            margin-top: 48px;
            margin-bottom: 60px;
        }

        .brand-title {
            font-size: 2.4rem;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: #ffffff;
            margin-bottom: 8px;
        }

        .brand-subtitle {
            color: var(--cinema-muted);
            font-size: 1rem;
            letter-spacing: 1px;
            margin-bottom: 34px;
        }

        .dashboard-card {
            background: #1a1a1a;
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 18px;
            padding: 32px;
            box-shadow: 0 16px 40px rgba(0, 0, 0, 0.45);
        }

        .section-title {
            font-weight: 600;
            letter-spacing: 1px;
            color: #ffffff;
        }

        .custom-input {
            background-color: var(--cinema-surface-2);
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 10px;
            color: var(--cinema-text) !important;
            padding: 12px 14px;
            box-shadow: none !important;
        }

        .custom-input::placeholder {
            color: rgba(255, 255, 255, 0.45);
        }

        .custom-input:focus {
            border-color: var(--cinema-accent);
            box-shadow: 0 0 0 3px rgba(229, 9, 20, 0.2);
            outline: none;
        }

        .input-group-text.cinema-addon {
            background-color: var(--cinema-surface-2);
            border: 1px solid rgba(255, 255, 255, 0.12);
            color: var(--cinema-muted);
        }

        .custom-btn {
            background-color: #e50914;
            color: #ffffff;
            border: none;
            border-radius: 999px;
            padding: 12px;
            font-weight: 700;
            letter-spacing: 1px;
            transition: transform 0.3s ease, box-shadow 0.3s ease, filter 0.3s ease;
        }

        .custom-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 12px 24px var(--cinema-glow);
            filter: brightness(1.05);
        }

        .ghost-btn {
            background: #333333;
            border: none;
            color: #ffffff;
            border-radius: 999px;
            padding: 12px;
            font-size: 0.85rem;
            letter-spacing: 0.8px;
            text-transform: uppercase;
            transition: 0.3s ease;
        }

        .ghost-btn:hover {
            filter: brightness(1.08);
        }

        .ghost-btn.danger {
            background-color: #dc3545;
            color: #ffffff;
        }

        .ghost-btn.danger:hover {
            filter: brightness(1.05);
        }

        .ghost-btn.success {
            background-color: #198754;
            color: #ffffff;
        }

        .ghost-btn.success:hover {
            filter: brightness(1.05);
        }

        .ghost-btn.warn {
            background-color: #ffc107;
            color: #1a1a1a;
        }

        .ghost-btn.warn:hover {
            filter: brightness(1.05);
        }

        .cinema-table {
            background-color: #1e1e1e;
            color: #e5e5e5;
            border-radius: 14px;
            overflow: hidden;
        }

        .cinema-table thead th {
            background-color: #2b2b2b;
            color: #e5e5e5;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 1px;
            border-bottom: 1px solid #333333;
        }

        .cinema-table tbody td {
            background-color: #1e1e1e;
            color: #e5e5e5;
            border-bottom: 1px solid #333333;
            vertical-align: middle;
        }

        .cinema-table tbody tr {
            background-color: #1e1e1e;
        }

        .cinema-table tbody tr:hover {
            background-color: #2a2a2a;
        }

        .badge.bg-primary {
            background-color: #2d2d2d !important;
        }

        .badge.bg-success {
            background-color: var(--cinema-accent) !important;
        }
    </style>
</head>
<body>

<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<div class="container dashboard-container">
    <div class="row mb-4">
        <div class="col text-center">
            <h1 class="brand-title">Admin Dashboard</h1>
            <p class="brand-subtitle">Manage user accounts and upgrade customer memberships.</p>
        </div>
    </div>

    <div class="dashboard-card">
        <h3 class="mb-4 section-title">ALL USERS</h3>

        <%
            String searchQuery = request.getParameter("searchQuery");
            if (searchQuery == null) {
                searchQuery = "";
            }
        %>
        <form class="row g-2 align-items-center mb-4" method="GET" action="UserController">
            <input type="hidden" name="action" value="adminDashboard">
            <div class="col-md-8">
                <div class="input-group">
                    <span class="input-group-text cinema-addon">
                        <i class="bi bi-search"></i>
                    </span>
                    <input
                        type="text"
                        class="form-control custom-input"
                        name="searchQuery"
                        placeholder="Search by Name or Email..."
                        value="<%= searchQuery %>">
                </div>
            </div>
            <div class="col-md-4 d-flex gap-2">
                <!-- Search Button -->
                <button type="submit" class="btn" style="background-color: #e50914 !important; color: #ffffff !important; border: none !important; padding: 10px 20px !important; border-radius: 4px !important; font-weight: bold !important; margin-right: 10px !important; cursor: pointer;">
                    Search
                </button>

                <!-- Clear Button -->
                <button type="button" onclick="window.location.href='UserController?action=adminDashboard'" class="btn" style="background-color: #333333 !important; color: #ffffff !important; border: none !important; padding: 10px 20px !important; border-radius: 4px !important; font-weight: bold !important; cursor: pointer;">
                    CLEAR
                </button>
            </div>
        </form>

        <div class="table-responsive">
            <table class="table align-middle cinema-table">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Membership</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${not empty userList}">
                        <c:forEach var="user" items="${userList}">
                            <tr>
                                <td>${user.name}</td>
                                <td>${user.email}</td>
                                <td>
                                    <span class="badge ${user.role == 'Admin' ? 'bg-danger' : 'bg-primary'}">
                                        ${user.role}
                                    </span>
                                </td>
                                <td>
                                    <c:if test="${user.role == 'Admin'}">
                                        <span class="text-muted">N/A</span>
                                    </c:if>
                                    <c:if test="${user.role == 'Customer'}">
                                        <span class="badge ${user.membership == 'Premium' ? 'bg-success' : 'bg-secondary'}">
                                            ${user.membership}
                                        </span>
                                    </c:if>
                                </td>
                                <td>
                                    <c:if test="${user.role == 'Admin'}">
                                        <span class="text-muted">N/A</span>
                                    </c:if>
                                    <c:if test="${user.role == 'Customer'}">
                                        <a href="UserController?action=deleteUserByAdmin&email=${user.email}"
                                           class="btn btn-danger btn-sm"
                                           onclick="return confirm('Are you sure you want to delete this user?');">Delete</a>
                                        <c:if test="${user.role == 'Customer' and user.membership == 'Regular'}">
                                            <a href="UserController?action=toggleMembership&email=${user.email}&status=Premium"
                                               class="btn btn-success btn-sm ms-2">Make Premium</a>
                                        </c:if>
                                        <c:if test="${user.role == 'Customer' and user.membership == 'Premium'}">
                                            <a href="UserController?action=toggleMembership&email=${user.email}&status=Regular"
                                               class="btn btn-warning btn-sm ms-2">Remove Premium</a>
                                        </c:if>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:if>
                    <c:if test="${empty userList}">
                        <tr>
                            <td colspan="5" class="text-center">No users found.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
