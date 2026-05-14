package com.cinebooking.controllers;

import com.cinebooking.models.Movie;
import com.cinebooking.models.Showtime;
import com.cinebooking.services.MovieService;
import com.cinebooking.services.ShowtimeService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/showtimes")
public class ShowtimeServlet extends HttpServlet {

    private ShowtimeService service;

    @Override
    public void init() {

        service = new ShowtimeService();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        MovieService movieService =
                new MovieService();

        List<Movie> movies =
                movieService.getAllMovies();

        request.setAttribute("movies", movies);

        String movieIdParam =
                request.getParameter("movieId");

        if (movieIdParam != null) {

            int movieId =
                    Integer.parseInt(movieIdParam);

            List<Showtime> showtimes =
                    service.getShowtimesByMovieId(movieId);

            request.setAttribute(
                    "showtimes",
                    showtimes);

            request.setAttribute(
                    "selectedMovieId",
                    movieId);
        }

        String page =
                request.getParameter("page");

        // ADMIN PAGE
        if ("manage".equals(page)) {

            request.getRequestDispatcher(
                            "/includes/manageShowtimes.jsp")
                    .forward(request, response);
        }

        // USER PAGE
        else {

            request.getRequestDispatcher(
                            "/includes/showtimes.jsp")
                    .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        int id =
                Integer.parseInt(request.getParameter("id"));

        int movieId =
                Integer.parseInt(
                        request.getParameter("movieId"));

        if ("delete".equals(action)) {

            service.deleteShowtime(id);
        }
        else {

            String day =
                    request.getParameter("day");

            String time =
                    request.getParameter("time");

            Showtime showtime =
                    new Showtime(id, movieId,
                            day, time);

            if ("add".equals(action)) {

                service.addShowtime(showtime);
            }
            else if ("update".equals(action)) {

                service.updateShowtime(showtime);
            }
        }

        response.sendRedirect(
                "showtimes?page=manage&movieId="
                        + movieId);
    }
}
