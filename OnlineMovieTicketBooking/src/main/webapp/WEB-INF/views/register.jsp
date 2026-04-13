<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create an Account - CineBooking</title>

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
            margin-bottom: 30px;
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
            <div class="col-md-6 col-lg-5">

                <div class="brand-title text-center">CINEBOOKING</div>

                <form action="${pageContext.request.contextPath}/UserController" method="POST">

                    <input type="hidden" name="action" value="register">

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
                        <input type="text" name="mobileNumber" class="form-control custom-input" required>
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
                        <input type="password" name="password" class="form-control custom-input" required>
                    </div>

                    <div class="mb-5">
                        <label class="form-label">Confirm password <span class="required-star">*</span></label>
                        <input type="password" name="confirmPassword" class="form-control custom-input" required>
                    </div>

                    <div class="form-check mb-4">
                        <input class="form-check-input" type="checkbox" required id="termsCheck">
                        <label class="form-check-label text-white-50" style="font-size: 0.85rem;" for="termsCheck">
                            I confirm that I have read the Privacy Policy and agree to the Terms of Use.
                        </label>
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

