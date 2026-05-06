<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - CineBooking</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

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
            background-color: var(--cinema-bg);
            color: var(--cinema-text);
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
            color: var(--cinema-muted);
            margin-bottom: 40px;
            letter-spacing: 1px;
        }

        .custom-input {
            background-color: var(--cinema-surface);
            border: 1px solid transparent;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
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

        .form-label {
            font-size: 0.85rem;
            margin-bottom: 6px;
            font-weight: 500;
            color: var(--cinema-muted);
        }

        .required-star {
            color: var(--cinema-accent);
        }

        .custom-btn {
            background-color: var(--cinema-accent);
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
