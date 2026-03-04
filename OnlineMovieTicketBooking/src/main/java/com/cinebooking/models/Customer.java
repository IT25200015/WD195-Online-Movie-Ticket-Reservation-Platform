package com.cinebooking.models;

public class Customer extends User {

    public Customer() {
        super();
        this.setRole("Customer");
    }
    //Parameterized constructor to create a Customer object
    public Customer(int userId ,String name ,String email, String password) {
        super(userId, name, email, password, "Customer");
    }
    @Override
    public void displayDashboard() {
        System.out.println("Welcome to the Customer Dashboard");

    }

}
