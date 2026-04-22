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
        body {
            font-family: 'Poppins', sans-serif;
            background: #0f0c29;
            background: linear-gradient(to right, #24243e, #302b63, #0f0c29);
            color: white;
            height: 100vh;
            display: flex;
            align-items: center;
            margin: 0;
        }

        .edit-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
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

        .form-control { background: rgba(255, 255, 255, 0.1); border: 1px solid rgba(255, 255, 255, 0.2); color: white; }
        .form-control:focus { background: rgba(255, 255, 255, 0.2); color: white; box-shadow: none; border: 1px solid white; }
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
