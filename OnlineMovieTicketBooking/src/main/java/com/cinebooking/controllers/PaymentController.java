package com.cinebooking.controllers;

import com.cinebooking.dao.PaymentDAO;
import com.cinebooking.dao.PaymentDAOFile;
import com.cinebooking.models.CardPayment;
import com.cinebooking.models.Booking;
import com.cinebooking.models.Payment;
import com.cinebooking.models.User;
import com.cinebooking.models.Promotion;
import com.cinebooking.services.BookingService;
import com.cinebooking.services.PromotionService;

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

@WebServlet("/PaymentController")
public class PaymentController extends HttpServlet {

    private BookingService bookingService;
    private PromotionService promotionService;

    // Get the payments file path from the server
    private String getFilePath(HttpServletRequest request) {
        return request.getServletContext().getRealPath("/data/payments.txt");
    }

    @Override
    public void init() {
        String bookingsPath = getServletContext().getRealPath("/data/bookings.txt");
        String seatsPath = getServletContext().getRealPath("/data/seats.txt");
        String promotionsPath = getServletContext().getRealPath("/data/promotions.txt");
        bookingService = new BookingService(seatsPath, bookingsPath);
        promotionService = new PromotionService(promotionsPath);
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

        switch (action == null ? "selectMovie" : action) {
            case "selectMovie" -> request.getRequestDispatcher("/WEB-INF/views/selectMovie.jsp").forward(request, response);
            case "paymentForm" -> {
                request.setAttribute("movieName", session.getAttribute("movieName"));
                request.setAttribute("showtime", session.getAttribute("showtime"));
                request.setAttribute("seats", session.getAttribute("seats"));
                request.setAttribute("total", session.getAttribute("total"));
                request.setAttribute("discount", session.getAttribute("discount"));
                request.setAttribute("finalAmount", session.getAttribute("finalAmount"));
                request.setAttribute("promoCode", session.getAttribute("promoCode"));
                
                // Fetch active promotions and pass them to the JSP
                List<Promotion> activePromotions = promotionService.getActiveValidPromotions();
                request.setAttribute("activePromotions", activePromotions);
                
                request.getRequestDispatcher("/WEB-INF/views/paymentForm.jsp").forward(request, response);
            }
            case "myBookings" -> {
                PaymentDAO paymentDAO = new PaymentDAOFile(getFilePath(request));
                List<Payment> myPayments = paymentDAO.getPaymentsByUser(loggedUser.getEmail());
                request.setAttribute("myPayments", myPayments);
                request.getRequestDispatcher("/WEB-INF/views/myBookings.jsp").forward(request, response);
            }
            case "confirmation" -> {
                String txnId = request.getParameter("txnId");
                PaymentDAO paymentDAO = new PaymentDAOFile(getFilePath(request));
                Payment payment = paymentDAO.getPaymentByTransactionId(txnId);
                
                request.setAttribute("bookedMovieName", session.getAttribute("movieName"));
                request.setAttribute("bookedSeats", session.getAttribute("seats"));
                request.setAttribute("totalPrice", session.getAttribute("finalAmount"));
                
                request.getRequestDispatcher("/WEB-INF/views/booking_success.jsp").forward(request, response);
            }
            case "adminPayments" -> {
                if (!"Admin".equals(loggedUser.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/UserController?action=login");
                    return;
                }
                PaymentDAO paymentDAO = new PaymentDAOFile(getFilePath(request));
                List<Payment> allPayments = paymentDAO.getAllPayments();
                request.setAttribute("allPayments", allPayments);
                request.getRequestDispatcher("/WEB-INF/views/adminPayments.jsp").forward(request, response);
            }
            default -> response.sendRedirect(request.getContextPath() + "/PaymentController?action=selectMovie");
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

            String cardHolder    = request.getParameter("cardHolderName");
            String cardNumber    = request.getParameter("cardNumber");
            String cardType      = request.getParameter("cardType");

            String movieName = String.valueOf(session.getAttribute("movieName"));
            String showtime = String.valueOf(session.getAttribute("showtime"));
            String seats = String.valueOf(session.getAttribute("seats"));
            String totalStr = String.valueOf(session.getAttribute("total"));
            String promoCode = request.getParameter("promoCode");
            String discountStr = String.valueOf(session.getAttribute("discount"));

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
            double discount = 0.0;

            // Strictly verify membership for promo code usage
            if (promoCode != null && !promoCode.trim().isEmpty()) {
                if (loggedUser.getMembership().equalsIgnoreCase("Premium")) {
                    discount = promotionService.applyPromoCode(promoCode.trim(), total);
                    if (discount <= 0) {
                        request.setAttribute("error", "Invalid or expired promo code.");
                        request.setAttribute("movieName", movieName);
                        request.setAttribute("showtime", showtime);
                        request.setAttribute("seats", seats);
                        request.setAttribute("total", totalStr);
                        request.getRequestDispatcher("/WEB-INF/views/paymentForm.jsp").forward(request, response);
                        return;
                    }
                } else {
                    // Non-premium user trying to use a promo code
                    discount = 0.0;
                    request.setAttribute("error", "Promo codes are exclusive to Premium members.");
                }
            } else if (discountStr != null && !"null".equalsIgnoreCase(discountStr)) {
                discount = Double.parseDouble(discountStr);
            }

            double finalAmount = total - discount;
            session.setAttribute("promoCode", promoCode);
            session.setAttribute("discount", discount);
            session.setAttribute("finalAmount", finalAmount);

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
            boolean paymentSuccess = payment.processPayment();

            if (!paymentSuccess) {
                request.setAttribute("error", "Payment failed. Please try again.");
                request.setAttribute("movieName", movieName);
                request.setAttribute("showtime", showtime);
                request.setAttribute("seats", seats);
                request.setAttribute("total", totalStr);
                request.getRequestDispatcher("/WEB-INF/views/paymentForm.jsp").forward(request, response);
                return;
            }

            // Save to file
            PaymentDAO paymentDAO = new PaymentDAOFile(getFilePath(request));
            boolean saved = paymentDAO.savePayment(payment);
            if (!saved) {
                request.setAttribute("error", "Payment failed. Please try again.");
                request.getRequestDispatcher("/WEB-INF/views/paymentForm.jsp").forward(request, response);
                return;
            }

            // Record promo usage only after a successful payment transaction
            if (promoCode != null && !promoCode.trim().isEmpty() && discount > 0) {
                promotionService.recordPromoCodeUsage(promoCode.trim());
            }

            // Confirm the exact pending bookings created earlier in the booking flow
            Object bookingIdsAttr = session.getAttribute("bookingIDList");
            if (bookingIdsAttr instanceof List<?> bookingIds) {
                for (Booking booking : bookingService.getPendingBookingsByEmail(loggedUser.getEmail())) {
                    if (bookingIds.contains(booking.getBookingId())) {
                        booking.setBookingStatus("CONFIRMED");
                        if (!bookingService.updateBooking(booking)) {
                            request.setAttribute("error", "Payment succeeded, but booking confirmation failed.");
                            request.getRequestDispatcher("/WEB-INF/views/paymentForm.jsp").forward(request, response);
                            return;
                        }
                    }
                }
            }

            session.removeAttribute("bookingIDList");
            session.setAttribute("paymentTxnId", txnId);
            session.setAttribute("paymentStatus", "SUCCESS");

            // Go to confirmation page
            response.sendRedirect(request.getContextPath() + "/PaymentController?action=confirmation&txnId=" + txnId);
        }
    }
}