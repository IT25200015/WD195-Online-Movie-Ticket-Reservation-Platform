<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cinebooking.models.Booking" %>
<!DOCTYPE html>
<html>
<head>
  <title>My Bookings - CineBooking</title>
  <jsp:include page="/includes/header.jsp" />
  <style>
    body { font-family: 'Poppins', sans-serif; background-color: #121212; color: #f5f5f5; }
    .booking-card {
      background-color: #1b1b1b;
      border-radius: 12px;
      border: 1px solid #2a2a2a;
      box-shadow: 0 2px 16px rgba(0,0,0,0.4);
      margin-bottom: 20px;
    }
    .badge-standard { background-color: #3498db; }
    .badge-premium  { background-color: #9b59b6; }
    .badge-vip      { background-color: #f39c12; }
    .empty-state-alert {
      background-color: #222;
      border: 1px solid #e50914;
      color: #f5f5f5;
    }
    .empty-state-alert a { color: #e50914; font-weight: 600; }
    .empty-state-alert a:hover { color: #ff3b30; }
  </style>
</head>

<script>
  async function handlePayment() {
    try {
      window.location.href = "<%= request.getContextPath() %>/PaymentController?action=paymentForm";
    } catch (err) {
      console.error("Error confirming bookings:", err);
      alert("Something went wrong. Please try again.");
    }
  }
</script>
<body class="d-flex flex-column min-vh-100">

<%@ include file="/includes/navbar.jsp" %>

<main class="flex-grow-1 container mt-5">
  <h2 class="fw-bold mb-4 text-light">My Bookings</h2>

    <%
    List<Booking> myBookings = (List<Booking>) request.getAttribute("myBookings");
    double subtotal = 0;

    if (myBookings == null || myBookings.isEmpty()) {
%>
  <div class="alert empty-state-alert">
    You have no bookings yet.
    <a href="<%= request.getContextPath() %>/booking">Book a seat now!</a>
  </div>
    <%
    } else {
        StringBuilder seatIds = new StringBuilder();
        for (Booking b : myBookings) {
            subtotal += b.getTotalPrice();

            String badgeClass = "badge-standard";
            if (b.getSeatType().equals("Premium")) badgeClass = "badge-premium";
            if (b.getSeatType().equals("VIP"))     badgeClass = "badge-vip";
            if (!seatIds.isEmpty()) seatIds.append(",");
            seatIds.append(b.getSeatId());
%>
  <div class="card booking-card p-4">
    <div class="row align-items-center">
      <div class="col-md-8">
        <h5 class="fw-bold mb-1 text-light">🎬 <%= b.getMovieName() %>
          <% if ("PENDING".equalsIgnoreCase(b.getBookingStatus())) { %>
          <span class="badge bg-warning text-dark ms-2">⏳ Pending</span>
          <% } else if ("CONFIRMED".equalsIgnoreCase(b.getBookingStatus())) { %>
          <span class="badge bg-success ms-2">✅ Confirmed</span>
          <% } else if ("CANCELLED".equalsIgnoreCase(b.getBookingStatus())) { %>
          <span class="badge bg-danger ms-2">❌ Cancelled</span>
          <% } %>
        </h5>
        <p class="text-secondary mb-1">🕐 <%= b.getShowTime() %></p>
        <p class="mb-1 text-light">
          Seat: <strong><%= b.getSeatId() %></strong>
          <span class="badge <%= badgeClass %> ms-2"><%= b.getSeatType() %></span>
        </p>
        <p class="mb-1 text-light">Date: <%= b.getBookingDate() %></p>
        <p class="mb-0 text-light">
          Total: <strong class="text-warning">LKR <%= b.getTotalPrice() %></strong>
        </p>
        <small class="text-secondary">Booking ID: <%= b.getBookingId() %></small>
      </div>
      <div class="col-md-4 text-end">
        <form method="post" action="<%= request.getContextPath() %>/booking">
          <input type="hidden" name="action" value="cancel">
          <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
          <button type="submit" class="btn btn-outline-danger"
                  onclick="return confirm('Are you sure you want to cancel this booking?')">
            Cancel Booking
          </button>
        </form>
      </div>
    </div>
  </div>
    <%
        }
        session.setAttribute("total", String.valueOf(subtotal));
        session.setAttribute("seats", seatIds.toString());
        // Subtotal card — only shown when there are bookings
         if (!"history".equals(request.getParameter("page"))) {
%>

  <div class="card booking-card mt-4">
    <div class="card-body d-flex justify-content-between align-items-center">
      <div>
        <h5 class="mb-1 text-light">Order Summary</h5>
        <p class="text-secondary mb-0"><%= myBookings.size() %> booking(s)</p>
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
</main>

<%@ include file="/includes/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
