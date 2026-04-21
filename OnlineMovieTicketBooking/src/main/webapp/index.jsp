<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>CineBooking | Home</title>
    <%@ include file="includes/header.jsp" %>
</head>
<body>
<%@ include file="includes/navbar.jsp" %>

<div class="container text-center" style="margin-top: 100px; min-height: 400px;">
    <h1 class="display-4 fw-bold">Welcome to CineBooking</h1>
    <p class="lead">The best place to book your favorite movie tickets online!</p>
    <hr class="my-4">
    <a class="btn btn-primary btn-lg" href="${pageContext.request.contextPath}/UserController?action=register" role="button">Register Now</a>
</div>

<%@ include file="includes/footer.jsp" %>
</body>
</html>