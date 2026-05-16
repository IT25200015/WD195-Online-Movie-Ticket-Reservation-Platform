<%@ page import="com.cinebooking.models.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    // Security Check: Get the user from session
    User user = (User) session.getAttribute("user");

    // If no one is logged in, send them back to login page
    if (user == null) {
        response.sendRedirect("UserController?action=login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | CineBooking</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">

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

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--cinema-bg);
            color: var(--cinema-text);
            min-height: 100vh;
            display: flex;
            align-items: center;
        }

        .profile-card {
            background: var(--cinema-surface);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 16px 40px rgba(0, 0, 0, 0.45);
        }

        .brand-name {
            font-weight: 600;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: var(--cinema-text);
            margin-bottom: 20px;
        }

        .info-label {
            color: var(--cinema-muted);
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 2px;
        }

        .info-value {
            font-size: 1.05rem;
            font-weight: 400;
            margin-bottom: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            padding-bottom: 6px;
        }

        .btn-custom-edit {
            background: transparent;
            border: 1px solid rgba(255, 255, 255, 0.35);
            color: var(--cinema-text);
            transition: 0.3s;
        }

        .btn-custom-edit:hover {
            background: var(--cinema-surface-2);
            color: var(--cinema-text);
        }

        .btn-offers {
            background: var(--cinema-accent);
            border: none;
            color: #ffffff;
            transition: 0.3s;
            box-shadow: 0 10px 20px var(--cinema-glow);
        }

        .btn-offers:hover {
            filter: brightness(1.05);
            box-shadow: 0 14px 28px rgba(229, 9, 20, 0.45);
        }

        .btn-danger {
            background-color: #c00812;
            border: none;
        }

        .btn-danger:hover {
            filter: brightness(1.05);
        }

        .btn-logout {
            color: var(--cinema-accent);
            text-decoration: none;
            font-size: 0.9rem;
            transition: 0.3s;
        }

        .btn-logout:hover {
            color: #ff2a2a;
            text-decoration: underline;
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

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="profile-card text-center">
                <img
                    src="https://ui-avatars.com/api/?name=<%= java.net.URLEncoder.encode(user.getName(), "UTF-8") %>&background=e50914&color=fff&rounded=true&size=128"
                    alt="User avatar"
                    class="rounded-circle border border-2"
                    style="width: 100px; height: 100px; border-color: #e50914; box-shadow: 0 8px 18px rgba(0, 0, 0, 0.35);">
                <h2 class="brand-name">CINEBOOKING</h2>
                <h5 class="mb-4 text-secondary">MY PROFILE</h5>

                <div class="text-start mt-4">
                    <div class="info-label">Full Name</div>
                    <div class="info-value"><%= user.getName() %></div>

                    <div class="info-label">Email Address</div>
                    <div class="info-value"><%= user.getEmail() %></div>

                    <div class="info-label">Mobile Number</div>
                    <div class="info-value"><%= user.getMobileNumber() != null ? user.getMobileNumber() : "Not Provided" %></div>

                    <div class="info-label">Date of Birth</div>
                    <div class="info-value"><%= user.getDob() != null ? user.getDob() : "Not Provided" %></div>

                    <div class="info-label">Gender</div>
                    <div class="info-value"><%= user.getGender() != null ? user.getGender() : "Not Provided" %></div>

                    <div class="info-label">Account Role</div>
                    <div class="info-value">
                        <span class="badge bg-primary text-uppercase" style="font-size: 0.7rem;">
                            <%= user.getRole() %>
                        </span>
                    </div>


                    <% if (user instanceof com.cinebooking.models.Customer) {
                           com.cinebooking.models.Customer customer = (com.cinebooking.models.Customer) user;
                    %>
                        <div class="info-label">Membership Tier</div>
                        <div class="info-value">
                            <span class="badge bg-success text-uppercase" style="font-size: 0.7rem;">
                                <%= customer.getMembership() %>
                            </span>
                        </div>
                    <% } %>

                </div>

                <div class="mt-4">
                    <a href="promotions.jsp" class="btn btn-offers w-100 py-2 mb-3 fw-bold">
                        VIEW OFFERS & PROMOTIONS
                    </a>
                    <a href="UserController?action=editProfile" class="btn btn-custom-edit w-100 py-2 mb-3">
                        EDIT DETAILS
                    </a>
                    <!-- Delete profile action (POST) with confirmation -->
                    <form action="UserController" method="post" class="w-100 mb-3" onsubmit="return confirm('Are you sure you want to delete your profile? This cannot be undone.');">
                        <input type="hidden" name="action" value="deleteProfile">
                        <button type="submit" class="btn btn-danger w-100 py-2">DELETE PROFILE</button>
                    </form>
                    <a href="UserController?action=logout" class="btn-logout">
                        Logout
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
