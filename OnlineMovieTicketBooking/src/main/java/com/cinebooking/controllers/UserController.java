package com.cinebooking.controllers;

import com.cinebooking.dao.UserDAO;
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
import java.security.MessageDigest;

@WebServlet("/UserController")
public class UserController extends HttpServlet {

    private static final Object FILE_LOCK = new Object();

    // Hash a plain text password using SHA-256 and return a hex string
    private String hashPassword(String plainText) {
        try {
            // MessageDigest is the built-in Java tool for hashing
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            // Step 1: convert the text to bytes
            byte[] encodedHash = digest.digest(plainText.getBytes(java.nio.charset.StandardCharsets.UTF_8));

            // Step 2: convert each byte to hex (00 - ff)
            StringBuilder hexString = new StringBuilder();
            for (byte b : encodedHash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            // If hashing fails, return null so we can handle it safely
            return null;
        }
    }

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

                String searchQuery = request.getParameter("searchQuery");
                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                    String query = searchQuery.trim().toLowerCase();
                    java.util.List<com.cinebooking.models.User> filteredUsers = new java.util.ArrayList<>();
                    for (com.cinebooking.models.User u : userList) {
                        String name = u.getName() != null ? u.getName().toLowerCase() : "";
                        String email = u.getEmail() != null ? u.getEmail().toLowerCase() : "";
                        if (name.contains(query) || email.contains(query)) {
                            filteredUsers.add(u);
                        }
                    }
                    userList = filteredUsers;
                }

