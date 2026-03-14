package com.cinebooking.dao;

import com.cinebooking.models.Admin;
import com.cinebooking.models.Customer;
import com.cinebooking.models.User;
import com.cinebooking.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;

import java.sql.ResultSet;

public class UserDAODatabase implements  UserDAO  {

    // Method to register a new user to the database
    @Override
    public boolean registerUser(User user) {
        boolean isSuccess = false;

        String sql = "INSERT INTO User (name, email, password, role) VALUES (?, ?, ?, ?)";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pst = conn.prepareStatement(sql);

            // Set values to the query
            pst.setString(1, user.getName());
            pst.setString(2, user.getEmail());
            pst.setString(3, user.getPassword());
            pst.setString(4, user.getRole());

            int result = pst.executeUpdate();

            // Check if insertion was successful
            if (result > 0) {
                isSuccess = true;
            }

            pst.close();
            conn.close();

        } catch (Exception e) {
            System.err.println("Error in register: " + e.getMessage());
        }

        return isSuccess         ;
    }
    // Method to login a user
    @Override
    public User loginUser(String email, String password) {
        User user = null;

        try {
            Connection conn = DBConnection.getConnection();

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


    @Override
    public boolean updateUser(User user) {
        return false;
    }

    @Override
    public boolean deleteUser(String email) {
        return false;
    }
}