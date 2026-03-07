package com.cinebooking.controllers;

import com.cinebooking.dao.UserDAO;
import com.cinebooking.models.Customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/UserController")
public class UserController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // get the action from register or login form
        String action = request.getParameter("action");

        // to test
        System.out.println("Action received: " + action);

        UserDAO userDAO = new UserDAO();

        try {
            // register a new user

            if (action.equals("register")) {

                // get values from the object
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String password = request.getParameter("password");

                // create customer object
                Customer newCus = new Customer(0, name, email, password);

                // Save to database
                boolean isSaved = userDAO.registerUser(newCus);

                if (isSaved == true) {
                    System.out.println("User saved successfully!");
                    response.sendRedirect("login.jsp"); // Go to login page
                } else {
                    System.out.println("User save failed!");
                    response.sendRedirect("register.jsp"); // Go back to register
                }
            }

        } catch (Exception e) {
            System.out.println("Error in Servlet: " + e.getMessage());
        }
    }
}