<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create an Account - CineBooking</title>

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
            margin-bottom: 30px;
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
            <div class="col-md-6 col-lg-5">

                <div class="brand-title text-center">CINEBOOKING</div>

                <form action="${pageContext.request.contextPath}/UserController" method="POST">

                    <input type="hidden" name="action" value="register">

                    <!-- Show duplicate-email error from the controller -->
                    <c:if test="${not empty errorMessage}">
                        <div class="mb-3 text-danger">${errorMessage}</div>
                    </c:if>

                    <!-- Show simple validation error from the controller -->
                    <c:if test="${not empty error}">
                        <div class="mb-3 text-danger">${error}</div>
                    </c:if>

                    <div class="mb-4">
                        <label class="form-label">Full name <span class="required-star">*</span></label>
                        <input type="text" name="name" class="form-control custom-input" required>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Email address <span class="required-star">*</span></label>
                        <input type="email" name="email" class="form-control custom-input" required>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Mobile Number <span class="required-star">*</span></label>
                        <input type="tel" name="mobileNumber" class="form-control custom-input" pattern="[0-9]{10}" title="Enter exactly 10 digits" style="background-color: #1e1e1e; color: #f5f5f5;" required>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Date of Birth <span class="required-star">*</span></label>
                        <input type="date" name="dob" class="form-control custom-input" style="color-scheme: dark;" required>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Gender <span class="required-star">*</span></label>
                        <div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="gender" id="genderMale" value="Male" required>
                                <label class="form-check-label text-white" for="genderMale">Male</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="gender" id="genderFemale" value="Female" required>
                                <label class="form-check-label text-white" for="genderFemale">Female</label>
                            </div>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Create a Password <span class="required-star">*</span></label>
                        <input type="password" name="password" class="form-control custom-input" pattern="(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*]).{7,}" title="Password must be at least 7 characters long, containing uppercase, lowercase, numbers, and symbols." required>
                    </div>

                    <div class="mb-5">
                        <label class="form-label">Confirm password <span class="required-star">*</span></label>
                        <input type="password" name="confirmPassword" class="form-control custom-input" pattern="(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*]).{7,}" title="Password must be at least 7 characters long, containing uppercase, lowercase, numbers, and symbols." required>
                    </div>

                    <div class="form-check mb-4">
                        <input class="form-check-input" type="checkbox" required id="termsCheck">
                        <label class="form-check-label text-white-50" style="font-size: 0.85rem;" for="termsCheck">
                            I confirm that I have read the Privacy Policy and agree to the Terms of Use.
                        </label>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Admin Key (Leave blank if normal user)</label>
                        <input type="password" name="adminKey" class="form-control custom-input">
                    </div>

                    <button type="submit" class="btn custom-btn w-100 mb-4">CREATE AN ACCOUNT</button>

                    <div class="text-center">
                        <p class="text-white-50" style="font-size: 0.9rem;">
                            Already have an account? <a href="${pageContext.request.contextPath}/UserController?action=login" class="text-white text-decoration-underline">Login here</a>
                        </p>
                    </div>

                </form>
            </div>
        </div>
    </div>

</body>
</html>
