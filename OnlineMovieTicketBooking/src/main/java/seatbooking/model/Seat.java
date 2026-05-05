package seatbooking.model;

public class Seat {

    private String seatId;
    private String seatType;
    private boolean isBooked;
    private double price;

    public Seat(String seatId, String seatType, boolean isBooked, double price) {
        this.seatId = seatId;
        this.seatType = seatType;
        this.isBooked = isBooked;
        this.price = price;
    }

    public String getSeatId() {
        return seatId;
    }

    public String getSeatType() {
        return seatType;
    }

    public boolean isBooked() {
        return isBooked;
    }

    public double getPrice() {
        return price;
    }

    public void setSeatId(String seatId) {
        this.seatId = seatId;
    }

    public void setSeatType(String seatType) {
        this.seatType = seatType;
    }

    public void setBooked(boolean booked) {
        isBooked = booked;
    }

    public void setPrice(double price) {
        this.price = price;
    }
}