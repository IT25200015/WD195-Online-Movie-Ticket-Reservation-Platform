<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="seatbooking.model.Seat" %>
<!DOCTYPE html>
<html>
<head>
    <title>Select a Seat - CineBooking</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f8f9fa; }
        .navbar { background-color: #2c3e50; }
        .footer { background-color: #2c3e50; color: white; padding: 20px 0; margin-top: 50px; }

        .seat-card {
            border-radius: 12px;
            transition: transform 0.2s;
            cursor: pointer;
        }
        .seat-card:hover {
            transform: scale(1.05);
        }
        .seat-booked {
            opacity: 0.5;
            cursor: not-allowed;
            pointer-events: none;
        }
        .badge-standard  { background-color: #3498db; }
        .badge-premium   { background-color: #9b59b6; }
        .badge-vip       { background-color: #f39c12; }

        .screen {
            background: linear-gradient(to bottom, #bdc3c7, #ecf0f1);
            border-radius: 8px;
            padding: 10px;
            text-align: center;
            font-weight: 600;
            color: #555;
            letter-spacing: 4px;
            margin-bottom: 30px;
        }
    </style>
</head>
<body>

<%@ include file="/includes/navbar.jsp" %>

<div class="container my-5">

    <h2 class="fw-bold mb-1">Select Your Seat</h2>
    <p class="text-muted mb-4">
        🎬 <strong><%= request.getAttribute("movieName") %></strong>
        &nbsp;|&nbsp;
        🕐 <strong><%= request.getAttribute("showTime") %></strong>
    </p>

    <!-- Error message if booking fails -->
    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="alert alert-danger">
        <%= request.getAttribute("errorMessage") %>
    </div>
    <% } %>

    <!-- Screen indicator -->
    <div class="screen">SCREEN</div>

    <!-- Seat Legend -->
    <div class="d-flex gap-3 mb-4">
        <span class="badge badge-standard p-2">Standard - LKR 500</span>
        <span class="badge badge-premium p-2">Premium - LKR 1000</span>
        <span class="badge badge-vip p-2">VIP - LKR 1500</span>
        <span class="badge bg-secondary p-2">Booked</span>
    </div>

    <!-- Seat Grid -->
    <div class="row g-3">
        <%
            List<Seat> seatList = (List<Seat>) request.getAttribute("seatList");
            if (seatList != null) {
                for (Seat seat : seatList) {
                    String badgeClass = "badge-standard";
                    if (seat.getSeatType().equals("Premium")) badgeClass = "badge-premium";
                    if (seat.getSeatType().equals("VIP"))     badgeClass = "badge-vip";
                    String bookedClass = seat.isBooked() ? "seat-booked" : "";
        %>
        <div class="col-6 col-md-3 col-lg-2">
            <form method="post" action="<%= request.getContextPath() %>/booking">
                <input type="hidden" name="seatId"    value="<%= seat.getSeatId() %>">
                <input type="hidden" name="movieName" value="<%= request.getAttribute("movieName") %>">
                <input type="hidden" name="showTime"  value="<%= request.getAttribute("showTime") %>">

                <button type="submit" class="btn w-100 seat-card border shadow-sm <%= bookedClass %>"
                        <%= seat.isBooked() ? "disabled" : "" %>>
                    <div class="fw-bold"><%= seat.getSeatId() %></div>
                    <span class="badge <%= badgeClass %> mt-1"><%= seat.getSeatType() %></span>
                    <div class="small mt-1">LKR <%= (int) seat.getPrice() %></div>
                    <% if (seat.isBooked()) { %>
                    <div class="small text-danger">Booked</div>
                    <% } %>
                </button>
            </form>
        </div>
        <%
                }
            }
        %>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>