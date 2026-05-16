package com.cinebooking.dao;

import com.cinebooking.models.Booking;
import java.util.List;

public interface BookingDAO {
    boolean saveBooking(Booking booking);
    List<Booking> getBookingsByUser(String userEmail);
    Booking getBookingById(String bookingId);
    List<Booking> getAllBookings();
    boolean updateBookingStatus(String bookingId, String status);
}
