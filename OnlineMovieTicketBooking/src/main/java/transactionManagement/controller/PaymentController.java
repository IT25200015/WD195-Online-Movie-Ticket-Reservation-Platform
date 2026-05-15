package com.cinebooking.controllers;

import com.cinebooking.dao.PaymentDAO;
import com.cinebooking.dao.PaymentDAOFile;
import com.cinebooking.models.CardPayment;
import com.cinebooking.models.Payment;
import com.cinebooking.models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

@WebServlet("/PaymentController")
public class PaymentController extends HttpServlet {

    // Get the payments file path from the server
    private String getFilePath(HttpServletRequest request) {
        return request.getServletContext().getRealPath("/") + "/../data/payments.txt";
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("user");

        // If not logged in, go back to login
        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/UserController?action=login");
            return;
        }

        if ("selectMovie".equals(action)) {
            // Show movie and showtime selection page
            request.getRequestDispatcher("/WEB-INF/views/selectMovie.jsp").forward(request, response);

        } else if ("paymentForm".equals(action)) {
            // Pass seat and movie info to payment page
            request.setAttribute("movieName", request.getParameter("movieName"));
            request.setAttribute("showtime", request.getParameter("showtime"));
            request.setAttribute("seats", request.getParameter("seats"));
            request.setAttribute("total", request.getParameter("total"));
            request.getRequestDispatcher("/WEB-INF/views/paymentForm.jsp").forward(request, response);

        } else if ("myBookings".equals(action)) {
            // Show all payments made by this user
            PaymentDAO paymentDAO = new PaymentDAOFile(getFilePath(request));
            List<Payment> myPayments = paymentDAO.getPaymentsByUser(loggedUser.getEmail());
            request.setAttribute("myPayments", myPayments);
            request.getRequestDispatcher("/WEB-INF/views/myBookings.jsp").forward(request, response);

        } else if ("confirmation".equals(action)) {
            // Show confirmation page
            String txnId = request.getParameter("txnId");
            PaymentDAO paymentDAO = new PaymentDAOFile(getFilePath(request));
            Payment payment = paymentDAO.getPaymentByTransactionId(txnId);
            request.setAttribute("payment", payment);
            request.getRequestDispatcher("/WEB-INF/views/confirmation.jsp").forward(request, response);

        } else if ("adminPayments".equals(action)) {
            // Admin only - see all payments
            if (!"Admin".equals(loggedUser.getRole())) {
                response.sendRedirect(request.getContextPath() + "/UserController?action=login");
                return;
            }
            PaymentDAO paymentDAO = new PaymentDAOFile(getFilePath(request));
            List<Payment> allPayments = paymentDAO.getAllPayments();
            request.setAttribute("allPayments", allPayments);
            request.getRequestDispatcher("/WEB-INF/views/adminPayments.jsp").forward(request, response);

        } else {
            response.sendRedirect(request.getContextPath() + "/PaymentController?action=selectMovie");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("user");

        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/UserController?action=login");
            return;
        }

        if ("processPayment".equals(action)) {

            String movieName     = request.getParameter("movieName");
            String showtime      = request.getParameter("showtime");
            String seats         = request.getParameter("seats");
            String totalStr      = request.getParameter("total");
            String promoCode     = request.getParameter("promoCode");
            String cardHolder    = request.getParameter("cardHolderName");
            String cardNumber    = request.getParameter("cardNumber");
            String cardType      = request.getParameter("cardType");

            // Basic validation - check card fields are filled
            if (cardHolder == null || cardHolder.trim().isEmpty() ||
                    cardNumber == null || cardNumber.replaceAll("\\s", "").length() < 16) {

                request.setAttribute("error", "Please fill in all card details.");
                request.setAttribute("movieName", movieName);
                request.setAttribute("showtime", showtime);
                request.setAttribute("seats", seats);
                request.setAttribute("total", totalStr);
                request.getRequestDispatcher("/WEB-INF/views/paymentForm.jsp").forward(request, response);
                return;
            }

            double total = Double.parseDouble(totalStr);

            // Calculate discount from promo code
            double discount = 0;
            if ("MOVIE10".equalsIgnoreCase(promoCode)) discount = total * 0.10;
            else if ("CINE20".equalsIgnoreCase(promoCode)) discount = total * 0.20;
            double finalAmount = total - discount;

            // Mask card number - only keep last 4 digits
            String raw = cardNumber.replaceAll("\\s", "");
            String maskedCard = "**** **** **** " + raw.substring(raw.length() - 4);

            // Generate unique IDs
            String txnId     = "TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            String bookingId = "BKG" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            String now       = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));

            // Polymorphism - Payment variable holds a CardPayment object
            Payment payment = new CardPayment(
                    txnId, loggedUser.getEmail(), total, discount, finalAmount,
                    "PENDING", now, bookingId,
                    cardHolder, maskedCard, cardType
            );

            // Polymorphism - calls CardPayment's version of processPayment()
            payment.processPayment();

            // Save to file
            PaymentDAO paymentDAO = new PaymentDAOFile(getFilePath(request));
            paymentDAO.savePayment(payment);

            // Go to confirmation page
            response.sendRedirect(request.getContextPath() + "/PaymentController?action=confirmation&txnId=" + txnId);
        }
    }
}
