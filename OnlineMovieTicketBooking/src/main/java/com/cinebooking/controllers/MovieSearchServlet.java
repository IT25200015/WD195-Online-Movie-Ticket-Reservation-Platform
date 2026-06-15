package com.cinebooking.controllers;

import com.cinebooking.models.Movie;
import com.cinebooking.services.MovieService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/movie-search")
public class MovieSearchServlet extends HttpServlet {

    private MovieService movieService;

    @Override
    public void init() throws ServletException {
        String movieFilePath = getServletContext().getRealPath("/data/movies.txt");
        movieService = new MovieService(movieFilePath);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        String query = request.getParameter("query");
        List<Movie> results = searchMovies(query);

        try (PrintWriter out = response.getWriter()) {
            out.print(toJson(request, results));
        }
    }

    private List<Movie> searchMovies(String query) throws IOException {
        List<Movie> allMovies = movieService.getAllMovies();
        List<Movie> results = new ArrayList<>();

        if (query == null || query.trim().isEmpty()) {
            return results;
        }

        String normalized = query.trim().toLowerCase();
        for (Movie movie : allMovies) {
            if (movie == null) {
                continue;
            }

            String title = movie.getTitle() != null ? movie.getTitle().toLowerCase() : "";
            String director = movie.getDirector() != null ? movie.getDirector().toLowerCase() : "";
            String description = movie.getDescription() != null ? movie.getDescription().toLowerCase() : "";
            String year = String.valueOf(movie.getYear());

            if (title.contains(normalized)
                    || director.contains(normalized)
                    || description.contains(normalized)
                    || year.contains(normalized)) {
                results.add(movie);
            }

            if (results.size() >= 8) {
                break;
            }
        }

        return results;
    }

    private String toJson(HttpServletRequest request, List<Movie> movies) {
        StringBuilder json = new StringBuilder();
        json.append("[");

        for (int i = 0; i < movies.size(); i++) {
            Movie movie = movies.get(i);
            if (i > 0) {
                json.append(',');
            }

            json.append('{')
                    .append("\"id\":").append(movie.getId()).append(',')
                    .append("\"title\":\"").append(escapeJson(movie.getTitle())).append("\",")
                    .append("\"posterUrl\":\"").append(escapeJson(buildPosterUrl(request, movie))).append("\",")
                    .append("\"year\":").append(movie.getYear()).append(',')
                    .append("\"director\":\"").append(escapeJson(movie.getDirector())).append("\"")
                    .append('}');
        }

        json.append(']');
        return json.toString();
    }

    private String buildPosterUrl(HttpServletRequest request, Movie movie) {
        String poster = movie.getPoster();
        if (poster == null || poster.trim().isEmpty()) {
            return request.getContextPath() + "/images/digital-deluxe.jpg";
        }
        return request.getContextPath() + "/images/" + poster;
    }

    private String escapeJson(String value) {
        if (value == null) {
            return "";
        }
        StringBuilder escaped = new StringBuilder(value.length() + 16);
        for (int i = 0; i < value.length(); i++) {
            char c = value.charAt(i);
            switch (c) {
                case '"' -> escaped.append("\\\"");
                case '\\' -> escaped.append("\\\\");
                case '\b' -> escaped.append("\\b");
                case '\f' -> escaped.append("\\f");
                case '\n' -> escaped.append("\\n");
                case '\r' -> escaped.append("\\r");
                case '\t' -> escaped.append("\\t");
                default -> {
                    if (c < 0x20) {
                        escaped.append(String.format("\\u%04x", (int) c));
                    } else {
                        escaped.append(c);
                    }
                }
            }
        }
        return escaped.toString();
    }
}

