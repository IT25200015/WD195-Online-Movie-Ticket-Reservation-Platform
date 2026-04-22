<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cinebooking.models.User" %>
<%@ page import="com.cinebooking.models.Customer" %>
<%@ page import="com.cinebooking.models.Admin" %>

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
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Membership</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        // The UserController receives the request, sets "userList", and uses RequestDispatcher to forward the list here.
                        List<User> userList = (List<User>) request.getAttribute("userList");
                        if (userList != null && !userList.isEmpty()) {
                            // Iterate through the userList using a standard Java loop
                            for (User u : userList) {
                    %>
                                <tr>
                                    <td><%= u.getUserId() %></td>
                                    <td><%= u.getName() %></td>
                                    <td><%= u.getEmail() %></td>
                                    <td>
                                        <span class="badge <%= "Admin".equals(u.getRole()) ? "bg-danger" : "bg-primary" %>">
                                            <%= u.getRole() %>
                                        </span>
                                    </td>

                                    <%
                                        // The 'instanceof' keyword checks if 'u' is actually a Customer object
                                        if (u instanceof Customer) {
                                            // If true, we cast 'u' to a Customer so we can use getMembership()
                                            Customer c = (Customer) u;
                                    %>
                                            <td>
                                                <span class="badge <%= "Premium".equals(c.getMembership()) ? "bg-success" : "bg-secondary" %>">
                                                    <%= c.getMembership() %>
                                                </span>
                                            </td>
                                            <td>
                                                <% if ("Regular".equals(c.getMembership())) { %>
                                                    <!-- Inline form to make the customer premium -->
                                                    <form action="UserController?action=makePremium" method="POST" class="d-inline">
                                                        <input type="hidden" name="userId" value="<%= c.getUserId() %>">
                                                        <button type="submit" class="btn custom-btn-warning">Make Premium 🌟</button>
                                                    </form>
                                                <% } else { %>
                                                    <span class="text-success"><i class="bi bi-star-fill"></i> Premium Active</span>
                                                <% } %>
                                            </td>
                                    <%
                                        } else {
                                            // If the user is an Admin, they don't have a membership
                                    %>
                                            <td class="text-muted">N/A</td>
                                            <td><span class="text-muted">-</span></td>
                                    <%
                                        }
                                    %>
                                </tr>
                    <%
                            }
                        } else {
                    %>
                        <tr>
                            <td colspan="6" class="text-center">No users found.</td>
                        </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
