package cinebooking.models;

// Abstraction - Payment is abstract because we don't want to create a generic payment
// Only specific types like CardPayment can be created
public abstract class Payment {

    // Encapsulation - private fields, accessed through getters and setters
    private String transactionId;
    private String userEmail;
    private double amount;
    private double discount;
    private double finalAmount;
    private String status;
    private String paymentDate;
    private String bookingId;

    public Payment() {}

    public Payment(String transactionId, String userEmail, double amount,
                   double discount, double finalAmount, String status,
                   String paymentDate, String bookingId) {
        this.transactionId = transactionId;
        this.userEmail = userEmail;
        this.amount = amount;
        this.discount = discount;
        this.finalAmount = finalAmount;
        this.status = status;
        this.paymentDate = paymentDate;
        this.bookingId = bookingId;
    }

    // Abstraction - subclasses must implement this
    public abstract boolean processPayment();

    // Abstraction - subclasses return their own payment type
    public abstract String getPaymentType();

    // Getters and Setters
    public String getTransactionId() { return transactionId; }
    public void setTransactionId(String transactionId) { this.transactionId = transactionId; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public double getDiscount() { return discount; }
    public void setDiscount(double discount) { this.discount = discount; }

    public double getFinalAmount() { return finalAmount; }
    public void setFinalAmount(double finalAmount) { this.finalAmount = finalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getPaymentDate() { return paymentDate; }
    public void setPaymentDate(String paymentDate) { this.paymentDate = paymentDate; }

    public String getBookingId() { return bookingId; }
    public void setBookingId(String bookingId) { this.bookingId = bookingId; }

    // Used to save to file: transactionId|userEmail|amount|discount|finalAmount|status|paymentDate|bookingId|paymentType
    @Override
    public String toString() {
        return transactionId + "|" + userEmail + "|" + amount + "|" + discount + "|"
                + finalAmount + "|" + status + "|" + paymentDate + "|" + bookingId + "|" + getPaymentType();
    }
}
