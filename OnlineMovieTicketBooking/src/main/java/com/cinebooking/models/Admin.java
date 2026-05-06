package com.cinebooking.models;

public class Admin extends User {

    public Admin() {
        super();
        this.setRole("Admin");
    }
    //Parameterized constructor to create an Admin object
    public Admin(String name, String email, String password, String mobileNumber, String dob, String gender) {
        super(name, email, password, "Admin", mobileNumber, dob, gender);
    }
    @Override
    public void displayDashboard() {
        System.out.println("Welcome to the Admin Dashboard");

    }
}
