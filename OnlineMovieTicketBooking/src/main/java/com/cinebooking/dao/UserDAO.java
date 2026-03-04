package com.cinebooking.dao;

import com.cinebooking.models.User;
import com.cinebooking.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;

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
            // Print the error message to the error console
            System.err.println("Error in register: " + e.getMessage());
        }

        return isSuccess         ;
    }

}