                // Sort so Admin users come first, Customer users come after
                java.util.Collections.sort(userList, new java.util.Comparator<com.cinebooking.models.User>() {
                    @Override
                    public int compare(com.cinebooking.models.User u1, com.cinebooking.models.User u2) {
                        int p1 = "Admin".equals(u1.getRole()) ? 0 : 1;
                        int p2 = "Admin".equals(u2.getRole()) ? 0 : 1;
                        return Integer.compare(p1, p2);
                    }
                });
                // Put the list inside the request object
                request.setAttribute("userList", userList);
                request.getRequestDispatcher("/WEB-INF/views/adminDashboard.jsp").forward(request, response);
            } else {
                // If not Admin, redirect to login
                response.sendRedirect("UserController?action=login");
            }
        } else if ("deleteUserByAdmin".equals(action)) {
            HttpSession session = request.getSession();
            com.cinebooking.models.User loggedUser = (com.cinebooking.models.User) session.getAttribute("user");

            if (loggedUser != null && "Admin".equals(loggedUser.getRole())) {
                String email = request.getParameter("email");
                boolean deleted = false;

                if (email != null && !email.trim().isEmpty()) {
                    String dataFilePath = getServletContext().getRealPath("/data/users.txt");
                    UserDAO userDAO = new UserDAOFile(dataFilePath);
                    deleted = userDAO.deleteUser(email);
                }

                if (deleted) {
                    response.sendRedirect("UserController?action=adminDashboard&msg=deleteSuccess");
                } else {
                    response.sendRedirect("UserController?action=adminDashboard&error=deleteFailed");
                }
            } else {
                response.sendRedirect("UserController?action=login");
            }
        } else if ("toggleMembership".equals(action)) {
            HttpSession session = request.getSession();
            com.cinebooking.models.User loggedUser = (com.cinebooking.models.User) session.getAttribute("user");

            if (loggedUser == null || !"Admin".equals(loggedUser.getRole())) {
                response.sendRedirect("UserController?action=login");
                return;
            }

            String email = request.getParameter("email");
            String status = request.getParameter("status");

            if (email != null && !email.trim().isEmpty() && status != null && !status.trim().isEmpty()) {
                UserDAOFile userDAO = new UserDAOFile();
                userDAO.changeMembership(email, status);
            }

            response.sendRedirect("UserController?action=adminDashboard");
        } else if ("register".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        } else if ("login".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        } else if ("logout".equals(action)) {
            // Get the current session (create if missing)
            HttpSession session = request.getSession();
            // Clear all session data for a clean logout
            session.invalidate();
            // Send the user to the login page with a simple message flag
            response.sendRedirect("UserController?action=login&msg=loggedOut");
        } else {
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // get the action from register or login form
        String action = request.getParameter("action");

        // to test
        System.out.println("Action received: " + action);

        String dataFilePath = getServletContext().getRealPath("/data/users.txt");
        UserDAO userDAO = new UserDAOFile(dataFilePath); // Use this for File storage (users.txt)

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

                // stop registration if the email is already used.
                if (userDAO.isEmailExists(email)) {
                    request.setAttribute("errorMessage", "Email already exists! Please use a different email or login.");
                    request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                    return;
                }

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
                    //customerUser.setMembership("Regular");
                    newUser = customerUser;
                }

                // Apply common properties to the instantiated object (Polymorphism in action)
                newUser.setName(name);
                newUser.setEmail(email);
                newUser.setPassword(password);
                newUser.setMobileNumber(mobileNumber);
                newUser.setDob(dob);
                newUser.setGender(gender);

                // Hash the password before saving
                String hashedPassword = hashPassword(password);
                if (hashedPassword == null) {
                    request.setAttribute("error", "Invalid input");
                    request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                    return;
                }

                newUser.setPassword(hashedPassword);

                // This lock prevents file corruption from concurrent users.
                synchronized (FILE_LOCK) {
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
            }

            //  login an existing user

            else if ("login".equals(action)) {

                // get email and password from login form
                String email = request.getParameter("email");
                String password = request.getParameter("password");

                // Hash the input password before checking the file
                String hashedPassword = hashPassword(password);
                if (hashedPassword == null) {
                    response.sendRedirect("UserController?action=login&error=invalid");
                    return;
                }

                // check database
                com.cinebooking.models.User loggedUser = userDAO.loginUser(email, hashedPassword);

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
                    String newPassword = request.getParameter("password");
                    String mobileNumber = request.getParameter("mobileNumber");
                    String dob = request.getParameter("dob");
                    String gender = request.getParameter("gender");

                    loggedUser.setName(name);
                    loggedUser.setEmail(email);
                    loggedUser.setMobileNumber(mobileNumber);
                    loggedUser.setDob(dob);
                    loggedUser.setGender(gender);

                    // This lock prevents file corruption from concurrent users.
                    synchronized (FILE_LOCK) {
                        // If a new password is provided, hash and store it
                        if (newPassword != null && !newPassword.isEmpty()) {
                            String hashedPassword = hashPassword(newPassword);
                            if (hashedPassword == null) {
                                response.sendRedirect("UserController?action=editProfile&error=1");
                                return;
                            }
                            loggedUser.setPassword(hashedPassword);
                        }
                        // If blank, keep the existing hashed password

                        boolean updated = userDAO.updateUser(loggedUser);
                        if (updated) {
                            session.setAttribute("user", loggedUser);
                            response.sendRedirect("UserController?action=profile&update=success");
                        } else {
                            response.sendRedirect("UserController?action=editProfile&error=1");
                        }
                    }
                } else {
                    response.sendRedirect("UserController?action=login");
                }
                return;
            } else if ("deleteProfile".equals(action)) {
                // Delete the currently logged-in user's profile
                HttpSession session = request.getSession();
                com.cinebooking.models.User loggedUser = (com.cinebooking.models.User) session.getAttribute("user");

                if (loggedUser != null) {
                    String email = loggedUser.getEmail();
                    boolean deleted = userDAO.deleteUser(email);

                    if (deleted) {
                        session.invalidate();
                        response.sendRedirect(request.getContextPath() + "/UserController?action=login&msg=profileDeleted");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/UserController?action=profile&error=delete_failed");
                    }
                } else {
                    response.sendRedirect(request.getContextPath() + "/UserController?action=login");
                }
            } else if ("makePremium".equals(action)) {

                // Get the current user from the session
                HttpSession session = request.getSession();
                User loggedUser = (User) session.getAttribute("user");

                if (loggedUser != null && "Admin".equals(loggedUser.getRole())) {

                    String targetEmail = request.getParameter("email");

                    if (targetEmail != null && !targetEmail.isEmpty()) {
                        java.util.List<User> allUsers = userDAO.getAllUsers();
                        for (User u : allUsers) {

                            if (u.getEmail().trim().equals(targetEmail.trim())) {

                                //  Make sure this user is a Customer (Admins can't be Premium)
                                if (u instanceof Customer) {
                                    Customer customerToUpdate = (Customer) u;
                                    //customerToUpdate.setMembership("Premium");
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
