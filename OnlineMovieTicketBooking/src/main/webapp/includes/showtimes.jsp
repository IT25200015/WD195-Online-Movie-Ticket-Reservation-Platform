<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"
           uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>

    <title>Showtimes</title>

    <link href=
                  "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
          rel="stylesheet">

</head>

<body class="container mt-5">

<h2 class="mb-4">Movie Showtimes</h2>

<table class="table table-bordered">

    <thead>

    <tr>

        <th>Day</th>
        <th>Time</th>

    </tr>

    </thead>

    <tbody>

    <c:forEach var="show" items="${showtimes}">

        <tr>

            <td>${show.day}</td>
            <td>${show.time}</td>

        </tr>

    </c:forEach>

    </tbody>

</table>

</body>
</html>