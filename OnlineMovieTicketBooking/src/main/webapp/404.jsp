<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Page Not Found</title>
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #121212;
            color: #ffffff;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            text-align: center;
        }

        .container {
            max-width: 520px;
            padding: 24px;
        }

        .code {
            font-size: 7rem;
            font-weight: 800;
            letter-spacing: 6px;
            margin: 0 0 12px 0;
        }

        .message {
            color: #b9b9b9;
            font-size: 1.05rem;
            margin: 0 0 28px 0;
            line-height: 1.5;
        }

        .btn-home {
            display: inline-block;
            background-color: #e50914;
            color: #ffffff;
            text-decoration: none;
            padding: 12px 26px;
            border-radius: 999px;
            font-weight: 700;
            letter-spacing: 0.5px;
        }

        .btn-home:hover {
            filter: brightness(1.05);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="code">404</div>
        <p class="message">Oops! You lost your way in the cinema.</p>
        <a class="btn-home" href="index.jsp">Back to Home</a>
    </div>
</body>
</html>

