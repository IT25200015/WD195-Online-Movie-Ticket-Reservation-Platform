package com.cinebooking.services;

import com.cinebooking.models.Movie;

import java.io.*;
import java.util.*;

public class MovieService {

    private final String filePath;

    public MovieService(String filePath) {
        this.filePath = filePath;
    }

    // Read all movies
    public List<Movie> getAllMovies() throws IOException {
        List<Movie> movies = new ArrayList<>();
        File file = new File(filePath);

        if (!file.exists()) return movies;

        BufferedReader br = new BufferedReader(new FileReader(file));
        String line;

        while ((line = br.readLine()) != null) {

            if (line.trim().isEmpty()) {
                continue;
            }

            movies.add(Movie.fromFileString(line));
        }
        br.close();

        return movies;
    }

    // Add movie
    public void addMovie(Movie movie) throws IOException {
        BufferedWriter bw = new BufferedWriter(new FileWriter(filePath, true));
        bw.write(movie.toFileString());
        bw.newLine();
        bw.close();
    }

    // Update movie
    public void updateMovie(Movie updatedMovie) throws IOException {
        List<Movie> movies = getAllMovies();

        BufferedWriter bw = new BufferedWriter(new FileWriter(filePath));

        for (Movie movie : movies) {
            if (movie.getId() == updatedMovie.getId()) {
                bw.write(updatedMovie.toFileString());
            } else {
                bw.write(movie.toFileString());
            }
            bw.newLine();
        }
        bw.close();
    }

    // Delete movie
    public void deleteMovie(int id) throws IOException {
        List<Movie> movies = getAllMovies();

        BufferedWriter bw = new BufferedWriter(new FileWriter(filePath));

        for (Movie movie : movies) {
            if (movie.getId() != id) {
                bw.write(movie.toFileString());
                bw.newLine();
            }
        }
        bw.close();
    }

    // Get movie by ID
    public Movie getMovieById(int id) throws IOException {
        List<Movie> movies = getAllMovies();

        for (Movie movie : movies) {
            if (movie.getId() == id) return movie;
        }
        return null;
    }
}
