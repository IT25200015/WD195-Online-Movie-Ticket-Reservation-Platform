package com.cinebooking.models;

public class Admin extends User {

    public Admin() {
        super();
        this.setRole("Admin");
    }
    //Parameterized constructor to create an Admin object
    public Admin(int userId ,String name ,String email, String password) {
        super(userId, name, email, password, "Admin");
    }
    @Override
    public void displayDashboard() {
        System.out.println("Welcome to the Admin Dashboard");

    }
}

