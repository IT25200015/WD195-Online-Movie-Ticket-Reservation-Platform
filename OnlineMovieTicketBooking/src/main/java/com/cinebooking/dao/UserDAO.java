package com.cinebooking.dao;

import com.cinebooking.models.Admin;
import com.cinebooking.models.Customer;
import com.cinebooking.models.User;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // Pointing directly to the absolute project path so changes show up in IntelliJ
    // instead of Tomcat's temporary deployment webapps folder.
    private static final String FILE_PATH = "/Users/lakshithadilshan/Downloads/WD195-Online-Movie-Ticket-Reservation-Platform-main/OnlineMovieTicketBooking/data/users.txt";

    public UserDAO() {
        ensureFileExists();
    }

    private void ensureFileExists() {
        File file = new File(FILE_PATH);
        if (!file.exists()) {
            file.getParentFile().mkdirs();
            try {
                file.createNewFile();
            } catch (IOException e) {
                System.err.println("Error creating users.txt: " + e.getMessage());
            }
        }
    }

    private int getNextId() {
        int maxId = 0;
        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if(line.trim().isEmpty()) continue;
                String[] parts = line.split(",");
                int id = Integer.parseInt(parts[0]);
                if (id > maxId) {
                    maxId = id;
                }
            }
        } catch (Exception e) {
            System.err.println("Error reading users.txt to find max ID: " + e.getMessage());
        }
        return maxId + 1;
    }

    // Method to register a new user to the text database
    public boolean registerUser(User user) {
        ensureFileExists();

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH, true))) {
            int newId = getNextId();
            user.setUserId(newId);
            
            String line = newId + "," + user.getName() + "," + user.getEmail() + "," + user.getPassword() + "," + user.getRole();
            writer.write(line);
            writer.newLine();
            return true;
        } catch (IOException e) {
            System.err.println("Error registering user to text file: " + e.getMessage());
        }
        return false;
    }

    // Method to login a user from text database
    public User loginUser(String email, String password) {
        ensureFileExists();
        
        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if(line.trim().isEmpty()) continue;
                
                String[] parts = line.split(",");
                if(parts.length >= 5) {
                    int dbId = Integer.parseInt(parts[0]);
                    String dbName = parts[1];
                    String dbEmail = parts[2];
                    String dbPassword = parts[3];
                    String dbRole = parts[4];
                    
                    if (dbEmail.equals(email) && dbPassword.equals(password)) {
                        if (dbRole.equalsIgnoreCase("Admin")) {
                            return new Admin(dbId, dbName, dbEmail, dbPassword);
                        } else {
                            return new Customer(dbId, dbName, dbEmail, dbPassword);
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Login error from text file: " + e.getMessage());
        }
        return null;
    }
}