package com.cinebooking.dao;

import com.cinebooking.models.Admin;
import com.cinebooking.models.Customer;
import com.cinebooking.models.User;
import com.cinebooking.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;

import java.sql.ResultSet;

public class UserDAO {

    // Method to register a new user to the database
    public boolean registerUser(User user) {
        boolean isSuccess = false;

        // SQL query with placeholders
        String sql = "INSERT INTO User (name, email, password, role) VALUES (?, ?, ?, ?)";

        try {
            // Get database connection
            Connection conn = DBConnection.getConnection();
            PreparedStatement pst = conn.prepareStatement(sql);

            // Set values to the query
            pst.setString(1, user.getName());
            pst.setString(2, user.getEmail());
            pst.setString(3, user.getPassword());
            pst.setString(4, user.getRole());

            // Execute the update
            int result = pst.executeUpdate();

            // Check if insertion was successful
            if (result > 0) {
                isSuccess = true;
            }

            // Close connection
            pst.close();
            conn.close();

        } catch (Exception e) {
            // Print the error message
            System.err.println("Error in register: " + e.getMessage());
        }

        return isSuccess         ;
    }
    // Method to login a user
    public User loginUser(String email, String password) {
        User user = null;

        try {
            //   database connection
            Connection conn = DBConnection.getConnection();

            //  SQL query
            String sql = "SELECT * FROM User WHERE email = ? AND password = ?";
            PreparedStatement pst = conn.prepareStatement(sql);

            pst.setString(1, email);
            pst.setString(2, password);

            ResultSet rs = pst.executeQuery();

            // If we found a user in the database
            if (rs.next()) {
                // Get data from the database row
                int dbId = rs.getInt("user_id");
                String dbName = rs.getString("name");
                String dbRole = rs.getString("role");

                // Check the role and create the object
                if (dbRole.equals("ADMIN")) {
                    user = new Admin(dbId, dbName, email, password);
                } else {
                    user = new Customer(dbId, dbName, email, password);
                }
            }

            conn.close();

        } catch (Exception e) {
            System.out.println("Login error: " + e.getMessage());
        }

        // Return null if login failed
        return user;
    }

}