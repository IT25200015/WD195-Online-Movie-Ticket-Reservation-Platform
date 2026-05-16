<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify OTP - CineBooking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #121212;
            color: #f5f5f5;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        }

        .card {
            background-color: #1a1a1a;
            padding: 28px;
            border-radius: 12px;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 16px 32px rgba(0, 0, 0, 0.45);
            text-align: center;
        }

        .title {
            font-size: 1.6rem;
            font-weight: 700;
            margin-bottom: 8px;
            letter-spacing: 1px;
        }

        .subtitle {
            color: #b9b9b9;
            margin-bottom: 20px;
        }

        .otp {
            color: #e50914;
            font-weight: 700;
        }

        .input {
            width: 100%;
            padding: 12px;
            border-radius: 8px;
            border: 1px solid rgba(255, 255, 255, 0.15);
            background-color: #222222;
            color: #f5f5f5;
            margin-bottom: 16px;
        }

        .btn {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 999px;
            background-color: #e50914;
            color: #ffffff;
            font-weight: 700;
            cursor: pointer;
        }

        .error {
            color: #ff6b6b;
            margin-bottom: 12px;
        }
    </style>
</head>
<body>
    <div class="card">
        <div class="title">VERIFY OTP</div>
        <div class="subtitle">
            Check your email for the OTP. (Test Mode OTP: <span class="otp"><%= session.getAttribute("pendingOtp") %></span>)
        </div>

        <% if (request.getParameter("error") != null) { %>
            <div class="error">Invalid OTP. Please try again.</div>
        <% } %>

        <form action="${pageContext.request.contextPath}/UserController" method="POST">
            <input type="hidden" name="action" value="verifyOtp">
            <input class="input" type="text" name="otp" placeholder="Enter OTP" required>
            <button class="btn" type="submit">VERIFY</button>
        </form>
    </div>
</body>
</html>
