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

        .brand-cine {
            color: #ffffff !important;
            font-weight: 700 !important;
            text-transform: uppercase !important;
            letter-spacing: 1px !important;
            text-shadow: -1px 0 2px rgba(0, 255, 255, 0.6) !important; /* Left-side cyan shadow */
        }
        .brand-booking {
            color: #e50914 !important;
            font-weight: 700 !important;
            text-transform: uppercase !important;
            letter-spacing: 1px !important;
            text-shadow: -1px 0 2px rgba(0, 255, 255, 0.4) !important; /* Left-side cyan shadow */
        }

        /* === Premium Request Button === */
        .btn-request-premium {
            background: linear-gradient(135deg, #f5a623, #f7c948);
            border: none;
            color: #1a1a1a;
            font-weight: 700;
            letter-spacing: 0.8px;
            text-transform: uppercase;
            font-size: 0.82rem;
            border-radius: 8px;
            padding: 8px 14px;
            transition: filter 0.2s, box-shadow 0.2s;
            box-shadow: 0 4px 14px rgba(245, 166, 35, 0.35);
            cursor: pointer;
        }
        .btn-request-premium:hover {
            filter: brightness(1.08);
            box-shadow: 0 6px 18px rgba(245, 166, 35, 0.5);
        }
        .btn-request-premium:disabled,
        .btn-request-premium[disabled] {
            background: #444444;
            color: #888888;
            box-shadow: none;
            cursor: not-allowed;
            filter: none;
        }
        .premium-pending-badge {
            display: inline-block;
            font-size: 0.7rem;
            font-weight: 600;
            background: rgba(255, 193, 7, 0.15);
            color: #ffc107;
            border: 1px solid rgba(255, 193, 7, 0.4);
            border-radius: 20px;
            padding: 2px 10px;
            margin-left: 6px;
            vertical-align: middle;
            letter-spacing: 0.5px;
        }
        .alert-cinema {
            border-radius: 10px;
            font-size: 0.88rem;
            border: none;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="profile-card text-center position-relative">
                <a href="home" class="text-white text-decoration-none position-absolute top-0 start-0 mt-3 ms-3">&larr; Back to Home</a>
                <div class="text-center">
                    <img
                        src="https://ui-avatars.com/api/?name=<%= java.net.URLEncoder.encode(user.getName(), "UTF-8") %>&background=e50914&color=fff&rounded=true&size=128"
                        alt="User avatar"
                        class="rounded-circle border border-2"
                        style="width: 100px; height: 100px; border-color: #e50914; box-shadow: 0 8px 18px rgba(0, 0, 0, 0.35);">
                    <h2 class="brand-name"><span class="brand-cine">CINE</span><span class="brand-booking">BOOKING</span></h2>
                    <h5 class="mb-4 text-secondary">MY PROFILE</h5>
                </div>

                <%-- ============================================================
                     Premium Request Feedback Banners
                     ============================================================ --%>
                <%
                    String premiumMsg = request.getParameter("premiumMsg");
                    if (premiumMsg != null) {
                        if ("requested".equals(premiumMsg)) {
                %>
                <div class="alert alert-warning alert-dismissible fade show alert-cinema" role="alert">
                    <strong>&#11088; Request Submitted!</strong> Your premium upgrade request has been sent. The admin will review it shortly.
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <%      } else if ("alreadyPending".equals(premiumMsg)) { %>
                <div class="alert alert-info alert-dismissible fade show alert-cinema" role="alert">
                    <strong>&#9432; Already Pending.</strong> You already have an active request. Please wait for the admin to review it.
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <%      } else if ("alreadyPremium".equals(premiumMsg)) { %>
                <div class="alert alert-success alert-dismissible fade show alert-cinema" role="alert">
                    <strong>&#10003; You're Premium!</strong> You already have a Premium membership.
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <%      } else if ("error".equals(premiumMsg)) { %>
                <div class="alert alert-danger alert-dismissible fade show alert-cinema" role="alert">
                    <strong>&#9888; Error.</strong> Something went wrong. Please try again later.
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <%      }
                    }
                %>

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
                        <div class="info-value d-flex align-items-center justify-content-between flex-wrap gap-2">
                            <span>
                                <span class="badge bg-success text-uppercase" style="font-size: 0.7rem;">
                                    <%= customer.getMembership() %>
                                </span>
                                <% if ("Pending".equalsIgnoreCase(customer.getPremiumRequest())) { %>
                                    <span class="premium-pending-badge">&#9679; Upgrade Requested</span>
                                <% } %>
                            </span>

                            <%-- Only show the upgrade button for Regular members --%>
                            <% if (!"Premium".equalsIgnoreCase(customer.getMembership())) { %>
                                <% boolean isPending = "Pending".equalsIgnoreCase(customer.getPremiumRequest()); %>
                                <form action="UserController" method="post" style="margin:0;">
                                    <input type="hidden" name="action" value="requestPremium">
                                    <button type="submit"
                                            id="btn-request-premium"
                                            class="btn-request-premium"
                                            <%= isPending ? "disabled title='Your request is under review'" : "" %>>
                                        <%= isPending ? "&#10003; Request Sent" : "&#11088; Request Premium" %>
                                    </button>
                                </form>
                            <% } %>
                        </div>
                    <% } %>

                </div>

                <div class="mt-4">
                    <% if (user.getRole() != null && user.getRole().equalsIgnoreCase("Admin")) { %>
                        <a href="UserController?action=adminDashboard" class="btn btn-offers w-100 py-2 mb-3 fw-bold">
                            ADMIN DASHBOARD
                        </a>
                    <% } else { %>
                        <a href="booking?action=myBookings&page=history" class="btn btn-offers w-100 py-2 mb-3 fw-bold">
                            MY BOOKING HISTORY
                        </a>
                    <% } %>
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
