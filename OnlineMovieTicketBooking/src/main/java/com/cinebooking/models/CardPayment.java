package com.cinebooking.models;

// Inheritance - CardPayment extends Payment and gets all its fields and methods
// Polymorphism - overrides processPayment() with card-specific logic
public class CardPayment extends Payment {

    // Encapsulation - card details are private
    private String cardHolderName;
    private String maskedCardNumber; // only last 4 digits stored
    private String cardType;         // VISA, MASTERCARD etc

    public CardPayment() {
        super();
    }

    public CardPayment(String transactionId, String userEmail, double amount,
                       double discount, double finalAmount, String status,
                       String paymentDate, String bookingId,
                       String cardHolderName, String maskedCardNumber, String cardType) {
        // Call parent constructor using super()
        super(transactionId, userEmail, amount, discount, finalAmount, status, paymentDate, bookingId);
        this.cardHolderName = cardHolderName;
        this.maskedCardNumber = maskedCardNumber;
        this.cardType = cardType;
    }

    // Polymorphism - overrides the abstract method from Payment
    @Override
    public boolean processPayment() {
        // Mark payment as successful
        this.setStatus("SUCCESS");
        return true;
    }

    // Polymorphism - returns this specific payment type
    @Override
    public String getPaymentType() {
        return "CARD";
    }

    public String getCardHolderName() { return cardHolderName; }
    public void setCardHolderName(String cardHolderName) { this.cardHolderName = cardHolderName; }

    public String getMaskedCardNumber() { return maskedCardNumber; }
    public void setMaskedCardNumber(String maskedCardNumber) { this.maskedCardNumber = maskedCardNumber; }

    public String getCardType() { return cardType; }
    public void setCardType(String cardType) { this.cardType = cardType; }

    @Override
    public String toString() {
        return super.toString() + "|" + cardHolderName + "|" + maskedCardNumber + "|" + cardType;
    }
}
