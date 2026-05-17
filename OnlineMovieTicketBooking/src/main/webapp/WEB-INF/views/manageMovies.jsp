<%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 16/05/2026
  Time: 19:52
  To change this template use File | Settings | File Templates.
--%>
<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<html>--%>
<%--<head>--%>
<%--    <title>Title</title>--%>
<%--</head>--%>
<%--<body>--%>

<%--</body>--%>
<%--</html>--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>

    <title>Manage Movies</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">

    <style>
        :root {
            --cinema-bg: #121212;
            --cinema-surface: #1a1a1a;
            --cinema-surface-2: #222222;
            --cinema-accent: #e50914;
            --cinema-text: #f5f5f5;
            --cinema-muted: #b9b9b9;
            --cinema-border: #333333;
        }

        body {
            background-color: var(--cinema-bg);
            color: var(--cinema-text);
        }

        .admin-card {
            background-color: var(--cinema-surface);
            border: 1px solid var(--cinema-border);
            border-radius: 16px;
            padding: 28px;
            box-shadow: 0 12px 32px rgba(0, 0, 0, 0.4);
        }

        .form-control,
        .form-select,
        textarea {
            background-color: var(--cinema-surface-2) !important;
            color: var(--cinema-text) !important;
            border: 1px solid var(--cinema-border) !important;
            box-shadow: none !important;
        }

        .form-control:focus,
        .form-select:focus,
        textarea:focus {
            border-color: var(--cinema-accent) !important;
            box-shadow: 0 0 0 3px rgba(229, 9, 20, 0.25) !important;
        }

        .form-control::placeholder,
        textarea::placeholder {
            color: #b9b9b9 !important;
        }

        .table {
            color: var(--cinema-text);
            border-color: var(--cinema-border);
        }

        .table thead th {
            background-color: #222222;
            color: var(--cinema-text);
            border-color: var(--cinema-border);
        }

        .table tbody tr {
            background-color: var(--cinema-surface);
        }

        .table tbody tr:hover {
            background-color: #232323;
        }

        .btn-danger {
            background-color: var(--cinema-accent) !important;
            border-color: var(--cinema-accent) !important;
        }
    </style>

</head>

<body class="container mt-5">

<div class="admin-card">

<h2 class="mb-4">Manage Movies</h2>

<!-- ADD MOVIE -->

<form action="${pageContext.request.contextPath}/movies"
      method="post"
      enctype="multipart/form-data" class="mb-5">

    <input type="hidden" name="action" value="add">

    <h4>Add Movie</h4>

    <input type="text" name="id" class="form-control bg-dark text-white mb-2" placeholder="ID" required>

    <input type="text" name="title" class="form-control bg-dark text-white mb-2" placeholder="Title" required>

    <input type="text" name="director" class="form-control bg-dark text-white mb-2" placeholder="Director" required>

    <input type="text" name="year" class="form-control bg-dark text-white mb-2" placeholder="Year" required>

    <input type="file"
           name="poster"
           class="form-control bg-dark text-white mb-2"
           accept="image/*"
           required>

    <textarea name="description"
              class="form-control bg-dark text-white mb-2"
              placeholder="Description"
              required></textarea>

    <input type="text"
           name="duration"
           class="form-control bg-dark text-white mb-2"
           placeholder="Duration (Eg: 2h 40m)"
           required>

    <input type="text"
           name="trailer"
           class="form-control bg-dark text-white mb-2"
           placeholder="YouTube Embed URL movie ID (Eg: YoHD9XEInc0 in https://www.youtube.com/embed/YoHD9XEInc0)"
           required>

    <button type="submit" class="btn btn-danger">
        Add Movie
    </button>

</form>


<!-- CREAT MOVIE TABLE -->

<table class="table table-bordered table-dark">

    <thead>

    <tr>

        <th>ID</th>
        <th>Title</th>
        <th>Director</th>
        <th>Year</th>
        <th>Actions</th>

    </tr>

    </thead>

    <tbody>

    <c:forEach var="movie" items="${movies}">

        <tr>

            <td>${movie.id}</td>
            <td>${movie.title}</td>
            <td>${movie.director}</td>
            <td>${movie.year}</td>

            <td>

                <!-- DELETE -->

                <form action="movies" method="post" style="display:inline;">

                    <input type="hidden" name="action" value="delete">

                    <input type="hidden" name="id" value="${movie.id}">

                    <button class="btn btn-danger btn-sm">
                        Delete
                    </button>

                </form>

                <!-- UPDATE -->

                <button class="btn btn-warning btn-sm"
                        data-bs-toggle="collapse"
                        data-bs-target="#update${movie.id}">

                    Update

                </button>

            </td>

        </tr>


        <!-- UPDATE FORM -->

        <tr class="collapse" id="update${movie.id}">

            <td colspan="5">

                <form action="${pageContext.request.contextPath}/movies"
                      method="post"
                      enctype="multipart/form-data"
                      class="mt-3">

                    <input type="hidden" name="action" value="update">

                    <input type="hidden" name="id" value="${movie.id}">

                    <input type="text"
                           name="title"
                           class="form-control bg-dark text-white mb-2"
                           value="${movie.title}">

                    <input type="text"
                           name="director"
                           class="form-control bg-dark text-white mb-2"
                           value="${movie.director}">

                    <input type="text"
                           name="year"
                           class="form-control bg-dark text-white mb-2"
                           value="${movie.year}">

                    <input type="file"
                           name="poster"
                           class="form-control bg-dark text-white mb-2"
                           accept="image/*">

                    <textarea name="description"
                              class="form-control bg-dark text-white mb-2"
                              placeholder="Description"
                              required></textarea>

                    <input type="text"
                           name="duration"
                           class="form-control bg-dark text-white mb-2"
                           placeholder="Duration (Eg: 2h 40m)"
                           required>

                    <input type="text"
                           name="trailer"
                           class="form-control bg-dark text-white mb-2"
                           placeholder="YouTube Embed URL (Eg: https://www.youtube.com/embed/YoHD9XEInc0)"
                           required>

                    <button class="btn btn-danger">
                        Save Changes
                    </button>

                </form>

            </td>

        </tr>

    </c:forEach>

    </tbody>

</table>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
