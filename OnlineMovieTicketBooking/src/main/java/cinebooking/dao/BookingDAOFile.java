package com.cinebooking.dao;

import com.cinebooking.models.Booking;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class BookingDAOFile implements BookingDAO {

    private final String filePath;

    public BookingDAOFile(String filePath) {
        this.filePath = filePath;
    }

    @Override
    public boolean saveBooking(Booking booking) {
        try (FileWriter writer = new FileWriter(new File(filePath), true)) {
            writer.write(booking.toString() + "\n");
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Booking> getBookingsByUser(String userEmail) {
        List<Booking> result = new ArrayList<>();
        for (Booking b : getAllBookings()) {
            if (b.getUserEmail().equalsIgnoreCase(userEmail.trim())) {
                result.add(b);
            }
        }
        return result;
    }

    @Override
    public Booking getBookingById(String bookingId) {
        for (Booking b : getAllBookings()) {
            if (b.getBookingId().equals(bookingId)) {
                return b;
            }
        }
        return null;
    }

    @Override
    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();
        File file = new File(filePath);
        if (!file.exists()) return bookings;

        try (Scanner scanner = new Scanner(file)) {
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine().trim();
                if (line.isEmpty()) continue;

                // bookingId|userEmail|movieName|showtime|selectedSeats|numberOfSeats|totalAmount|bookingDate|status|transactionId
                String[] parts = line.split("\\|");
                if (parts.length >= 10) {
                    Booking b = new Booking(
                            parts[0], parts[1], parts[2], parts[3], parts[4],
                            Integer.parseInt(parts[5]),
                            Double.parseDouble(parts[6]),
                            parts[7], parts[8], parts[9]
                    );
                    bookings.add(b);
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    @Override
    public boolean updateBookingStatus(String bookingId, String status) {
        List<Booking> bookings = getAllBookings();
        boolean updated = false;

        for (Booking b : bookings) {
            if (b.getBookingId().equals(bookingId)) {
                b.setStatus(status);
                updated = true;
            }
        }

        if (updated) {
            try (FileWriter writer = new FileWriter(new File(filePath), false)) {
                for (Booking b : bookings) {
                    writer.write(b.toString() + "\n");
                }
                return true;
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return false;
    }
}
