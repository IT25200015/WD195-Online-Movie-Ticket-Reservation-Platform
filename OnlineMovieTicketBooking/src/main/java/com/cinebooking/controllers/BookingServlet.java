package com.cinebooking.controllers;

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
import java.util.List;

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {

    private BookingService bookingService;
    private MovieService movieService;
    private ShowtimeService showtimeService;

    @Override
    public void init() throws ServletException {
        String seatFilepath = getServletContext().getRealPath("/data/seats.txt");
        String bookingFilepath = getServletContext().getRealPath("/data/bookings.txt");
        String movieFilePath = getServletContext().getRealPath("/data/movies.txt");
        String showTimeFilePath = getServletContext().getRealPath("/data/showtimes.txt");

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

        switch (request.getParameter("action") == null ? "" : request.getParameter("action")) {
            case "myBookings" -> {
                String page = request.getParameter("page");
                List<Booking> myBookings = "history".equals(page)
                        ? bookingService.getConfirmedBookingsByEmail(customerEmail)
                        : bookingService.getPendingBookingsByEmail(customerEmail);

                request.setAttribute("myBookings", myBookings);
                request.getRequestDispatcher("/WEB-INF/views/myBookings.jsp").forward(request, response);
            }
            case "bookMovie" -> handleBooking(request, response);
            case "selectSeat" -> {
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
                request.getRequestDispatcher("/includes/seatSelection.jsp").forward(request, response);
            }
            default -> {
                List<Movie> movies = movieService.getAllMovies();
                request.setAttribute("movies", movies);
                request.getRequestDispatcher("includes/bookingHome.jsp").forward(request, response);
            }
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
        String customerEmail = user.getEmail();

        switch (action == null ? "" : action) {
            case "cancel" -> {
                String bookingId = request.getParameter("bookingId");
                bookingService.cancelBooking(bookingId);
                response.sendRedirect(request.getContextPath() + "/booking?action=myBookings&page=new");
            }
            case "selectSeat" -> {
                String movieName  = request.getParameter("movieName");
                String showtimeId = request.getParameter("showtimeId");
                List<Seat> seatList = bookingService.getAvailableSeats(Integer.parseInt(showtimeId));

                request.setAttribute("seatList", seatList);
                request.setAttribute("movieName", movieName);
                request.setAttribute("showtimeId", showtimeId);
                request.getRequestDispatcher("/includes/seatSelection.jsp").forward(request, response);
            }
            case "bookMultiple" -> {
                String[] seatIds  = request.getParameterValues("seatIds");
                String movieName  = request.getParameter("movieName");
                String showtimeId = request.getParameter("showtimeId");
                List<String> bookingIDList = new java.util.ArrayList<>();
                if (seatIds != null) {
                    for (String seatId : seatIds) {
                        Booking booking = bookingService.createBooking(user.getName(), customerEmail,
                                seatId, movieName, showtimeId, "PENDING");
                        if (booking != null) {
                            bookingIDList.add(booking.getBookingId());
                        }
                    }
                    session.setAttribute("bookingIDList", bookingIDList);
                }
                session.setAttribute("movieName", movieName);
                session.setAttribute("showtime", showtimeId);
                session.setAttribute("seats", request.getParameter("seats"));
                session.setAttribute("total", request.getParameter("total"));
                response.sendRedirect(request.getContextPath() + "/booking?action=myBookings&page=new");
            }
            case "confirmBookings" -> {
                List<Booking> pendingBookings = bookingService.getPendingBookingsByEmail(customerEmail);
                Object bookingIDsAttr = session.getAttribute("bookingIDList");
                if (bookingIDsAttr instanceof List<?> bookingIDs) {
                    for (Booking b : pendingBookings) {
                        if (bookingIDs.contains(b.getBookingId())) {
                            b.setBookingStatus("CONFIRMED");
                            bookingService.updateBooking(b);
                        }
                    }
                }
                response.setStatus(HttpServletResponse.SC_OK);
            }
            default -> {
                String seatId     = request.getParameter("seatId");
                String movieName  = request.getParameter("movieName");
                String showtimeId = request.getParameter("showtimeId");

                Booking booking = bookingService.createBooking(user.getName(), customerEmail,
                        seatId, movieName, showtimeId, "PENDING");

                if (booking == null) {
                    request.setAttribute("errorMessage", "Booking failed. Seat may already be taken.");
                    request.setAttribute("seatList", bookingService.getAvailableSeats(Integer.parseInt(showtimeId)));
                    request.setAttribute("movieName", movieName);
                    request.setAttribute("showtimeId", showtimeId);
                    request.getRequestDispatcher("/WEB-INF/views/seatSelection.jsp").forward(request, response);
                }

                request.setAttribute("bookedMovieName", booking.getMovieName());
                request.setAttribute("bookedSeats", booking.getSeatId());
                request.setAttribute("totalPrice", booking.getTotalPrice());
                
                request.getRequestDispatcher("/WEB-INF/views/booking_success.jsp").forward(request, response);
            }
        }
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