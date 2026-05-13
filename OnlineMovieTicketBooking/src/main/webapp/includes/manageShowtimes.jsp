<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib prefix="c"
           uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>

    <title>Manage Showtimes</title>

    <link href=
                  "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
          rel="stylesheet">

</head>

<body class="container-fluid mt-4">

<div class="row">

    <!-- MOVIE LIST -->

    <div class="col-md-3">

        <h3 class="mb-4">
            Movies
        </h3>

        <div class="list-group">

            <c:forEach var="movie"
                       items="${movies}">

                <a href=
                           "${pageContext.request.contextPath}/showtimes?page=manage&movieId=${movie.id}"

                   class="list-group-item list-group-item-action">

                        ${movie.title}

                </a>

            </c:forEach>

        </div>

    </div>


    <!-- SHOWTIME SECTION -->

    <div class="col-md-9">

        <h3 class="mb-4">
            Manage Showtimes
        </h3>

        <!-- IF MOVIE SELECTED -->

        <c:if test="${selectedMovieId != null}">

            <!-- ADD SHOWTIME -->

            <form action=
                          "${pageContext.request.contextPath}/showtimes"
                  method="post"
                  class="mb-4">

                <input type="hidden"
                       name="action"
                       value="add">

                <input type="hidden"
                       name="movieId"
                       value="${selectedMovieId}">

                <input type="text"
                       name="id"
                       class="form-control mb-2"
                       placeholder="Showtime ID"
                       required>

                <select name="day"
                        class="form-control mb-2">

                    <option>Monday</option>
                    <option>Tuesday</option>
                    <option>Wednesday</option>
                    <option>Thursday</option>
                    <option>Friday</option>
                    <option>Saturday</option>
                    <option>Sunday</option>

                </select>

                <input type="time"
                       name="time"
                       class="form-control mb-2"
                       required>

                <button class=
                                "btn btn-success">

                    Add Showtime

                </button>

            </form>


            <!-- SHOWTIME TABLE -->

            <table class=
                           "table table-bordered">

                <thead>

                <tr>

                    <th>ID</th>
                    <th>Day</th>
                    <th>Time</th>
                    <th>Actions</th>

                </tr>

                </thead>

                <tbody>

                <c:forEach var="show"
                           items="${showtimes}">

                    <tr>

                        <td>${show.id}</td>

                        <td>${show.day}</td>

                        <td>${show.time}</td>

                        <td>

                            <!-- DELETE -->

                            <form action=
                                          "${pageContext.request.contextPath}/showtimes"
                                  method="post"
                                  style="display:inline;">

                                <input type="hidden"
                                       name="action"
                                       value="delete">

                                <input type="hidden"
                                       name="id"
                                       value="${show.id}">

                                <input type="hidden"
                                       name="movieId"
                                       value="${selectedMovieId}">

                                <button class=
                                                "btn btn-danger btn-sm">

                                    Delete

                                </button>

                            </form>


                            <!-- UPDATE BUTTON -->

                            <button class=
                                            "btn btn-warning btn-sm"

                                    data-bs-toggle="collapse"

                                    data-bs-target=
                                            "#update${show.id}">

                                Update

                            </button>

                        </td>

                    </tr>


                    <!-- UPDATE FORM -->

                    <tr class="collapse"
                        id="update${show.id}">

                        <td colspan="4">

                            <form action=
                                          "${pageContext.request.contextPath}/showtimes"
                                  method="post">

                                <input type="hidden"
                                       name="action"
                                       value="update">

                                <input type="hidden"
                                       name="id"
                                       value="${show.id}">

                                <input type="hidden"
                                       name="movieId"
                                       value="${selectedMovieId}">

                                <select name="day"
                                        class="form-control mb-2">

                                    <option ${show.day == 'Monday' ? 'selected' : ''}>
                                        Monday
                                    </option>

                                    <option ${show.day == 'Tuesday' ? 'selected' : ''}>
                                        Tuesday
                                    </option>

                                    <option ${show.day == 'Wednesday' ? 'selected' : ''}>
                                        Wednesday
                                    </option>

                                    <option ${show.day == 'Thursday' ? 'selected' : ''}>
                                        Thursday
                                    </option>

                                    <option ${show.day == 'Friday' ? 'selected' : ''}>
                                        Friday
                                    </option>

                                    <option ${show.day == 'Saturday' ? 'selected' : ''}>
                                        Saturday
                                    </option>

                                    <option ${show.day == 'Sunday' ? 'selected' : ''}>
                                        Sunday
                                    </option>

                                </select>

                                <input type="time"
                                       name="time"
                                       value="${show.time}"
                                       class="form-control mb-2">

                                <button class=
                                                "btn btn-primary">

                                    Save Changes

                                </button>

                            </form>

                        </td>

                    </tr>

                </c:forEach>

                </tbody>

            </table>

        </c:if>


        <!-- NO MOVIE SELECTED -->

        <c:if test="${selectedMovieId == null}">

            <div class="alert alert-info">

                Select a movie to manage showtimes.

            </div>

        </c:if>

    </div>

</div>

<script src=
                "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js">
</script>

</body>
</html>