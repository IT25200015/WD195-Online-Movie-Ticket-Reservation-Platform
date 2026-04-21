<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - CineBooking</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #1c1a3b;
            color: #ffffff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
        }

        .brand-title {
            font-size: 2rem;
            font-weight: 700;
            letter-spacing: 2px;
            margin-bottom: 10px;
        }

        .brand-subtitle {
            font-size: 0.9rem;
            color: #8e8eb2;
            margin-bottom: 40px;
            letter-spacing: 1px;
        }

        .custom-input {
            background-color: transparent !important;
            border: none;
            border-bottom: 1px solid #6c6a8b;
            border-radius: 0;
            color: white !important;
            padding-left: 0;
            padding-bottom: 8px;
            box-shadow: none !important;
        }

        .custom-input:focus {
            border-bottom: 2px solid #ffffff;
            outline: none;
        }

        .form-label {
            font-size: 0.85rem;
            margin-bottom: 5px;
            font-weight: 500;
            color: #e0e0e0;
        }

        .required-star {
            color: #ff4d4d;
        }

        .custom-btn {
            background-color: transparent;
            color: white;
            border: 1px solid #ffffff;
            border-radius: 0;
            padding: 12px;
            font-weight: bold;
            letter-spacing: 1px;
            transition: 0.3s;
        }

        .custom-btn:hover {
            background-color: #ffffff;
            color: #1c1a3b;
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5 col-lg-4">

                <div class="text-center">
                    <div class="brand-title">CINEBOOKING</div>
                    <div class="brand-subtitle">WELCOME BACK</div>
                </div>

                <% if (request.getParameter("error") != null) { %>
                    <div class="alert alert-danger text-center">
                        Invalid Username or Password! Please try again.
                    </div>
                <% } %>

                <!-- Login form -->
                <form action="${pageContext.request.contextPath}/UserController" method="POST">
                    <input type="hidden" name="action" value="login">

                    <div class="mb-4 mt-4">
                        <label class="form-label" for="email">Email address <span class="required-star">*</span></label>
                        <input type="email" id="email" name="email" class="form-control custom-input" required>
                    </div>

                    <div class="mb-5">
                        <div class="d-flex justify-content-between">
                            <label class="form-label" for="password">Password <span class="required-star">*</span></label>
                            <a href="#" class="text-white-50 text-decoration-none" style="font-size: 0.8rem;">Forgot Password?</a>
                        </div>
                        <input type="password" id="password" name="password" class="form-control custom-input" required>
                    </div>

                    <button type="submit" class="btn custom-btn w-100 mb-4">LOGIN</button>

                    <div class="text-center">
                        <p class="text-white-50" style="font-size: 0.9rem;">
                            Don't have an account? <a href="${pageContext.request.contextPath}/UserController?action=register" class="text-white text-decoration-underline">Register here</a>
                        </p>
                    </div>
                </form>

            </div>
        </div>
    </div>

</body>
</html>
