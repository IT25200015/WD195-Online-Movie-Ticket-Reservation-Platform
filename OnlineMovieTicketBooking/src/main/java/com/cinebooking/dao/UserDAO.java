package com.cinebooking.dao;

import com.cinebooking.models.User;

import java.util.List;

public interface UserDAO {
    boolean registerUser(User user);

    User loginUser(String email, String password);

    boolean isEmailExists(String email);

    boolean updateUser(User user);

    boolean deleteUser(String email);

    List<User> getAllUsers();

    void changeMembership(String email, String newStatus);

    boolean updateMembership(String email, String newStatus);
}