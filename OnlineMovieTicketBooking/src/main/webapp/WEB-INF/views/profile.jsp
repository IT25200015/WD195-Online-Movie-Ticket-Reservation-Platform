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
        body {
            font-family: 'Poppins', sans-serif;
            background: #0f0c29; /* Dark background similar to your image */
            background: linear-gradient(to right, #24243e, #302b63, #0f0c29);
            color: white;
            height: 100vh;
            display: flex;
            align-items: center;
        }

        .profile-card {
            background: rgba(255, 255, 255, 0.05); /* Semi-transparent background */
            backdrop-filter: blur(10px); /* Glass effect */
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.8);
        }

        .brand-name {
            font-weight: 600;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: #ffffff;
            margin-bottom: 20px;
        }

        .info-label {
            color: #bbb;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 2px;
        }

        .info-value {
            font-size: 1.1rem;
            font-weight: 400;
            margin-bottom: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            padding-bottom: 5px;
        }

        .btn-custom-edit {
            background: transparent;
            border: 1px solid white;
            color: white;
            transition: 0.3s;
        }

        .btn-custom-edit:hover {
            background: white;
            color: black;
        }

        .btn-offers {
            background: #ff416c;
            background: linear-gradient(to right, #ff4b2b, #ff416c);
            border: none;
            color: white;
            transition: 0.3s;
        }

        .btn-offers:hover {
            background: linear-gradient(to right, #ff416c, #ff4b2b);
            color: white;
            box-shadow: 0 4px 15px rgba(255, 65, 108, 0.4);
        }

        .btn-logout {
            color: #ff4b2b;
            text-decoration: none;
            font-size: 0.9rem;
            transition: 0.3s;
        }

        .btn-logout:hover {
            color: #ff416c;
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="profile-card text-center">
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
