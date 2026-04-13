package com.cinebooking.dao;

import com.cinebooking.models.Admin;
import com.cinebooking.models.Customer;
import com.cinebooking.models.User;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;

public class UserDAOFile implements UserDAO {

    private static final String FILE_PATH = "C:\\Users\\USER\\OneDrive\\Desktop\\WD195-Online-Movie-Ticket-Reservation-Platform\\OnlineMovieTicketBooking\\src\\main\\webapp\\data\\users.txt";

    @Override
    public boolean registerUser(User user) {
        int newId = 1;
        File file = new File(FILE_PATH);

        //  Read the file to find the highest ID currently used
        if (file.exists()) {
            try (Scanner scanner = new Scanner(file)) {
                while (scanner.hasNextLine()) {
                    String line = scanner.nextLine();
                    if (line.trim().isEmpty()) continue;

                    String[] parts = line.split("\\|");

                    if (parts.length >= 1) {
                        try {
                            // The ID is the first part
                            int currentId = Integer.parseInt(parts[0]);
                            if (currentId >= newId) {
                                newId = currentId + 1; // Increment ID
                            }
                        } catch (NumberFormatException e) {
                        }
                    }
                }
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            }
        }

        // Save the new user with the generated ID
        try (FileWriter writer = new FileWriter(FILE_PATH, true)) {
            // Check if the user is a Customer using instanceof
            // If it is a Customer, cast it and get the membership
            // If it is an Admin, just write "N/A"
            String membershipValue = "N/A";
            if (user instanceof Customer) {
                Customer customer = (Customer) user;
                membershipValue = customer.getMembership();
            }

            // ID|Name|Email|Password|Role|MobileNumber|DOB|Gender|Membership
            String userData = newId + "|" + user.getName() + "|" + user.getEmail() + "|" + user.getPassword() + "|" + user.getRole() + "|" + user.getMobileNumber() + "|" + user.getDob() + "|" + user.getGender() + "|" + membershipValue + "\n";
            writer.write(userData);
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public User loginUser(String email, String password) {
        File file = new File(FILE_PATH);

        if (!file.exists()) return null; // No file means no users yet

        try (Scanner scanner = new Scanner(file)) {
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                if (line.trim().isEmpty()) continue;

                String[] parts = line.split("\\|");

                //  ID, Name, Email, Password, Role, MobileNumber, DOB, Gender, Membership
                if (parts.length >= 9) {
                    int userId = Integer.parseInt(parts[0]); // Get ID from file
                    String name = parts[1];
                    String storedEmail = parts[2];
                    String storedPass = parts[3];
                    String role = parts[4];
                    String mobileNumber = parts[5];
                    String dob = parts[6];
                    String gender = parts[7];
                    String membership = parts[8];

                    // Check if email and password match
                    if (storedEmail.equals(email) && storedPass.equals(password)) {

                        // Return correct user type (Admin or Customer)
                        if (role.equalsIgnoreCase("Admin")) {
                            return new Admin(userId, name, storedEmail, storedPass, mobileNumber, dob, gender);
                        }
                        return new Customer(userId, name, storedEmail, storedPass, mobileNumber, dob, gender, membership);
                    }
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return null; // Login failed
    }

    @Override
    public boolean updateUser(User user) {
        File file = new File(FILE_PATH);
        if (!file.exists()) return false;

        java.util.List<String> lines = new java.util.ArrayList<>();
        boolean updated = false;

        try (Scanner scanner = new Scanner(file)) {
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                if (line.trim().isEmpty()) continue;

                String[] parts = line.split("\\|");
                if (parts.length >= 5) {
                    int id = Integer.parseInt(parts[0]);
                    if (id == user.getUserId()) {
                        String membershipValue = "N/A";
                        // If the user is a Customer, get the membership
                        if (user instanceof Customer) {
                            Customer customer = (Customer) user;
                            membershipValue = customer.getMembership();
                        }

                        // Update with new data
                        String updatedLine = id + "|" + user.getName() + "|" + user.getEmail() + "|" + user.getPassword() + "|" + user.getRole() + "|" + user.getMobileNumber() + "|" + user.getDob() + "|" + user.getGender() + "|" + membershipValue;
                        lines.add(updatedLine);
                        updated = true;
                    } else {
                        lines.add(line);
                    }
                } else {
                    lines.add(line);
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            return false;
        }

        if (updated) {
            try (FileWriter writer = new FileWriter(FILE_PATH, false)) {
                for (String l : lines) {
                    writer.write(l + "\n");
                }
                return true;
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        return false;
    }

    @Override
    public boolean deleteUser(String email) {
        return false;
    }
}
