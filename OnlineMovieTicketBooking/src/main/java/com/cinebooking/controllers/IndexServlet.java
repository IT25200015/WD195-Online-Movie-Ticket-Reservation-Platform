package com.cinebooking.controllers;

import com.cinebooking.models.Movie;
import com.cinebooking.services.MovieService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/home")
public class IndexServlet extends HttpServlet {

    private MovieService movieService;

    @Override
    public void init() throws ServletException {

        String moviePath =
                getServletContext()
                        .getRealPath("/data/movies.txt");

        movieService = new MovieService(moviePath);
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        List<Movie> movies =
                movieService.getAllMovies();

        request.setAttribute("movies", movies);

        request.getRequestDispatcher(
                        "/index.jsp")
                .forward(request, response);
    }
}