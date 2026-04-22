package com.cinebooking.models;

public abstract class User {
    // Encapsulation use for data privacy and security
    private int userId;
    private String name;
    private String email;
    private String password;
    private String role; // "customer" or "admin"

    // New fields
    private String mobileNumber;
    private String dob;
    private String gender;

    public User() {

    }
//Parameterized constructor for add user details
    public User(int userId, String name, String email, String password, String role, String mobileNumber, String dob, String gender) {
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = role;
        this.mobileNumber = mobileNumber;
        this.dob = dob;
        this.gender = gender;
    }
// Getters and setters for accessing and modifying user details
    public int getUserId() {
        return userId;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public String getRole() {
        return role;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setEmail(String email) {
        this.email = email;
    }
    public void setPassword(String password) {
        this.password = password;
    }
    public void  setRole(String role) {
        this.role = role;
    }

    public String getMobileNumber() {
        return mobileNumber;
    }
    public void setMobileNumber(String mobileNumber) {
        this.mobileNumber = mobileNumber;
    }
    public String getDob() {
        return dob;
    }
    public void setDob(String dob) {
        this.dob = dob;
    }
    public String getGender() {
        return gender;
    }
    public void setGender(String gender) {
        this.gender = gender;
    }

//Abstraction - Because the dashboadrd changes on user role
    public abstract void displayDashboard();

    public void showUserDetails() {
        System.out.println("User ID: " + userId);
        System.out.println("Name: " + name);
        System.out.println("Email: " + email);
        System.out.println("Role: " + role);
    }

}