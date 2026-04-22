package com.cinebooking.controllers;

import com.cinebooking.dao.UserDAO;
import com.cinebooking.dao.UserDAODatabase;
import com.cinebooking.dao.UserDAOFile;
import com.cinebooking.models.Admin;
import com.cinebooking.models.Customer;
import com.cinebooking.models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;



@WebServlet("/UserController")
public class UserController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("profile".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
        } else if ("editProfile".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/views/editProfile.jsp").forward(request, response);
        } else if ("adminDashboard".equals(action)) {
            // Check if user is logged in and is an Admin
            HttpSession session = request.getSession();
            com.cinebooking.models.User loggedUser = (com.cinebooking.models.User) session.getAttribute("user");

            if (loggedUser != null && "Admin".equals(loggedUser.getRole())) {
                UserDAO userDAO = new UserDAOFile();
                java.util.List<com.cinebooking.models.User> userList = userDAO.getAllUsers();
                // Put the list inside the request object
                request.setAttribute("userList", userList);
                request.getRequestDispatcher("/WEB-INF/views/adminDashboard.jsp").forward(request, response);
            } else {
                // If not Admin, redirect to login
                response.sendRedirect("UserController?action=login");
            }
        } else if ("register".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        } else if ("login".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // get the action from register or login form
        String action = request.getParameter("action");

        // to test
        System.out.println("Action received: " + action);

         UserDAO userDAO = new UserDAOFile(); // Use this for File stroage (users.txt)
       // UserDAO userDAO = new UserDAODatabase(); // Use this for Database storage

        try {
            // register a new user

            if (("register".equals(action))) {

                // get values from the object
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String mobileNumber = request.getParameter("mobileNumber");
                String dob = request.getParameter("dob");
                String gender = request.getParameter("gender");
                String adminKey = request.getParameter("adminKey");

                User newUser; // Polymorphism: Base class reference can point to subclass objects

                if ("SLIIT2026".equals(adminKey)) {
                    // Create an Admin using the default constructor
                    Admin adminUser = new Admin();
                    adminUser.setRole("Admin");
                    newUser = adminUser;
                } else {
                    // Create a Customer using the default constructor
                    Customer customerUser = new Customer();
                    customerUser.setRole("Customer");
                    customerUser.setMembership("Regular");
                    newUser = customerUser;
                }

                // Apply common properties to the instantiated object (Polymorphism in action)
                newUser.setName(name);
                newUser.setEmail(email);
                newUser.setPassword(password);
                newUser.setMobileNumber(mobileNumber);
                newUser.setDob(dob);
                newUser.setGender(gender);

                // Save to database
                boolean isSaved = userDAO.registerUser(newUser);

                if (isSaved == true) {
                    System.out.println("User saved successfully!");
                    response.sendRedirect(request.getContextPath() + "/UserController?action=login"); // Go to login page
                } else {
                    System.out.println("User save failed!");
                    response.sendRedirect(request.getContextPath() + "/UserController?action=register&error=1"); // Go back to register
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
                    // Get the current session
                    HttpSession session = request.getSession();

                    // Save the user object in the session so it's available everywhere
                    session.setAttribute("user", loggedUser);

                    // Check if user is Admin or Regular to redirect
                    if (loggedUser.getRole().equalsIgnoreCase("Admin")) {
                        response.sendRedirect("UserController?action=adminDashboard");
                    } else {
                        response.sendRedirect("UserController?action=profile");
                    }
                } else {
                    // If login fails, send back with error message
                    response.sendRedirect("UserController?action=login&error=invalid");
                }
            } else if ("update".equals(action)) {
                HttpSession session = request.getSession();
                com.cinebooking.models.User loggedUser = (com.cinebooking.models.User) session.getAttribute("user");

                if (loggedUser != null) {
                    String name = request.getParameter("name");
                    String email = request.getParameter("email");
                    String password = request.getParameter("password");
                    String mobileNumber = request.getParameter("mobileNumber");
                    String dob = request.getParameter("dob");
                    String gender = request.getParameter("gender");

                    loggedUser.setName(name);
                    loggedUser.setEmail(email);
                    if (password != null && !password.isEmpty()) {
                        loggedUser.setPassword(password);
                    }
                    loggedUser.setMobileNumber(mobileNumber);
                    loggedUser.setDob(dob);
                    loggedUser.setGender(gender);

                    boolean updated = userDAO.updateUser(loggedUser);
                    if (updated) {
                        session.setAttribute("user", loggedUser);
                        response.sendRedirect("UserController?action=profile&update=success");
                    } else {
                        response.sendRedirect("UserController?action=editProfile&error=1");
                    }
                } else {
                    response.sendRedirect("UserController?action=login");
                }
            } else if ("makePremium".equals(action)) {

                // Get the current user from the session
                HttpSession session = request.getSession();
                User loggedUser = (User) session.getAttribute("user");

                if (loggedUser != null && "Admin".equals(loggedUser.getRole())) {

                    String targetUserId = request.getParameter("userId");

                    if (targetUserId != null && !targetUserId.isEmpty()) {
                        int id = Integer.parseInt(targetUserId);
                        java.util.List<User> allUsers = userDAO.getAllUsers();
                        for (User u : allUsers) {

                            if (u.getUserId() == id) {

                                //  Make sure this user is a Customer (Admins can't be Premium)
                                if (u instanceof Customer) {
                                    Customer customerToUpdate = (Customer) u;
                                    customerToUpdate.setMembership("Premium");
                                    // Save the updated customer back to the file
                                    userDAO.updateUser(customerToUpdate);
                                }
                                break;
                            }
                        }
                    }
                    // Send the Admin back to the dashboard to see the changes
                    response.sendRedirect("UserController?action=adminDashboard");
                } else {
                    // Not an admin? Send them to the login page
                    response.sendRedirect("UserController?action=login");
                }
            }

        } catch (Exception e) {
            System.out.println("Error in Servlet: " + e.getMessage());
        }
    }
}