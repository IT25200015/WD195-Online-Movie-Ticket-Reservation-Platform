package com.cinebooking.dao;

import com.cinebooking.models.User;

public interface UserDAO {

    boolean registerUser(User user);

    User loginUser(String email, String password);

    boolean updateUser(User user);

    boolean updateMembership(String email, String newStatus);

    boolean deleteUser(String email);

    java.util.List<User> getAllUsers();

    boolean isEmailExists(String email);
}
