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
        body {
            font-family: 'Poppins', sans-serif;
            background: #0f0c29;
            background: linear-gradient(to right, #24243e, #302b63, #0f0c29);
            color: white;
            min-height: 100vh;
        }

        .dashboard-container {
            margin-top: 40px;
            margin-bottom: 40px;
        }

        .brand-title {
            font-size: 2.5rem;
            font-weight: 600;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: #ffffff;
            margin-bottom: 5px;
        }

        .brand-subtitle {
            color: #bbb;
            font-size: 1.1rem;
            letter-spacing: 1px;
            margin-bottom: 40px;
        }

        .glass-card {
            background: rgba(255, 255, 255, 0.05); /* Semi-transparent background */
            backdrop-filter: blur(10px); /* Glass effect */
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.8);
        }

        .table {
            color: white;
            border-color: rgba(255, 255, 255, 0.1);
        }

        .table-hover tbody tr:hover {
            background-color: rgba(255, 255, 255, 0.1);
            color: white;
        }

        .table thead th {
            border-bottom: 2px solid rgba(255, 255, 255, 0.2);
            color: #bbb;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9rem;
            letter-spacing: 1px;
        }

        .table td {
            border-color: rgba(255, 255, 255, 0.1);
            vertical-align: middle;
        }

        .custom-btn-warning {
            background: transparent;
            border: 1px solid #ffc107;
            color: #ffc107;
            transition: 0.3s;
            padding: 5px 15px;
            font-size: 0.85rem;
            border-radius: 0;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .custom-btn-warning:hover {
            background: #ffc107;
            color: #000;
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

    <div class="glass-card">
        <h3 class="mb-4" style="font-weight: 300; letter-spacing: 1px;">ALL USERS</h3>

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
                    <span class="input-group-text bg-dark text-white border-0">
                        <i class="bi bi-search"></i>
                    </span>
                    <input
                        type="text"
                        class="form-control bg-dark text-white border-0"
                        name="searchQuery"
                        placeholder="Search by Name or Email..."
                        value="<%= searchQuery %>">
                </div>
            </div>
            <div class="col-md-4 d-flex gap-2">
                <button type="submit" class="btn btn-primary w-50">Search</button>
                <a href="UserController?action=adminDashboard" class="btn btn-outline-light w-50">Clear</a>
            </div>
        </form>

        <div class="table-responsive">
            <table class="table table-hover align-middle">
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
