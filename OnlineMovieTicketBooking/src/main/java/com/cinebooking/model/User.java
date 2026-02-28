package com.cinebooking.model;

public abstract class User {

    private String username;
    private String email;
    private String role;

    // Getters and Setters
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    // Abstract method for Polymorphism
    public abstract boolean authenticate(String password);
}