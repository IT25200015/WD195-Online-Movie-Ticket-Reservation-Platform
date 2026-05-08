package com.cinebooking.services;

import com.cinebooking.models.Showtime;

import java.io.*;
import java.util.*;

public class ShowtimeService {
    private static final String FILE_PATH = "data/showtimes.txt";

    // Read all showtimes
    public List<Showtime> getAllShowtimes() throws IOException {
        List<Showtime> showtimes = new ArrayList<>();
        File file = new File(FILE_PATH);

        if (!file.exists()) return showtimes;

        BufferedReader br = new BufferedReader(new FileReader(file));
        String line;

        while ((line = br.readLine()) != null) {
            showtimes.add(Showtime.fromFileString(line));
        }
        br.close();

        return showtimes;
    }

    // Add showtime
    public void addShowtime(Showtime showtime) throws IOException {
        BufferedWriter bw = new BufferedWriter(new FileWriter(FILE_PATH, true));
        bw.write(showtime.toFileString());
        bw.newLine();
        bw.close();
    }

    // Update showtime
    public void updateShowtime(Showtime updatedShowtime) throws IOException {
        List<Showtime> showtimes = getAllShowtimes();

        BufferedWriter bw = new BufferedWriter(new FileWriter(FILE_PATH));

        for (Showtime s : showtimes) {
            if (s.getShowtime_id() == updatedShowtime.getShowtime_id()) {
                bw.write(updatedShowtime.toFileString());
            } else {
                bw.write(s.toFileString());
            }
            bw.newLine();
        }
        bw.close();
    }

    // Delete showtime
    public void deleteShowtime(int id) throws IOException {
        List<Showtime> showtimes = getAllShowtimes();

        BufferedWriter bw = new BufferedWriter(new FileWriter(FILE_PATH));

        for (Showtime s : showtimes) {
            if (s.getShowtime_id() != id) {
                bw.write(s.toFileString());
                bw.newLine();
            }
        }
        bw.close();
    }

    // Get showtime by ID
    public Showtime getShowtimeById(int id) throws IOException {
        List<Showtime> showtimes = getAllShowtimes();

        for (Showtime s : showtimes) {
            if (s.getShowtime_id() == id) return s;
        }
        return null;
    }

    // Get showtimes by movie ID
    public List<Showtime> getShowtimesByMovieId(int movieId) throws IOException {
        List<Showtime> result = new ArrayList<>();
        List<Showtime> showtimes = getAllShowtimes();

        for (Showtime s : showtimes) {
            if (s.getMovie_id() == movieId) {
                result.add(s);
            }
        }
        return result;
    }
}
