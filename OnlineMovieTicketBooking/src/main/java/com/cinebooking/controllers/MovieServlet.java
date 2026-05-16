//package com.cinebooking.controllers;
//
//import com.cinebooking.models.Movie;
//import com.cinebooking.services.MovieService;
//
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.*;
//
//import java.io.File;
//import java.io.IOException;
//import java.util.List;
//import jakarta.servlet.annotation.MultipartConfig;
//import jakarta.servlet.http.Part;
//
//@MultipartConfig(
//        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
//        maxFileSize = 1024 * 1024 * 10,       // 10MB
//        maxRequestSize = 1024 * 1024 * 50      // 50MB
//)
//@WebServlet("/movies")
//public class MovieServlet extends HttpServlet {
//
//    private MovieService movieService;
//
//    @Override
//    public void init() throws ServletException {
//        movieService = new MovieService();
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request,
//                         HttpServletResponse response)
//            throws ServletException, IOException {
//
//        List<Movie> movies = movieService.getAllMovies();
//
//        request.setAttribute("movies", movies);
//
//        String page = request.getParameter("page");
//
//        if ("manage".equals(page)) {
//
//            request.getRequestDispatcher("/includes/manageMovies.jsp")
//                    .forward(request, response);
//        }
//        else {

//            request.getRequestDispatcher("/includes/movies.jsp")
//                    .forward(request, response);
//        }
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request,
//                          HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String action = request.getParameter("action");
//
//        int id = Integer.parseInt(request.getParameter("id"));
//
//        // DELETE
//        if ("delete".equals(action)) {
//
//            movieService.deleteMovie(id);
//        }
//
//        // ADD OR UPDATE
//        else {
//
//            String title = request.getParameter("title");
//            String director = request.getParameter("director");
//            int year = Integer.parseInt(request.getParameter("year"));
//            String description = request.getParameter("description");
//
//            String duration = request.getParameter("duration");
//
//            String trailer = request.getParameter("trailer");
//
//            String fileName = "";
//
//            Part filePart = request.getPart("poster");
//
//            // only if user selected image
//            if (filePart != null &&
//                    filePart.getSize() > 0) {
//
//                fileName = filePart.getSubmittedFileName();
//
//                // Update the folder path according to your folder location
//                String uploadPath = "C:\\Users\\ASUS\\OneDrive\\Desktop\\WD195-Online-Movie-Ticket-Reservation-Platform\\OnlineMovieTicketBooking\\src\\main\\java\\com\\cinebooking\\uploads";;
//
//                File uploadDir = new File(uploadPath);
//
//                if (!uploadDir.exists()) {
//                    uploadDir.mkdir();
//                }
//
//                filePart.write(uploadPath + File.separator + fileName);
//            }
//
//            // UPDATE -> keep old poster if no new image selected
//            if ("update".equals(action) && fileName.isEmpty()) {

//                Movie oldMovie =
//                        movieService.getMovieById(id);
//
//                fileName = oldMovie.getPoster();
//            }
//
//            Movie movie = new Movie(
//                    id,
//                    title,
//                    director,
//                    year,
//                    fileName,
//                    description,
//                    duration,
//                    trailer
//            );

            // ADD
//            if ("add".equals(action)) {
//
//                movieService.addMovie(movie);
//            }
//
//            // UPDATE
//            else if ("update".equals(action)) {
//
//                movieService.updateMovie(movie);
//            }
//        }
//
//        response.sendRedirect(
//                request.getContextPath()
//                        + "/movies?page=manage");
//    }
//}

package com.cinebooking.controllers;

import com.cinebooking.models.Movie;
import com.cinebooking.services.MovieService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50      // 50MB
)
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

        // ADD OR UPDATE Details
        else {

            String title = request.getParameter("title");
            String director = request.getParameter("director");
            int year = Integer.parseInt(request.getParameter("year"));
            String description = request.getParameter("description");
            String duration = request.getParameter("duration");
            String trailer = request.getParameter("trailer");

            String fileName = "";

            Part filePart = request.getPart("poster");

            // only if user selected image
            if (filePart != null &&
                    filePart.getSize() > 0) {

                fileName = filePart.getSubmittedFileName();

                // ✅ CORRECTED: saves to src/main/webapp/images/
                String uploadPath = getServletContext().getRealPath("/images");

                File uploadDir = new File(uploadPath);

                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }

                filePart.write(uploadPath + File.separator + fileName);
            }

            // UPDATE -> keep old poster if no new image selected
            if ("update".equals(action) && fileName.isEmpty()) {

                Movie oldMovie =
                        movieService.getMovieById(id);

                fileName = oldMovie.getPoster();
            }

            Movie movie = new Movie(
                    id,
                    title,
                    director,
                    year,
                    fileName,
                    description,
                    duration,
                    trailer
            );

            // ADD
            if ("add".equals(action)) {

                movieService.addMovie(movie);
            }

            // UPDATE
            else if ("update".equals(action)) {

                movieService.updateMovie(movie);
            }
        }
        //response
        response.sendRedirect(
                request.getContextPath()
                        + "/movies?page=manage");
    }
}