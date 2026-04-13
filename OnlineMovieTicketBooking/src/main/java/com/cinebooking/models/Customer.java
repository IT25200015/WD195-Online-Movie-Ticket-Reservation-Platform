package com.cinebooking.models;

public class Customer extends User {

    private String membership;

    public Customer() {
        super();
        this.setRole("Customer");
        this.membership = "Regular";
    }
    //Parameterized constructor to create a Customer object
    public Customer(int userId ,String name ,String email, String password, String mobileNumber, String dob, String gender, String membership) {
        super(userId, name, email, password, "Customer", mobileNumber, dob, gender);
        this.membership = membership;
    }

    public String getMembership() {
        return membership;
    }

    public void setMembership(String membership) {
        this.membership = membership;
    }

    @Override
    public void displayDashboard() {
        System.out.println("Welcome to the Customer Dashboard");

    }

}
