<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cinebooking.models.Seat" %>
<%@ page import="com.cinebooking.models.Showtime" %>
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
        .badge-standard { background-color: #3498db; }
        .badge-premium  { background-color: #9b59b6; }
        .badge-vip      { background-color: #f39c12; }

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

        .showtime-select {
            appearance: none;
            -webkit-appearance: none;
            background-color: #2c3e50;
            color: white;
            border: 1px solid rgba(255,255,255,0.15);
            border-radius: 8px;
            padding: 10px 40px 10px 14px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.95rem;
            cursor: pointer;
            width: 100%;
            max-width: 300px;
            transition: border-color .2s;
        }

        .showtime-select:focus {
            outline: none;
            border-color: #f39c12;
        }

        .showtime-select option {
            background-color: #2c3e50;
            color: white;
        }
    </style>
</head>
<body>

<%@ include file="/includes/navbar.jsp" %>

<div class="container my-5">

    <h2 class="fw-bold mb-1">Select Your Seat</h2>
    <p class="text-muted mb-4">
        🎬 <strong><%= request.getAttribute("movieName") %></strong>
    </p>

    <!-- Showtime Dropdown -->
    <form method="post" action="<%= request.getContextPath() %>/booking">
        <input type="hidden" name="action" value="selectSeat">
        <input type="hidden" name="movieName" value="<%= request.getAttribute("movieName") %>">
        <input type="hidden" name="movieID" value="<%= request.getAttribute("movieID") %>">

        <div class="mb-4">
            <label for="showtimeId" class="form-label fw-bold">Select Showtime</label>
            <select name="showtimeId" id="showtimeId" class="showtime-select"
                    onchange="this.form.submit()">
                <option value="">-- Choose a showtime --</option>
                <%
                    List<Showtime> showTimeList = (List<Showtime>) request.getAttribute("showTimeList");
                    String selectedShowtime = (String) request.getAttribute("showtimeId");
                    if (showTimeList != null) {
                        for (Showtime st : showTimeList) {
                            String selected = (selectedShowtime != null &&
                                    selectedShowtime.equals(String.valueOf(st.getId()))) ? "selected" : "";
                %>
                <option value="<%= st.getId() %>" <%= selected %>>
                    <%= st.getDay() %> &mdash; <%= st.getTime() %>
                </option>
                <%
                        }
                    }
                %>
            </select>
        </div>
    </form>

    <!-- Error message -->
    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="alert alert-danger">
        <%= request.getAttribute("errorMessage") %>
    </div>
    <% } %>

    <!-- Only show seats if a showtime is selected -->
    <%
        List<Seat> seatList = (List<Seat>) request.getAttribute("seatList");
        if (seatList != null && !seatList.isEmpty()) {
    %>

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
            for (Seat seat : seatList) {
                String badgeClass = "badge-standard";
                if (seat.getSeatType().equals("Premium")) badgeClass = "badge-premium";
                if (seat.getSeatType().equals("VIP"))     badgeClass = "badge-vip";
                String bookedClass = seat.isBooked() ? "seat-booked" : "";
        %>
        <div class="col-6 col-md-3 col-lg-2">
            <form method="post" action="<%= request.getContextPath() %>/booking">
                <input type="hidden" name="seatId"     value="<%= seat.getSeatId() %>">
                <input type="hidden" name="movieName"  value="<%= request.getAttribute("movieName") %>">
                <input type="hidden" name="showtimeId" value="<%= request.getAttribute("showtimeId") %>">

                <button type="submit"
                        class="btn w-100 seat-card border shadow-sm <%= bookedClass %>"
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
        %>
    </div>

    <% } else if (request.getAttribute("showtimeId") != null) { %>
    <div class="alert alert-info">No seats available for this showtime.</div>
    <% } %>

</div>

<%@ include file="/includes/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>