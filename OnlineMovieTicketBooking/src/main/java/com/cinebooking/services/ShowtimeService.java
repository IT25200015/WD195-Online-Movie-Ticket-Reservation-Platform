package com.cinebooking.services;

import com.cinebooking.models.Showtime;

import java.io.*;
import java.util.*;

public class ShowtimeService {

    private final String filePath;

    public ShowtimeService(String filePath) {
        this.filePath = filePath;
    }

    // GET ALL
    public List<Showtime> getAllShowtimes()
            throws IOException {

        List<Showtime> list = new ArrayList<>();

        File file = new File(filePath);

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

        int newId = generateId();

        Showtime newShowtime = new Showtime(
                newId,
                showtime.getMovieId(),
                showtime.getDay(),
                showtime.getTime()
        );

        BufferedWriter bw =
                new BufferedWriter(
                        new FileWriter(filePath, true));

        bw.write(newShowtime.toFileString());
        bw.newLine();

        bw.close();
    }

    // DELETE
    public void deleteShowtime(int id)
            throws IOException {

        List<Showtime> list = getAllShowtimes();

        BufferedWriter bw =
                new BufferedWriter(
                        new FileWriter(filePath));

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
                        new FileWriter(filePath));

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

    private int generateId() {

        List<Showtime> list = null;
        try {
            list = getAllShowtimes();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        int maxId = 0;

        for (Showtime s : list) {
            if (s.getId() > maxId) {
                maxId = s.getId();
            }
        }

        return maxId + 1;
    }

}