package com.cinebooking.services;

import com.cinebooking.models.Movie;

import java.io.*;
import java.util.*;

/**
 * CRUD service for movies.txt (comma-separated).
 *
 * Thread-Safety: all write operations are wrapped in synchronized(FILE_LOCK).
 * Data Visibility: the filePath is set from getServletContext().getRealPath()
 *                  so writes always go to the live deployment directory.
 */
public class MovieService {

    // Shared lock — prevents concurrent overwrites from racing servlets
    private static final Object FILE_LOCK = new Object();

    private final String filePath;

    public MovieService(String filePath) {
        this.filePath = filePath;
    }

    /** Returns all movies. Thread-safe via try-with-resources. */
    public List<Movie> getAllMovies() throws IOException {
        List<Movie> movies = new ArrayList<>();
        File file = new File(filePath);
        if (!file.exists()) return movies;

        synchronized (FILE_LOCK) {
            try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = br.readLine()) != null) {
                    if (!line.trim().isEmpty()) {
                        movies.add(Movie.fromFileString(line));
                    }
                }
            }
        }
        return movies;
    }

    /** Appends a new movie to the file. */
    public void addMovie(Movie movie) throws IOException {
        synchronized (FILE_LOCK) {
            try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath, true))) {
                bw.write(movie.toFileString());
                bw.newLine();
                bw.flush();
            }
        }
    }

    /** Rewrites the file replacing the matching movie record. */
    public void updateMovie(Movie updatedMovie) throws IOException {
        synchronized (FILE_LOCK) {
            List<Movie> movies = getAllMoviesUnlocked();
            try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath, false))) {
                for (Movie movie : movies) {
                    bw.write(movie.getId() == updatedMovie.getId()
                            ? updatedMovie.toFileString()
                            : movie.toFileString());
                    bw.newLine();
                }
                bw.flush();
            }
        }
    }

    /** Rewrites the file omitting the movie with the given ID. */
    public void deleteMovie(int id) throws IOException {
        synchronized (FILE_LOCK) {
            List<Movie> movies = getAllMoviesUnlocked();
            try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath, false))) {
                for (Movie movie : movies) {
                    if (movie.getId() != id) {
                        bw.write(movie.toFileString());
                        bw.newLine();
                    }
                }
                bw.flush();
            }
        }
    }

    /** Returns the movie matching the given ID, or null if not found. */
    public Movie getMovieById(int id) throws IOException {
        for (Movie movie : getAllMovies()) {
            if (movie.getId() == id) return movie;
        }
        return null;
    }

    // ── Private helpers ───────────────────────────────────────────────────────

    /**
     * Internal read used inside an already-held FILE_LOCK block.
     * Avoids deadlock since Java's synchronized is NOT re-entrant across threads
     * (though it IS re-entrant for the same thread).
     */
    private List<Movie> getAllMoviesUnlocked() throws IOException {
        List<Movie> movies = new ArrayList<>();
        File file = new File(filePath);
        if (!file.exists()) return movies;
        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (!line.trim().isEmpty()) movies.add(Movie.fromFileString(line));
            }
        }
        return movies;
    }
}
