package com.cinebooking.dao;

import com.cinebooking.models.User;

public interface UserDAO {

    boolean registerUser(User user);

    User loginUser(String email, String password);

    boolean updateUser(User user);

    boolean deleteUser(String email);

    java.util.List<User> getAllUsers();
}
