package com.cinebooking.services;

import com.cinebooking.models.Showtime;

import java.io.*;
import java.util.*;

public class ShowtimeService {

    // Everyone change this file path to the file path in your machine
    private static final String FILE_PATH = "C:\\Users\\ASUS\\OneDrive\\Desktop\\WD195-Online-Movie-Ticket-Reservation-Platform\\OnlineMovieTicketBooking\\src\\main\\webapp\\data\\showtimes.txt";

    // GET ALL
    public List<Showtime> getAllShowtimes()
            throws IOException {

        List<Showtime> list = new ArrayList<>();

        File file = new File(FILE_PATH);

        if (!file.exists()) return list;

        BufferedReader br =
                new BufferedReader(new FileReader(file));

        String line;

        while ((line = br.readLine()) != null) {

            list.add(
                    Showtime.fromFileString(line)
            );
        }

        br.close();

        return list;
    }

    // GET BY MOVIE ID
    public List<Showtime> getShowtimesByMovieId(int movieId)
            throws IOException {

        List<Showtime> result = new ArrayList<>();

        for (Showtime s : getAllShowtimes()) {

            if (s.getMovieId() == movieId) {
                result.add(s);
            }
        }

        return result;
    }

    // ADD
    public void addShowtime(Showtime showtime)
            throws IOException {

        BufferedWriter bw =
                new BufferedWriter(
                        new FileWriter(FILE_PATH, true));

        bw.write(showtime.toFileString());
        bw.newLine();

        bw.close();
    }

    // DELETE
    public void deleteShowtime(int id)
            throws IOException {

        List<Showtime> list = getAllShowtimes();

        BufferedWriter bw =
                new BufferedWriter(
                        new FileWriter(FILE_PATH));

        for (Showtime s : list) {

            if (s.getId() != id) {

                bw.write(s.toFileString());
                bw.newLine();
            }
        }

        bw.close();
    }

    // UPDATE
    public void updateShowtime(Showtime updated)
            throws IOException {

        List<Showtime> list = getAllShowtimes();

        BufferedWriter bw =
                new BufferedWriter(
                        new FileWriter(FILE_PATH));

        for (Showtime s : list) {

            if (s.getId() == updated.getId()) {

                bw.write(updated.toFileString());
            }
            else {

                bw.write(s.toFileString());
            }

            bw.newLine();
        }

        bw.close();
    }
}