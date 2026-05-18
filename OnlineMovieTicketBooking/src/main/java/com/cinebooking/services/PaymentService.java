package com.cinebooking.services;

import com.cinebooking.dao.PaymentDAO;
import com.cinebooking.dao.PaymentDAOFile;
import com.cinebooking.models.CardPayment;
import com.cinebooking.models.Payment;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

// Information Hiding: all business logic is hidden here.
// Controllers call this service and never deal with DAOs or file paths directly.
public class PaymentService {

    private final PaymentDAO paymentDAO;

    // Hardcoded promo codes — Component 5 can replace this with a file-based lookup later
    private static final String PROMO_CODE_10 = "MOVIE10";   // 10% off
    private static final String PROMO_CODE_20 = "CINE20";    // 20% off

    public PaymentService(String paymentFilePath) {
        this.paymentDAO = new PaymentDAOFile(paymentFilePath);
    }

    // Generate a unique transaction ID
    public String generateTransactionId() {
        return "TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }

    // Generate a unique booking ID
    public String generateBookingId() {
        return "BKG" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }

    // Calculate discount based on promo code
    public double calculateDiscount(double amount, String promoCode) {
        if (promoCode == null || promoCode.trim().isEmpty()) return 0;
        if (PROMO_CODE_10.equalsIgnoreCase(promoCode.trim())) return amount * 0.10;
        if (PROMO_CODE_20.equalsIgnoreCase(promoCode.trim())) return amount * 0.20;
        return 0;
    }

    // Validate promo code
    public boolean isValidPromoCode(String promoCode) {
        if (promoCode == null || promoCode.trim().isEmpty()) return false;
        return PROMO_CODE_10.equalsIgnoreCase(promoCode.trim())
                || PROMO_CODE_20.equalsIgnoreCase(promoCode.trim());
    }

    // Process a full card payment
    // Polymorphism: Payment reference used — works for CardPayment or any future payment type
    public boolean processCardPayment(String userEmail, String movieName, String showtime,
                                      String selectedSeats, int numSeats, double totalAmount,
                                      String promoCode, String cardHolderName,
                                      String rawCardNumber, String cardType) {

        double discount = calculateDiscount(totalAmount, promoCode);
        double finalAmount = totalAmount - discount;

        // Mask card number — keep only last 4 digits
        String rawDigits = rawCardNumber.replaceAll("\\s", "");
        String maskedCard = "**** **** **** " + rawDigits.substring(Math.max(0, rawDigits.length() - 4));

        String txnId = generateTransactionId();
        String bookingId = generateBookingId();
        String now = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));

        // Polymorphism: CardPayment is referenced via Payment (parent type)
        Payment payment = new CardPayment(
                txnId, userEmail, totalAmount, discount, finalAmount,
                "PENDING", now, bookingId,
                cardHolderName, maskedCard, cardType
        );

        // Polymorphism: processPayment() calls the CardPayment override
        boolean paymentSuccess = payment.processPayment();

        if (paymentSuccess) {
            paymentDAO.savePayment(payment);
            return true;
        }
        return false;
    }

    public List<Payment> getUserPayments(String userEmail) {
        return paymentDAO.getPaymentsByUser(userEmail);
    }

    public List<Payment> getAllPayments() {
        return paymentDAO.getAllPayments();
    }

    public Payment getPaymentByTxnId(String txnId) {
        return paymentDAO.getPaymentByTransactionId(txnId);
    }
}