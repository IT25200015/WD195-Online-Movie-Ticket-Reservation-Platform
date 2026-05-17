package com.cinebooking.controllers;

import com.cinebooking.models.Movie;
import com.cinebooking.models.Showtime;
import com.cinebooking.services.MovieService;
import com.cinebooking.services.ShowtimeService;
import com.cinebooking.models.Booking;
import com.cinebooking.models.Seat;
import com.cinebooking.services.BookingService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

public class BookingServlet extends HttpServlet {

    private BookingService bookingService;
    private MovieService movieService;
    private ShowtimeService showtimeService;

    @Override
    public void init() throws ServletException {
        bookingService = new BookingService();
        movieService = new MovieService();
        showtimeService = new ShowtimeService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        String action = request.getParameter("action");

        if ("myBookings".equals(action)) {
            String customerEmail = "test@test.com";
            List<Booking> myBookings = bookingService.getBookingsByEmail(customerEmail);
            request.setAttribute("myBookings", myBookings);
            request.getRequestDispatcher("/WEB-INF/views/myBookings.jsp")
                    .forward(request, response);

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

        HttpSession session = request.getSession(true);
        String action = request.getParameter("action");

        String customerName  = "TestUser";
        String customerEmail = "test@test.com";

        if ("cancel".equals(action)) {
            String bookingId = request.getParameter("bookingId");
            bookingService.cancelBooking(bookingId);
            response.sendRedirect(request.getContextPath() + "/booking?action=myBookings");
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

        // Create booking
        String seatId     = request.getParameter("seatId");
        String movieName  = request.getParameter("movieName");
        String showtimeId = request.getParameter("showtimeId");

        Booking booking = bookingService.createBooking(customerName, customerEmail,
                seatId, movieName, showtimeId);

        if (booking == null) {
            request.setAttribute("errorMessage", "Booking failed. Seat may already be taken.");
            request.setAttribute("seatList", bookingService.getAvailableSeats(Integer.parseInt(showtimeId)));
            request.setAttribute("movieName", movieName);
            request.setAttribute("showtimeId", showtimeId);
            request.getRequestDispatcher("/includes/seatSelection.jsp")
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