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

    private static final String DEFAULT_FILE_PATH = "C:\\Users\\USER\\OneDrive\\Desktop\\WD195-Online-Movie-Ticket-Reservation-Platform\\OnlineMovieTicketBooking\\src\\main\\webapp\\data\\users.txt";
    private final String filePath;

    public UserDAOFile() {
        this.filePath = DEFAULT_FILE_PATH;
    }

    public UserDAOFile(String filePath) {
        this.filePath = (filePath == null || filePath.trim().isEmpty()) ? DEFAULT_FILE_PATH : filePath;
    }

    @Override
    public boolean registerUser(User user) {
        boolean saved = appendUserToFile(new File(filePath), user);

        // Keep source data in sync when running from a deployed path.
        if (!DEFAULT_FILE_PATH.equalsIgnoreCase(filePath)) {
            saved = appendUserToFile(new File(DEFAULT_FILE_PATH), user) || saved;
        }

        return saved;
    }

    private boolean appendUserToFile(File file, User user) {
        // Save the new user without any numeric ID
        try (FileWriter writer = new FileWriter(file, true)) {
            // Check if the user is a Customer using instanceof
            // If it is a Customer, cast it and get the membership
            // If it is an Admin, just write "N/A"
            String membershipValue = "N/A";
            if (user instanceof Customer) {
                Customer customer = (Customer) user;
                membershipValue = customer.getMembership();
            }

            // Name|Email|Password|Role|MobileNumber|DOB|Gender|Membership
            String userData = user.getName() + "|" + user.getEmail() + "|" + user.getPassword() + "|" + user.getRole() + "|" + user.getMobileNumber() + "|" + user.getDob() + "|" + user.getGender() + "|" + membershipValue + "\n";
            writer.write(userData);
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public User loginUser(String email, String password) {
        File file = new File(filePath);

        if (!file.exists()) return null; // No file means no users yet

        try (Scanner scanner = new Scanner(file)) {
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                if (line.trim().isEmpty()) continue;

                String[] parts = line.split("\\|");

                //  Name, Email, Password, Role, MobileNumber, DOB, Gender, Membership
                if (parts.length >= 8) {
                    String name = parts[0];
                    String storedEmail = parts[1];
                    String storedPass = parts[2];
                    String role = parts[3];
                    String mobileNumber = parts[4];
                    String dob = parts[5];
                    String gender = parts[6];
                    String membership = parts[7];

                    // Check if email and password match
                    if (storedEmail.trim().equals(email.trim()) && storedPass.equals(password)) {

                        // Return correct user type (Admin or Customer)
                        if (role.equalsIgnoreCase("Admin")) {
                            return new Admin(name, storedEmail, storedPass, mobileNumber, dob, gender);
                        }
                        return new Customer(name, storedEmail, storedPass, mobileNumber, dob, gender, membership);
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
        boolean updated = updateUserInFile(new File(filePath), user);

        // Keep source data in sync when running from a deployed path.
        if (!DEFAULT_FILE_PATH.equalsIgnoreCase(filePath)) {
            updated = updateUserInFile(new File(DEFAULT_FILE_PATH), user) || updated;
        }

        return updated;
    }

    private boolean updateUserInFile(File file, User user) {
        if (!file.exists()) return false;

        java.util.List<String> lines = new java.util.ArrayList<>();
        boolean updated = false;
        String inputEmail = user.getEmail().trim();

        try (Scanner scanner = new Scanner(file)) {
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                if (line.trim().isEmpty()) continue;

                String[] parts = line.split("\\|");
                if (parts.length >= 2) {
                    String storedEmail = parts[1].trim();
                    if (storedEmail.equals(inputEmail)) {
                        String membershipValue = "N/A";
                        // If the user is a Customer, get the membership
                        if (user instanceof Customer) {
                            Customer customer = (Customer) user;
                            membershipValue = customer.getMembership();
                        }

                        // Update with new data
                        String updatedLine = user.getName() + "|" + user.getEmail() + "|" + user.getPassword() + "|" + user.getRole() + "|" + user.getMobileNumber() + "|" + user.getDob() + "|" + user.getGender() + "|" + membershipValue;
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
            try (FileWriter writer = new FileWriter(file, false)) {
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
        if (email == null || email.trim().isEmpty()) {
            return false;
        }

        String normalizedEmail = email.trim();
        boolean deleted = deleteUserFromFile(new File(filePath), normalizedEmail);

        // Keep source data in sync when running from a deployed path.
        if (!DEFAULT_FILE_PATH.equalsIgnoreCase(filePath)) {
            deleted = deleteUserFromFile(new File(DEFAULT_FILE_PATH), normalizedEmail) || deleted;
        }

        return deleted;
    }

    private boolean deleteUserFromFile(File file, String normalizedEmail) {
        if (!file.exists()) return false;

        java.util.List<String> lines = new java.util.ArrayList<>();
        boolean deleted = false;

        try (Scanner scanner = new Scanner(file)) {
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                if (line.trim().isEmpty()) continue;

                String[] parts = line.split("\\|");
                if (parts.length >= 2) {
                    String storedEmail = parts[1].trim();
                    if (storedEmail.equals(normalizedEmail)) {
                        deleted = true;
                        continue;
                    }
                }
                lines.add(line);
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            return false;
        }

        if (deleted) {
            try (FileWriter writer = new FileWriter(file, false)) {
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
    public java.util.List<User> getAllUsers() {
        java.util.List<User> users = new java.util.ArrayList<>();
        File file = new File(filePath);
        if (!file.exists()) return users;

        try (Scanner scanner = new Scanner(file)) {
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                if (line.trim().isEmpty()) continue;

                String[] parts = line.split("\\|");
                if (parts.length >= 8) {
                    String name = parts[0];
                    String emailStr = parts[1];
                    String pass = parts[2];
                    String role = parts[3];
                    String mobile = parts[4];
                    String dob = parts[5];
                    String gender = parts[6];
                    String authLevel = parts[7];

                    if (role.equalsIgnoreCase("Admin")) {
                        users.add(new Admin(name, emailStr, pass, mobile, dob, gender));
                    } else {
                        users.add(new Customer(name, emailStr, pass, mobile, dob, gender, authLevel));
                    }
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return users;
    }
}
