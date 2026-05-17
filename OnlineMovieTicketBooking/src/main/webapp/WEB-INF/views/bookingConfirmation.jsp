<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.cinebooking.models.Booking" %>
<!DOCTYPE html>
<html>
<head>
    <title>Booking Confirmed - CineBooking</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f8f9fa; }
        .navbar { background-color: #2c3e50; }
        .footer { background-color: #2c3e50; color: white; padding: 20px 0; margin-top: 50px; }
        .confirmation-card {
            border-radius: 16px;
            border: none;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        .booking-id {
            font-size: 1.3rem;
            font-weight: 600;
            color: #2c3e50;
            letter-spacing: 2px;
        }
        .badge-standard { background-color: #3498db; }
        .badge-premium  { background-color: #9b59b6; }
        .badge-vip      { background-color: #f39c12; }
    </style>
</head>
<body>

<%@ include file="/includes/navbar.jsp" %>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-7">

            <div class="card confirmation-card p-4">

                <!-- Success Header -->
                <div class="text-center mb-4">
                    <div style="font-size: 60px;">🎉</div>
                    <h2 class="fw-bold text-success">Booking Confirmed!</h2>
                    <p class="text-muted">Your seat has been successfully booked.</p>
                </div>

                <%
                    Booking booking = (Booking) request.getAttribute("booking");
                    if (booking != null) {
                        String badgeClass = "badge-standard";
                        if (booking.getSeatType().equals("Premium")) badgeClass = "badge-premium";
                        if (booking.getSeatType().equals("VIP"))     badgeClass = "badge-vip";
                %>

                <!-- Booking ID -->
                <div class="text-center mb-4">
                    <span class="badge bg-dark p-2 booking-id">
                        <%= booking.getBookingId() %>
                    </span>
                </div>

                <!-- Booking Details -->
                <table class="table table-borderless">
                    <tr>
                        <td class="text-muted">Customer Name</td>
                        <td class="fw-bold"><%= booking.getCustomerName() %></td>
                    </tr>
                    <tr>
                        <td class="text-muted">Email</td>
                        <td><%= booking.getCustomerEmail() %></td>
                    </tr>
                    <tr>
                        <td class="text-muted">Movie</td>
                        <td class="fw-bold"><%= booking.getMovieName() %></td>
                    </tr>
                    <tr>
                        <td class="text-muted">Show Time</td>
                        <td><%= booking.getShowTime() %></td>
                    </tr>
                    <tr>
                        <td class="text-muted">Seat</td>
                        <td>
                            <%= booking.getSeatId() %>
                            <span class="badge <%= badgeClass %> ms-2">
                                <%= booking.getSeatType() %>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-muted">Total Price</td>
                        <td class="fw-bold text-success">
                            LKR <%= booking.getTotalPrice() %>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-muted">Booking Date</td>
                        <td><%= booking.getBookingDate() %></td>
                    </tr>
                </table>

                <!-- Buttons -->
                <div class="d-flex gap-3 mt-3">
                    <a href="<%= request.getContextPath() %>/booking"
                       class="btn btn-outline-dark w-50">
                        Book Another Seat
                    </a>
                    <a href="<%= request.getContextPath() %>/index.jsp"
                       class="btn w-50" style="background-color: #2c3e50; color: white;">
                        Go to Home
                    </a>
                </div>

                <% } else { %>
                <div class="alert alert-danger text-center">
                    No booking details found.
                </div>
                <% } %>

            </div>
        </div>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>