package com.cinebooking.models;

public class Showtime {

    private int id;
    private int movieId;
    private String day;
    private String time;

    public Showtime(int id, int movieId,
                    String day, String time) {

        this.id = id;
        this.movieId = movieId;
        this.day = day;
        this.time = time;
    }

    public int getId() {
        return id;
    }

    public int getMovieId() {
        return movieId;
    }

    public String getDay() {
        return day;
    }

    public String getTime() {
        return time;
    }

    public void setDay(String day) {
        this.day = day;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String toFileString() {

        return id + "," +
                movieId + "," +
                day + "," +
                time;
    }

    public static Showtime fromFileString(String line) {

        String[] parts = line.split(",");

        return new Showtime(
                Integer.parseInt(parts[0]),
                Integer.parseInt(parts[1]),
                parts[2],
                parts[3]
        );
    }
}