package com.cinebooking.models;


public class Movie {
    private int movie_id;
    private String name;
    private String description;
    private int duration;
    private String director;
    private String category;


    public Movie(int movie_id, String name, String description, int duration, String director, String category) {
        this.movie_id = movie_id;
        this.name = name;
        this.description = description;
        this.duration = duration;
        this.director = director;
        this.category = category;
    }

    public int getMovie_id() {
        return movie_id;
    }

    public void setMovie_id(int movie_id) {
        this.movie_id = movie_id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getDirector() {
        return director;
    }

    public void setDirector(String director) {
        this.director = director;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }
}
