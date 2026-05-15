package seatbooking.servlet;

import seatbooking.model.Booking;
import seatbooking.model.Seat;
import seatbooking.service.BookingService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

public class BookingServlet extends HttpServlet {

    private BookingService bookingService;

    @Override
    public void init() throws ServletException {
        bookingService = new BookingService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        String action = request.getParameter("action");

        if ("myBookings".equals(action)) {
            // Show my bookings page - temporary test user
            String customerEmail = "test@test.com";

            List<Booking> myBookings = bookingService.getBookingsByEmail(customerEmail);
            request.setAttribute("myBookings", myBookings);
            request.getRequestDispatcher("/WEB-INF/views/myBookings.jsp")
                    .forward(request, response);
            return;
        }

        // Default - show seat selection page
        String movieName = request.getParameter("movieName");
        String showTime  = request.getParameter("showTime");

        List<Seat> seatList = bookingService.getAllSeats();

        request.setAttribute("seatList", seatList);
        request.setAttribute("movieName", movieName);
        request.setAttribute("showTime", showTime);

        request.getRequestDispatcher("/WEB-INF/views/seatSelection.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        String action = request.getParameter("action");

        // Temporary - hardcoded user for testing
        String customerName  = "TestUser";
        String customerEmail = "test@test.com";

        if ("cancel".equals(action)) {
            String bookingId = request.getParameter("bookingId");
            bookingService.cancelBooking(bookingId);
            response.sendRedirect(request.getContextPath() + "/booking?action=myBookings");
            return;
        }

        String seatId    = request.getParameter("seatId");
        String movieName = request.getParameter("movieName");
        String showTime  = request.getParameter("showTime");

        Booking booking = bookingService.createBooking(customerName, customerEmail,
                seatId, movieName, showTime);

        if (booking == null) {
            request.setAttribute("errorMessage", "Booking failed. Seat may already be taken.");
            request.setAttribute("seatList", bookingService.getAllSeats());
            request.setAttribute("movieName", movieName);
            request.setAttribute("showTime", showTime);
            request.getRequestDispatcher("/WEB-INF/views/seatSelection.jsp")
                    .forward(request, response);
            return;
        }

        request.setAttribute("booking", booking);
        request.getRequestDispatcher("/WEB-INF/views/bookingConfirmation.jsp")
                .forward(request, response);
    }
}