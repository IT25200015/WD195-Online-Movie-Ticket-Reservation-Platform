package com.cinebooking.models;


public class Movie {
    private int id;
    private String title;
    private String director;
    private int year;
    private String poster;
    private String description;
    private String duration;
    private String trailer;

    public Movie(int id, String title, String director, int year, String poster, String description, String duration, String trailer) {
        this.id = id;
        this.title = title;
        this.director = director;
        this.year = year;
        this.poster = poster;
        this.description = description;
        this.duration = duration;
        this.trailer = trailer;
    }

    public int getId() { return id; }
    public String getTitle() { return title; }
    public String getDirector() { return director; }
    public int getYear() { return year; }

    public void setTitle(String title) { this.title = title; }
    public void setDirector(String director) { this.director = director; }
    public void setYear(int year) { this.year = year; }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public String getTrailer() {
        return trailer;
    }

    public void setTrailer(String trailer) {
        this.trailer = trailer;
    }

    public String getPoster() {
        return poster;
    }

    public void setPoster(String poster) {
        this.poster = poster;
    }

    // Convert to file format
    public String toFileString() {

        return id + ","
                + title + ","
                + director + ","
                + year + ","
                + poster + ","
                + description + ","
                + duration + ","
                + trailer;
    }

    public static Movie fromFileString(String line) {

        String[] parts = line.split(",");

        return new Movie(
                Integer.parseInt(parts[0]),
                parts[1],
                parts[2],
                Integer.parseInt(parts[3]),
                parts[4],
                parts[5],
                parts[6],
                parts[7]
        );
    }
}
