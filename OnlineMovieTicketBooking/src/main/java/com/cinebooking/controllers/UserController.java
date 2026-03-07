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

            if (("register".equals(action))) {

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

            //  login an existing user

            else if ("login".equals(action)) {

                // get email and password from login form
                String email = request.getParameter("email");
                String password = request.getParameter("password");

                // check database
                com.cinebooking.models.User loggedUser = userDAO.loginUser(email, password);

                if (loggedUser != null) {
                    System.out.println("Login success for: " + loggedUser.getName());

                    // create a session to remember the user
                    jakarta.servlet.http.HttpSession session = request.getSession();
                    session.setAttribute("user", loggedUser);

                    response.sendRedirect("dashboard.jsp"); // Go to dashboard
                } else {
                    System.out.println("Wrong email or password!");
                    response.sendRedirect("login.jsp"); // Go back to login
                }
            }

        } catch (Exception e) {
            System.out.println("Error in Servlet: " + e.getMessage());
        }
    }
}