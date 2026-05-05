package seatbooking.model;

public class Booking {

    // Details of a booking
    private String bookingId;
    private String customerName;
    private String customerEmail;
    private String seatId;
    private String seatType;
    private double totalPrice;
    private String bookingDate;
    private String movieName;
    private String showTime;

    // Constructor - creates a new Booking object
    public Booking(String bookingId, String customerName, String customerEmail,
                   String seatId, String seatType, double totalPrice,
                   String bookingDate, String movieName, String showTime) {
        this.bookingId = bookingId;
        this.customerName = customerName;
        this.customerEmail = customerEmail;
        this.seatId = seatId;
        this.seatType = seatType;
        this.totalPrice = totalPrice;
        this.bookingDate = bookingDate;
        this.movieName = movieName;
        this.showTime = showTime;
    }

    public String getBookingId() { return bookingId; }
    public String getCustomerName() { return customerName; }
    public String getCustomerEmail() { return customerEmail; }
    public String getSeatId() { return seatId; }
    public String getSeatType() { return seatType; }
    public double getTotalPrice() { return totalPrice; }
    public String getBookingDate() { return bookingDate; }
    public String getMovieName() { return movieName; }
    public String getShowTime() { return showTime; }

    public void setBookingId(String bookingId) { this.bookingId = bookingId; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }
    public void setSeatId(String seatId) { this.seatId = seatId; }
    public void setSeatType(String seatType) { this.seatType = seatType; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }
    public void setBookingDate(String bookingDate) { this.bookingDate = bookingDate; }
    public void setMovieName(String movieName) { this.movieName = movieName; }
    public void setShowTime(String showTime) { this.showTime = showTime; }
}