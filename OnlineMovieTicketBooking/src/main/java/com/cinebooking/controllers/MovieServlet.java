package com.cinebooking.controllers;

import com.cinebooking.models.Movie;
import com.cinebooking.services.MovieService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/movies")
public class MovieServlet extends HttpServlet {

    private MovieService movieService;

    @Override
    public void init() throws ServletException {
        movieService = new MovieService();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        List<Movie> movies = movieService.getAllMovies();

        request.setAttribute("movies", movies);

        String page = request.getParameter("page");

        if ("manage".equals(page)) {

            request.getRequestDispatcher("/includes/manageMovies.jsp")
                    .forward(request, response);
        }
        else {

            request.getRequestDispatcher("/includes/movies.jsp")
                    .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        int id = Integer.parseInt(request.getParameter("id"));

        // DELETE
        if ("delete".equals(action)) {

            movieService.deleteMovie(id);
        }

        // ADD OR UPDATE
        else {

            String title = request.getParameter("title");
            String director = request.getParameter("director");
            int year = Integer.parseInt(request.getParameter("year"));
            String poster = request.getParameter("poster");

            Movie movie = new Movie(id, title, director, year, poster);

            // ADD
            if ("add".equals(action)) {

                movieService.addMovie(movie);
            }

            // UPDATE
            else if ("update".equals(action)) {

                movieService.updateMovie(movie);
            }
        }

        response.sendRedirect("movies?page=manage");
    }
}