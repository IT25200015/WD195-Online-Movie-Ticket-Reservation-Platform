
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<nav class="navbar navbar-expand-lg navbar-dark shadow">
    <div class="container">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/index.jsp">🎬 CineBooking</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="includes/movie.jsp">Movies</a></li> <li class="nav-item"><a class="nav-link" href="booking.jsp">Book Tickets</a></li> <li class="nav-item"><a class="nav-link" href="promotions.jsp">Offers</a></li> <li class="nav-item"><a class="nav-link" href="reviews.jsp">Reviews</a></li> <li class="nav-item"><a class="btn btn-outline-light ms-lg-3" href="login.jsp">Login</a></li> </ul>

                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/movies.jsp">Movies</a></li> <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/booking.jsp">Book Tickets</a></li> <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/promotions.jsp">Offers</a></li> <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/reviews.jsp">Reviews</a></li> <li class="nav-item"><a class="btn btn-outline-light ms-lg-3" href="${pageContext.request.contextPath}/UserController?action=login">Login</a></li> </ul>
        </div>
    </div>
</nav>
