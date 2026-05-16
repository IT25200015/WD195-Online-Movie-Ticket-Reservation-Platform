package com.cinebooking.models;

// Encapsulation: All booking data is private
public class Booking {

    private String bookingId;
    private String userEmail;
    private String movieName;
    private String showtime;
    private String selectedSeats;  // comma-separated e.g. "A1,A2,B3"
    private int numberOfSeats;
    private double totalAmount;
    private String bookingDate;
    private String status; // "CONFIRMED" or "CANCELLED"
    private String transactionId;

    public Booking() {}

    public Booking(String bookingId, String userEmail, String movieName, String showtime,
                   String selectedSeats, int numberOfSeats, double totalAmount,
                   String bookingDate, String status, String transactionId) {
        this.bookingId = bookingId;
        this.userEmail = userEmail;
        this.movieName = movieName;
        this.showtime = showtime;
        this.selectedSeats = selectedSeats;
        this.numberOfSeats = numberOfSeats;
        this.totalAmount = totalAmount;
        this.bookingDate = bookingDate;
        this.status = status;
        this.transactionId = transactionId;
    }

    public String getBookingId() { return bookingId; }
    public void setBookingId(String bookingId) { this.bookingId = bookingId; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }

    public String getMovieName() { return movieName; }
    public void setMovieName(String movieName) { this.movieName = movieName; }

    public String getShowtime() { return showtime; }
    public void setShowtime(String showtime) { this.showtime = showtime; }

    public String getSelectedSeats() { return selectedSeats; }
    public void setSelectedSeats(String selectedSeats) { this.selectedSeats = selectedSeats; }

    public int getNumberOfSeats() { return numberOfSeats; }
    public void setNumberOfSeats(int numberOfSeats) { this.numberOfSeats = numberOfSeats; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getBookingDate() { return bookingDate; }
    public void setBookingDate(String bookingDate) { this.bookingDate = bookingDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getTransactionId() { return transactionId; }
    public void setTransactionId(String transactionId) { this.transactionId = transactionId; }

    // bookingId|userEmail|movieName|showtime|selectedSeats|numberOfSeats|totalAmount|bookingDate|status|transactionId
    @Override
    public String toString() {
        return bookingId + "|" + userEmail + "|" + movieName + "|" + showtime + "|"
                + selectedSeats + "|" + numberOfSeats + "|" + totalAmount + "|"
                + bookingDate + "|" + status + "|" + transactionId;
    }
}
