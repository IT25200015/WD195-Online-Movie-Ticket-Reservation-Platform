package com.cinebooking.controllers;

import com.cinebooking.models.Movie;
import com.cinebooking.services.MovieService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/movie-details")
public class MovieDetailsServlet
        extends HttpServlet {

    private MovieService movieService;

    @Override
    public void init() {

        String dataFilePath = getServletContext().getRealPath("/data/movies.txt");
        movieService = new MovieService(dataFilePath);
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        int movieId =
                Integer.parseInt(
                        request.getParameter("movieId"));

        Movie movie =
                movieService.getMovieById(movieId);

        request.setAttribute("movie", movie);

        request.getRequestDispatcher(
                        "/includes/movieDetails.jsp")
                .forward(request, response);
    }
}