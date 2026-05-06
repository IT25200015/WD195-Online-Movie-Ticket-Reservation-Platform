<%@ page import="com.cinebooking.models.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
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
    <title>Edit Profile | CineBooking</title>
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
            margin: 0;
        }

        .edit-card {
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

        .text-secondary {
            color: var(--cinema-muted) !important;
        }

        .form-control {
            background: var(--cinema-surface-2);
            border: 1px solid rgba(255, 255, 255, 0.12);
            color: var(--cinema-text);
        }

        .form-control:focus {
            background: var(--cinema-surface-2);
            color: var(--cinema-text);
            box-shadow: 0 0 0 3px rgba(229, 9, 20, 0.2);
            border: 1px solid var(--cinema-accent);
        }

        .btn-outline-light {
            background-color: var(--cinema-accent);
            border: none;
            color: #ffffff;
            font-weight: 600;
            box-shadow: 0 10px 20px var(--cinema-glow);
        }

        .btn-outline-light:hover {
            filter: brightness(1.05);
            box-shadow: 0 14px 28px rgba(229, 9, 20, 0.45);
        }

        a.text-secondary {
            color: var(--cinema-muted) !important;
        }

        a.text-secondary:hover {
            color: var(--cinema-text) !important;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="edit-card text-center">
                <h2 class="brand-name">CINEBOOKING</h2>
                <h5 class="mb-4 text-secondary">EDIT PROFILE</h5>
                <form action="UserController" method="POST" class="text-start">
                    <input type="hidden" name="action" value="update">

                    <div class="mb-3">
                        <label class="form-label small text-secondary">Full Name</label>
                        <input type="text" name="name" class="form-control" value="<%= user.getName() %>" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small text-secondary">Email Address</label>
                        <input type="email" name="email" class="form-control" value="<%= user.getEmail() %>" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small text-secondary">Mobile Number</label>
                        <input type="text" name="mobileNumber" class="form-control" value="<%= user.getMobileNumber() != null ? user.getMobileNumber() : "" %>" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small text-secondary">Date of Birth</label>
                        <input type="date" name="dob" class="form-control" value="<%= user.getDob() != null ? user.getDob() : "" %>" style="color-scheme: dark;" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small text-secondary">Gender</label>
                        <div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="gender" id="genderMale" value="Male" <%= "Male".equals(user.getGender()) ? "checked" : "" %> required>
                                <label class="form-check-label text-white" for="genderMale">Male</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="gender" id="genderFemale" value="Female" <%= "Female".equals(user.getGender()) ? "checked" : "" %> required>
                                <label class="form-check-label text-white" for="genderFemale">Female</label>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small text-secondary">New Password (Leave blank to keep current)</label>
                        <input type="password" name="password" class="form-control">
                    </div>

                    <button type="submit" class="btn btn-outline-light w-100 mt-4 py-2">UPDATE DETAILS</button>
                    <div class="text-center mt-3">
                        <a href="UserController?action=profile" class="text-secondary text-decoration-none" style="font-size: 0.9rem; transition: 0.3s;">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
