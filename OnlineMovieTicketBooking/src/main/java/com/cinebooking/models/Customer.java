package com.cinebooking.models;

public class Customer extends User {

    private String membership;

    // Tracks whether the user has requested a premium upgrade.
    // Values: "None" (default), "Pending" (requested, awaiting admin action)
    private String premiumRequest;

    public Customer() {
        super();
        this.setRole("Customer");
        this.membership = "Regular";
        this.premiumRequest = "None";
    }

    // Parameterized constructor used when loading from file (8-field legacy rows)
    public Customer(String name, String email, String password, String mobileNumber, String dob, String gender, String membership) {
        super(name, email, password, "Customer", mobileNumber, dob, gender);
        this.membership = membership;
        this.premiumRequest = "None";
    }

    // Parameterized constructor used when loading from file (9-field rows with premiumRequest)
    public Customer(String name, String email, String password, String mobileNumber, String dob, String gender, String membership, String premiumRequest) {
        super(name, email, password, "Customer", mobileNumber, dob, gender);
        this.membership = membership;
        this.premiumRequest = (premiumRequest != null && !premiumRequest.trim().isEmpty()) ? premiumRequest.trim() : "None";
    }

    public String getMembership() {
        return membership;
    }

    public void setMembership(String membership) {
        this.membership = membership;
    }

    public String getPremiumRequest() {
        return premiumRequest;
    }

    public void setPremiumRequest(String premiumRequest) {
        this.premiumRequest = (premiumRequest != null && !premiumRequest.trim().isEmpty()) ? premiumRequest.trim() : "None";
    }

    @Override
    public void displayDashboard() {
        System.out.println("Welcome to the Customer Dashboard");
    }

}
