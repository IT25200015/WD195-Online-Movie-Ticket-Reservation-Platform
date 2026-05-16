package cinebooking.services;

import com.cinebooking.dao.BookingDAO;
import com.cinebooking.dao.BookingDAOFile;
import com.cinebooking.dao.PaymentDAO;
import com.cinebooking.dao.PaymentDAOFile;
import com.cinebooking.models.Booking;
import com.cinebooking.models.CardPayment;
import com.cinebooking.models.Payment;
import com.cinebooking.models.Showtime;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

// Information Hiding: all business logic is hidden here.
// Controllers call this service and never deal with DAOs or file paths directly.
public class PaymentService {

    private final PaymentDAO paymentDAO;
    private final BookingDAO bookingDAO;

    // Hardcoded promo codes — Component 5 can replace this with a file-based lookup later
    private static final String PROMO_CODE_10 = "MOVIE10";   // 10% off
    private static final String PROMO_CODE_20 = "CINE20";    // 20% off

    public PaymentService(String paymentFilePath, String bookingFilePath) {
        this.paymentDAO = new PaymentDAOFile(paymentFilePath);
        this.bookingDAO = new BookingDAOFile(bookingFilePath);
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

    // Process a full card payment and create a booking
    // Polymorphism: Payment reference used — works for CardPayment or any future payment type
    public boolean processCardPayment(String userEmail, String movieName, String showtime,
                                      String selectedSeats, int numSeats, double totalAmount,
                                      String promoCode, String cardHolderName,
                                      String rawCardNumber, String cardType) {

        double discount = calculateDiscount(totalAmount, promoCode);
        double finalAmount = totalAmount - discount;

        // Mask card number — keep only last 4 digits
        String maskedCard = "**** **** **** " + rawCardNumber.replaceAll("\\s", "").substring(
                Math.max(0, rawCardNumber.replaceAll("\\s", "").length() - 4));

        String txnId = generateTransactionId();
        String bookingId = generateBookingId();
        String now = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
        String today = LocalDate.now().toString();

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

            Booking booking = new Booking(
                    bookingId, userEmail, movieName, showtime,
                    selectedSeats, numSeats, finalAmount, today, "CONFIRMED", txnId
            );
            bookingDAO.saveBooking(booking);
            return true;
        }
        return false;
    }

    public List<Payment> getUserPayments(String userEmail) {
        return paymentDAO.getPaymentsByUser(userEmail);
    }

    public List<Booking> getUserBookings(String userEmail) {
        return bookingDAO.getBookingsByUser(userEmail);
    }

    public List<Booking> getAllBookings() {
        return bookingDAO.getAllBookings();
    }

    public List<Payment> getAllPayments() {
        return paymentDAO.getAllPayments();
    }

    public Payment getPaymentByTxnId(String txnId) {
        return paymentDAO.getPaymentByTransactionId(txnId);
    }

    public Booking getBookingById(String bookingId) {
        return bookingDAO.getBookingById(bookingId);
    }

    // Hardcoded showtimes — self-contained so not blocked by Component 2
    public Showtime[] getAvailableShowtimes() {
        return new Showtime[]{
            new Showtime("ST001", "Avengers: Doomsday", "Action", "2026-05-10", "10:00 AM", "Hall A", 30, 30, 800.00, 1200.00),
            new Showtime("ST002", "Avengers: Doomsday", "Action", "2026-05-10", "02:00 PM", "Hall B", 30, 30, 800.00, 1200.00),
            new Showtime("ST003", "Minecraft Movie", "Adventure", "2026-05-11", "11:00 AM", "Hall A", 30, 30, 700.00, 1000.00),
            new Showtime("ST004", "Minecraft Movie", "Adventure", "2026-05-11", "04:00 PM", "Hall C", 30, 30, 700.00, 1000.00),
            new Showtime("ST005", "Sinners", "Horror", "2026-05-12", "08:00 PM", "Hall B", 30, 30, 900.00, 1300.00),
            new Showtime("ST006", "Final Destination", "Thriller", "2026-05-13", "07:30 PM", "Hall A", 30, 30, 750.00, 1100.00),
        };
    }

    public Showtime getShowtimeById(String id) {
        for (Showtime s : getAvailableShowtimes()) {
            if (s.getShowtimeId().equals(id)) return s;
        }
        return null;
    }
}
