package com.cinebooking.controllers;

import com.cinebooking.config.AppConfig;
import com.cinebooking.models.*;
import com.cinebooking.services.MovieService;
import com.cinebooking.services.ShowtimeService;
import com.cinebooking.services.BookingService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {

    private BookingService bookingService;
    private MovieService movieService;
    private ShowtimeService showtimeService;

    @Override
    public void init() throws ServletException {
        String seatFilepath = AppConfig.BASE_DATA_PATH + "seats.txt";
        String bookingFilepath = AppConfig.BASE_DATA_PATH + "bookings.txt";
        String movieFilePath = AppConfig.BASE_DATA_PATH + "movies.txt";
        String showTimeFilePath = AppConfig.BASE_DATA_PATH + "showtimes.txt";

        bookingService = new BookingService(seatFilepath, bookingFilepath);
        movieService = new MovieService(movieFilePath);
        showtimeService = new ShowtimeService(showTimeFilePath);

        getServletContext().setAttribute("movieService", movieService);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        Object sessionUser = session != null ? session.getAttribute("user") : null;
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/UserController?action=login");
            return;
        }

        User user = (User) sessionUser;
        String customerEmail = user.getEmail();
        String customerName  = user.getName();

        String action = request.getParameter("action");

        if ("myBookings".equals(action)) {
            String page = request.getParameter("page");
            if (page.equals("history")) {
                List<Booking> myBookings = bookingService.getConfirmedBookingsByEmail(customerEmail);

                request.setAttribute("myBookings", myBookings);
                request.getRequestDispatcher("/WEB-INF/views/myBookings.jsp")
                        .forward(request, response);
            }
            else {
                List<Booking> myBookings = bookingService.getPendingBookingsByEmail(customerEmail);

                request.setAttribute("myBookings", myBookings);
                request.getRequestDispatcher("/WEB-INF/views/myBookings.jsp")
                        .forward(request, response);
            }

        } else if ("bookMovie".equals(action)) {
            handleBooking(request, response);

        } else if ("selectSeat".equals(action)) {
            // User selected a showtime — load available seats
            String movieName   = request.getParameter("movieName");
            String showtimeId  = request.getParameter("showtimeId");

            if (showtimeId == null || showtimeId.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/booking");
                return;
            }

            List<Seat> seatList = bookingService.getAvailableSeats(Integer.parseInt(showtimeId));

            request.setAttribute("seatList", seatList);
            request.setAttribute("movieName", movieName);
            request.setAttribute("showtimeId", showtimeId);
            request.getRequestDispatcher("/includes/seatSelection.jsp")
                    .forward(request, response);

        } else {
            // Default - show all movies
            List<Movie> movies = movieService.getAllMovies();
            request.setAttribute("movies", movies);
            request.getRequestDispatcher("includes/bookingHome.jsp")
                    .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String action = request.getParameter("action");

        Object sessionUser = session != null ? session.getAttribute("user") : null;
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/UserController?action=login");
            return;
        }
        User user = (User) sessionUser;
        String customerName  = user.getName();
        String customerEmail = user.getEmail();

        if ("cancel".equals(action)) {
            String bookingId = request.getParameter("bookingId");
            bookingService.cancelBooking(bookingId);
            response.sendRedirect(request.getContextPath() + "/booking?action=myBookings&page=new");

            return;
        }

        if ("selectSeat".equals(action)) {
            // User chose a showtime from the dropdown
            String movieName  = request.getParameter("movieName");
            String showtimeId = request.getParameter("showtimeId");
            System.out.println("Showtime ID: " + showtimeId);
            List<Seat> seatList = bookingService.getAvailableSeats(Integer.parseInt(showtimeId));

            request.setAttribute("seatList", seatList);
            request.setAttribute("movieName", movieName);
            request.setAttribute("showtimeId", showtimeId);
            request.getRequestDispatcher("/includes/seatSelection.jsp")
                    .forward(request, response);
            return;
        }

        if ("bookMultiple".equals(action)) {
            String[] seatIds  = request.getParameterValues("seatIds");
            String movieName  = request.getParameter("movieName");
            String showtimeId = request.getParameter("showtimeId");
            List<String> bookingIDList = new java.util.ArrayList<>(List.of());
            if (seatIds != null) {
                for (String seatId : seatIds) {
                    Booking booking = bookingService.createBooking(customerName, customerEmail,
                            seatId, movieName, showtimeId, "PENDING");
                    bookingIDList.add(booking.getBookingId());
                    System.out.println("Saved Booking" + booking.getBookingId());
                }
                session.setAttribute("bookingIDList", bookingIDList);
            }
            session.setAttribute("movieName", movieName);
            session.setAttribute("showtime", showtimeId);
            session.setAttribute("seats", request.getParameter("seats"));
            session.setAttribute("total", request.getParameter("total"));
            response.sendRedirect(request.getContextPath() + "/booking?action=myBookings&page=new");
            // response.sendRedirect(request.getContextPath() + "/PaymentController?action=paymentForm");
            return;
        }

        if ("confirmBookings".equals(action)) {
            List<Booking> pendingBookings = bookingService.getPendingBookingsByEmail(customerEmail);
            List<String> bookingIDs = (List<String>) session.getAttribute("bookingIDList");
            for (Booking b : pendingBookings) {
                if (bookingIDs != null && bookingIDs.contains(b.getBookingId())) {
                    b.setBookingStatus("CONFIRMED");
                    bookingService.updateBooking(b);
                }
            }

            response.setStatus(HttpServletResponse.SC_OK);
            return;
        }

        // Create booking
        String seatId     = request.getParameter("seatId");
        String movieName  = request.getParameter("movieName");
        String showtimeId = request.getParameter("showtimeId");

        Booking booking = bookingService.createBooking(customerName, customerEmail,
                seatId, movieName, showtimeId, "PENDING");

        if (booking == null) {
            request.setAttribute("errorMessage", "Booking failed. Seat may already be taken.");
            request.setAttribute("seatList", bookingService.getAvailableSeats(Integer.parseInt(showtimeId)));
            request.setAttribute("movieName", movieName);
            request.setAttribute("showtimeId", showtimeId);
            request.getRequestDispatcher("/WEB-INF/views/seatSelection.jsp")
                    .forward(request, response);
            return;
        }

        request.setAttribute("booking", booking);
        request.getRequestDispatcher("/WEB-INF/views/bookingConfirmation.jsp")
                .forward(request, response);
    }

    void handleBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String movieID = request.getParameter("movieID");

        if (movieID == null || movieID.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing Movie ID");
            return;
        }

        int movieIDInt = Integer.parseInt(movieID);
        Movie movie = movieService.getMovieById(movieIDInt);
        List<Showtime> showTimesList = showtimeService.getShowtimesByMovieId(movieIDInt);

        request.setAttribute("movieName", movie.getTitle());
        request.setAttribute("movieID", movieIDInt);
        request.setAttribute("showTimeList", showTimesList);
        request.getRequestDispatcher("/includes/seatSelection.jsp")
                .forward(request, response);
    }
}