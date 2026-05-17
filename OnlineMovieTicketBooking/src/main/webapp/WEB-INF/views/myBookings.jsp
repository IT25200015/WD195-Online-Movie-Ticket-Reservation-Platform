<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cinebooking.models.Booking" %>
<!DOCTYPE html>
<html>
<head>
  <title>My Bookings - CineBooking</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
  <style>
    body { font-family: 'Poppins', sans-serif; background-color: #f8f9fa; }
    .navbar { background-color: #2c3e50; }
    .footer { background-color: #2c3e50; color: white; padding: 20px 0; margin-top: 50px; }
    .booking-card {
      border-radius: 12px;
      border: none;
      box-shadow: 0 2px 15px rgba(0,0,0,0.08);
      margin-bottom: 20px;
    }
    .badge-standard { background-color: #3498db; }
    .badge-premium  { background-color: #9b59b6; }
    .badge-vip      { background-color: #f39c12; }
  </style>
</head>

<script>
  async function handlePayment() {
    try {
      const response = await fetch("<%= request.getContextPath() %>/booking", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "action=confirmBookings"
      });

      if (response.ok) {
        window.location.href = "<%= request.getContextPath() %>/payment";
      } else {
        alert("Failed to confirm bookings. Please try again.");
      }
    } catch (err) {
      console.error("Error confirming bookings:", err);
      alert("Something went wrong. Please try again.");
    }
  }
</script>
<body>

<%@ include file="/includes/navbar.jsp" %>

<div class="container my-5">
  <h2 class="fw-bold mb-4">My Bookings</h2>

    <%
    List<Booking> myBookings = (List<Booking>) request.getAttribute("myBookings");
    double subtotal = 0;

    if (myBookings == null || myBookings.isEmpty()) {
%>
  <div class="alert alert-info">
    You have no bookings yet.
    <a href="<%= request.getContextPath() %>/booking">Book a seat now!</a>
  </div>
    <%
    } else {
        for (Booking b : myBookings) {
            subtotal += b.getTotalPrice(); // use the getter that actually exists
            String badgeClass = "badge-standard";
            if (b.getSeatType().equals("Premium")) badgeClass = "badge-premium";
            if (b.getSeatType().equals("VIP"))     badgeClass = "badge-vip";
%>
  <div class="card booking-card p-4">
    <div class="row align-items-center">
      <div class="col-md-8">
        <h5 class="fw-bold mb-1">🎬 <%= b.getMovieName() %>
          <% if ("PENDING".equalsIgnoreCase(b.getBookingStatus())) { %>
          <span class="badge bg-warning text-dark ms-2">⏳ Pending</span>
          <% } else if ("CONFIRMED".equalsIgnoreCase(b.getBookingStatus())) { %>
          <span class="badge bg-success ms-2">✅ Confirmed</span>
          <% } else if ("CANCELLED".equalsIgnoreCase(b.getBookingStatus())) { %>
          <span class="badge bg-danger ms-2">❌ Cancelled</span>
          <% } %>
        </h5>
        <p class="text-muted mb-1">🕐 <%= b.getShowTime() %></p>
        <p class="mb-1">
          Seat: <strong><%= b.getSeatId() %></strong>
          <span class="badge <%= badgeClass %> ms-2"><%= b.getSeatType() %></span>
        </p>
        <p class="mb-1">Date: <%= b.getBookingDate() %></p>
        <p class="mb-0">
          Total: <strong class="text-success">LKR <%= b.getTotalPrice() %></strong>
        </p>
        <small class="text-muted">Booking ID: <%= b.getBookingId() %></small>
      </div>
      <div class="col-md-4 text-end">
        <form method="post" action="<%= request.getContextPath() %>/booking">
          <input type="hidden" name="action" value="cancel">
          <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
          <button type="submit" class="btn btn-danger"
                  onclick="return confirm('Are you sure you want to cancel this booking?')">
            Cancel Booking
          </button>
        </form>
      </div>
    </div>
  </div>
    <%
        }

        // Subtotal card — only shown when there are bookings
         if (!"history".equals(request.getParameter("page"))) {
%>

  <div class="card shadow-sm mt-4">
    <div class="card-body d-flex justify-content-between align-items-center">
      <div>
        <h5 class="mb-1">Order Summary</h5>
        <p class="text-muted mb-0"><%= myBookings.size() %> booking(s)</p>
      </div>
      <div class="text-end">
        <h4 class="fw-bold text-warning mb-2">LKR <%= (int) subtotal %></h4>
        <button type="button" class="btn btn-warning fw-bold px-4" onclick="handlePayment()">
          Proceed to Payment →
        </button>
      </div>
    </div>
  </div>
    <%
    }
    }
%>

<%@ include file="/includes/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>