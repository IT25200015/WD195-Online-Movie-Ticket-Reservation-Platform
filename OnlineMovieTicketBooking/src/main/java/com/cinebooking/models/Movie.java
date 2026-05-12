package com.cinebooking.models;


public class Movie {
    private int id;
    private String title;
    private String director;
    private int year;
    private String poster;

    public Movie(int id, String title, String director, int year, String poster) {
        this.id = id;
        this.title = title;
        this.director = director;
        this.year = year;
        this.poster = poster;
    }

    public int getId() { return id; }
    public String getTitle() { return title; }
    public String getDirector() { return director; }
    public int getYear() { return year; }

    public void setTitle(String title) { this.title = title; }
    public void setDirector(String director) { this.director = director; }
    public void setYear(int year) { this.year = year; }

    public String getPoster() {
        return poster;
    }

    public void setPoster(String poster) {
        this.poster = poster;
    }

    // Convert to file format
    public String toFileString() {
        return id + "," + title + "," + director + "," + year + "," + poster;
    }

    public static Movie fromFileString(String line) {

        String[] parts = line.split(",");

        return new Movie(
                Integer.parseInt(parts[0]),
                parts[1],
                parts[2],
                Integer.parseInt(parts[3]),
                parts[4]
        );
    }
}
