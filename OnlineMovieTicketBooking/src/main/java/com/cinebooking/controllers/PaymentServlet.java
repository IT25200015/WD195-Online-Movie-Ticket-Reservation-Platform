package com.cinebooking.controllers;

import com.cinebooking.dao.PaymentDAO;
import com.cinebooking.dao.PaymentDAOFile;
import com.cinebooking.models.CardPayment;
import com.cinebooking.models.Payment;
import com.cinebooking.models.User; // ← correct User import

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

@WebServlet("/payment")  // ← lowercase, matches the style of /booking
public class PaymentServlet extends HttpServlet {

    private String paymentsFilePath;

    @Override
    public void init() throws ServletException {
        // ← same pattern as BookingServlet.init()
        paymentsFilePath = getServletContext().getRealPath("/data/payments.txt");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Object sessionUser = session != null ? session.getAttribute("user") : null;

        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/UserController?action=login");
            return;
        }

        User loggedUser = (User) sessionUser;
        String action = request.getParameter("action");
        PaymentDAO paymentDAO = new PaymentDAOFile(paymentsFilePath);

        if ("paymentForm".equals(action)) {
            // Pass booking info to payment page
            request.setAttribute("movieName", request.getParameter("movieName"));
            request.setAttribute("showtime",  request.getParameter("showtime"));
            request.setAttribute("seats",     request.getParameter("seats"));
            request.setAttribute("total",     request.getParameter("total"));
            request.getRequestDispatcher("/WEB-INF/views/paymentForm.jsp")
                    .forward(request, response);

        } else if ("myPayments".equals(action)) {
            List<Payment> myPayments = paymentDAO.getPaymentsByUser(loggedUser.getEmail());
            request.setAttribute("myPayments", myPayments);
            request.getRequestDispatcher("/WEB-INF/views/myPayments.jsp")
                    .forward(request, response);

        } else if ("confirmation".equals(action)) {
            String txnId = request.getParameter("txnId");
            Payment payment = paymentDAO.getPaymentByTransactionId(txnId);
            request.setAttribute("payment", payment);
            request.getRequestDispatcher("/WEB-INF/views/paymentConfirmation.jsp")
                    .forward(request, response);

        } else if ("adminPayments".equals(action)) {
            if (!"Admin".equals(loggedUser.getRole())) {
                response.sendRedirect(request.getContextPath() + "/UserController?action=login");
                return;
            }
            List<Payment> allPayments = paymentDAO.getAllPayments();
            request.setAttribute("allPayments", allPayments);
            request.getRequestDispatcher("/WEB-INF/views/adminPayments.jsp")
                    .forward(request, response);

        } else {
            response.sendRedirect(request.getContextPath() + "/payment?action=paymentForm");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Object sessionUser = session != null ? session.getAttribute("user") : null;

        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/UserController?action=login");
            return;
        }

        User loggedUser = (User) sessionUser;
        String action = request.getParameter("action");

        if ("processPayment".equals(action)) {

            String movieName  = request.getParameter("movieName");
            String showtime   = request.getParameter("showtime");
            String seats      = request.getParameter("seats");
            String totalStr   = request.getParameter("total");
            String promoCode  = request.getParameter("promoCode");
            String cardHolder = request.getParameter("cardHolderName");
            String cardNumber = request.getParameter("cardNumber");
            String cardType   = request.getParameter("cardType");

            // Validation
            if (cardHolder == null || cardHolder.trim().isEmpty() ||
                    cardNumber == null || cardNumber.replaceAll("\\s", "").length() < 16) {

                request.setAttribute("error", "Please fill in all card details.");
                request.setAttribute("movieName", movieName);
                request.setAttribute("showtime",  showtime);
                request.setAttribute("seats",     seats);
                request.setAttribute("total",     totalStr);
                request.getRequestDispatcher("/WEB-INF/views/paymentForm.jsp")
                        .forward(request, response);
                return;
            }

            double total    = Double.parseDouble(totalStr);
            double discount = 0;
            if ("MOVIE10".equalsIgnoreCase(promoCode))      discount = total * 0.10;
            else if ("CINE20".equalsIgnoreCase(promoCode))  discount = total * 0.20;
            double finalAmount = total - discount;

            String raw        = cardNumber.replaceAll("\\s", "");
            String maskedCard = "**** **** **** " + raw.substring(raw.length() - 4);
            String txnId      = "TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            String bookingId  = "BKG" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            String now        = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));

            Payment payment = new CardPayment(
                    txnId, loggedUser.getEmail(), total, discount, finalAmount,
                    "PENDING", now, bookingId,
                    cardHolder, maskedCard, cardType
            );
            payment.processPayment(); // sets status to SUCCESS

            PaymentDAO paymentDAO = new PaymentDAOFile(paymentsFilePath);
            paymentDAO.savePayment(payment);

            response.sendRedirect(request.getContextPath() + "/payment?action=confirmation&txnId=" + txnId);
        }
    }
}