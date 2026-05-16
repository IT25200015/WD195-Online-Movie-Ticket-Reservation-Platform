package cinebooking.services;

import com.cinebooking.models.Movie;

import java.io.*;
import java.util.*;

public class MovieService {
    private static final String FILE_PATH = "data/movies.txt";

    // Read all movies
    public List<Movie> getAllMovies() throws IOException {
        List<Movie> movies = new ArrayList<>();
        File file = new File(FILE_PATH);

        if (!file.exists()) return movies;

        BufferedReader br = new BufferedReader(new FileReader(file));
        String line;

        while ((line = br.readLine()) != null) {
            movies.add(Movie.fromFileString(line));
        }
        br.close();

        return movies;
    }

    // Add movie
    public void addMovie(Movie movie) throws IOException {
        BufferedWriter bw = new BufferedWriter(new FileWriter(FILE_PATH, true));
        bw.write(movie.toFileString());
        bw.newLine();
        bw.close();
    }

    // Update movie
    public void updateMovie(Movie updatedMovie) throws IOException {
        List<Movie> movies = getAllMovies();

        BufferedWriter bw = new BufferedWriter(new FileWriter(FILE_PATH));

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

        BufferedWriter bw = new BufferedWriter(new FileWriter(FILE_PATH));

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
