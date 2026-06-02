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

    private final String filePath;
    private java.util.List<User> cachedUsers;

    @Override
    public boolean updateMembership(String email, String newStatus) {
        if (email == null || email.trim().isEmpty() || newStatus == null || newStatus.trim().isEmpty()) {
            return false;
        }

        String normalizedEmail = email.trim();
        String normalizedStatus = newStatus.trim();
        boolean updated = updateMembershipInFile(new File(filePath), normalizedEmail, normalizedStatus);

        if (updated && cachedUsers != null) {
            for (User user : cachedUsers) {
                if (user.getEmail() != null
                        && user.getEmail().trim().equalsIgnoreCase(normalizedEmail)
                        && user instanceof Customer) {
                    ((Customer) user).setMembership(normalizedStatus);
                    break;
                }
            }
        }

        return updated;
    }

    public UserDAOFile(String filePath) {
        if (filePath == null || filePath.trim().isEmpty()) {
            throw new IllegalArgumentException("filePath is required");
        }
        this.filePath = filePath;
    }

    @Override
    public boolean registerUser(User user) {
        boolean saved = appendUserToFile(new File(filePath), user);

        return saved;
    }

    @Override
    public boolean isEmailExists(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }

        String normalizedEmail = email.trim();

        // Check the active file first.
        if (isEmailInFile(new File(filePath), normalizedEmail)) {
            return true;
        }

        return false;
    }

    private boolean isEmailInFile(File file, String normalizedEmail) {
        if (!file.exists()) {
            return false;
        }

        try (Scanner scanner = new Scanner(file)) {
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                if (line.trim().isEmpty()) {
                    continue;
                }

                String[] parts = line.split("\\|");
                if (parts.length >= 2) {
                    String storedEmail = parts[1].trim();
                    // Case-insensitive match for safer duplicate checks.
                    if (storedEmail.equalsIgnoreCase(normalizedEmail)) {
                        return true;
                    }
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }

        return false;
    }

    private boolean appendUserToFile(File file, User user) {
        // Save the new user without any numeric ID
        try (FileWriter writer = new FileWriter(file, true)) {
            // Determine membership and premiumRequest values
            String membershipValue = "N/A";
            String premiumRequestValue = "None";
            if (user instanceof Customer) {
                Customer customer = (Customer) user;
                membershipValue = customer.getMembership();
                premiumRequestValue = customer.getPremiumRequest() != null ? customer.getPremiumRequest() : "None";
            }

            // Name|Email|Password|Role|MobileNumber|DOB|Gender|Membership|PremiumRequest
            String userData = user.getName() + "|" + user.getEmail() + "|" + user.getPassword() + "|" + user.getRole() + "|" + user.getMobileNumber() + "|" + user.getDob() + "|" + user.getGender() + "|" + membershipValue + "|" + premiumRequestValue + "\n";
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

                // Name|Email|Password|Role|MobileNumber|DOB|Gender|Membership|PremiumRequest (9-field)
                // Also handles legacy 8-field rows gracefully.
                if (parts.length >= 8) {
                    String name = parts[0];
                    String storedEmail = parts[1];
                    String storedPass = parts[2];
                    String role = parts[3];
                    String mobileNumber = parts[4];
                    String dob = parts[5];
                    String gender = parts[6];
                    String membership = parts[7];
                    // 9th field is optional for backwards compatibility
                    String premiumRequest = (parts.length >= 9) ? parts[8] : "None";

                    // Check if email and password match
                    if (storedEmail.trim().equals(email.trim()) && storedPass.equals(password)) {

                        // Return correct user type (Admin or Customer)
                        if (role.equalsIgnoreCase("Admin")) {
                            return new Admin(name, storedEmail, storedPass, mobileNumber, dob, gender);
                        }
                        return new Customer(name, storedEmail, storedPass, mobileNumber, dob, gender, membership, premiumRequest);
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

        return updated;
    }

    @Override
    public void changeMembership(String email, String newStatus) {
        updateMembership(email, newStatus);
    }

    private boolean updateMembershipInFile(File file, String email, String newStatus) {
        if (!file.exists()) return false;

        java.util.List<String> lines = new java.util.ArrayList<>();
        boolean updated = false;
        String inputEmail = email.trim();

        try (Scanner scanner = new Scanner(file)) {
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                if (line.trim().isEmpty()) continue;

                String[] parts = line.split("\\|");
                if (parts.length >= 8) {
                    String storedEmail = parts[1].trim();
                    if (storedEmail.equalsIgnoreCase(inputEmail)) {
                        parts[7] = newStatus.trim();
                        // When admin changes membership, reset premiumRequest to "None"
                        // (the pending badge should disappear once the admin has acted)
                        String premiumReq = (parts.length >= 9) ? parts[8] : "None";
                        // If membership is being upgraded/changed by admin, clear the pending flag
                        premiumReq = "None";
                        String updatedLine = parts[0] + "|" + parts[1] + "|" + parts[2] + "|" + parts[3] + "|" + parts[4] + "|" + parts[5] + "|" + parts[6] + "|" + parts[7] + "|" + premiumReq;
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
                        String premiumRequestValue = "None";
                        // If the user is a Customer, get the membership and premiumRequest
                        if (user instanceof Customer) {
                            Customer customer = (Customer) user;
                            membershipValue = customer.getMembership();
                            premiumRequestValue = customer.getPremiumRequest() != null ? customer.getPremiumRequest() : "None";
                        }

                        // Update with new data — preserve premiumRequest from the model object
                        String updatedLine = user.getName() + "|" + user.getEmail() + "|" + user.getPassword() + "|" + user.getRole() + "|" + user.getMobileNumber() + "|" + user.getDob() + "|" + user.getGender() + "|" + membershipValue + "|" + premiumRequestValue;
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
    public boolean updatePremiumRequest(String email, String requestStatus) {
        if (email == null || email.trim().isEmpty() || requestStatus == null || requestStatus.trim().isEmpty()) {
            return false;
        }

        String normalizedEmail = email.trim();
        String normalizedStatus = requestStatus.trim();
        boolean updated = updatePremiumRequestInFile(new File(filePath), normalizedEmail, normalizedStatus);

        // Keep the in-memory cache in sync
        if (updated && cachedUsers != null) {
            for (User user : cachedUsers) {
                if (user.getEmail() != null
                        && user.getEmail().trim().equalsIgnoreCase(normalizedEmail)
                        && user instanceof Customer) {
                    ((Customer) user).setPremiumRequest(normalizedStatus);
                    break;
                }
            }
        }

        return updated;
    }

    private boolean updatePremiumRequestInFile(File file, String email, String requestStatus) {
        if (!file.exists()) return false;

        java.util.List<String> lines = new java.util.ArrayList<>();
        boolean updated = false;
        String inputEmail = email.trim();

        try (Scanner scanner = new Scanner(file)) {
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                if (line.trim().isEmpty()) continue;

                String[] parts = line.split("\\|");
                if (parts.length >= 8) {
                    String storedEmail = parts[1].trim();
                    if (storedEmail.equalsIgnoreCase(inputEmail)) {
                        // Reconstruct with updated premiumRequest (9th field)
                        String membership = parts[7];
                        String updatedLine = parts[0] + "|" + parts[1] + "|" + parts[2] + "|" + parts[3] + "|" + parts[4] + "|" + parts[5] + "|" + parts[6] + "|" + membership + "|" + requestStatus.trim();
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
                    // 9th field optional — defaults to "None" for legacy 8-field rows
                    String premiumRequest = (parts.length >= 9) ? parts[8] : "None";

                    if (role.equalsIgnoreCase("Admin")) {
                        users.add(new Admin(name, emailStr, pass, mobile, dob, gender));
                    } else {
                        users.add(new Customer(name, emailStr, pass, mobile, dob, gender, authLevel, premiumRequest));
                    }
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }

        this.cachedUsers = users;
        return users;
    }
}
