package seatbooking.service;

import seatbooking.model.Booking;
import seatbooking.model.Seat;

import java.io.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class BookingService {

    private static final String SEATS_FILE = "data/seats.txt";
    private static final String BOOKINGS_FILE = "data/bookings.txt";

    public List<Seat> getAllSeats() {
        List<Seat> seatList = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(SEATS_FILE))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] data = line.split("\\|");
                if (data.length == 4) {
                    String seatId = data[0];
                    String seatType = data[1];
                    boolean isBooked = Boolean.parseBoolean(data[2]);
                    double price = Double.parseDouble(data[3]);
                    seatList.add(new Seat(seatId, seatType, isBooked, price));
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return seatList;
    }

    public Seat getSeatById(String seatId) {
        for (Seat s : getAllSeats()) {
            if (s.getSeatId().equals(seatId)) {
                return s;
            }
        }
        return null;
    }

    public Booking createBooking(String customerName, String customerEmail,
                                 String seatId, String movieName, String showTime) {

        Seat seat = getSeatById(seatId);
        if (seat == null || seat.isBooked()) {
            return null;
        }

        String bookingId = generateBookingId();
        String bookingDate = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        Booking booking = new Booking(bookingId, customerName, customerEmail,
                seatId, seat.getSeatType(), seat.getPrice(),
                bookingDate, movieName, showTime);

        saveBooking(booking);
        markSeatAsBooked(seatId);

        return booking;
    }

    private void saveBooking(Booking booking) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(BOOKINGS_FILE, true))) {
            bw.write(booking.getBookingId() + "|" +
                    booking.getCustomerName() + "|" +
                    booking.getCustomerEmail() + "|" +
                    booking.getSeatId() + "|" +
                    booking.getSeatType() + "|" +
                    booking.getTotalPrice() + "|" +
                    booking.getBookingDate() + "|" +
                    booking.getMovieName() + "|" +
                    booking.getShowTime());
            bw.newLine();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void markSeatAsBooked(String seatId) {
        List<Seat> seatList = getAllSeats();
        StringBuilder sb = new StringBuilder();

        for (Seat s : seatList) {
            if (s.getSeatId().equals(seatId)) {
                s.setBooked(true);
            }
            sb.append(s.getSeatId()).append("|")
                    .append(s.getSeatType()).append("|")
                    .append(s.isBooked()).append("|")
                    .append(s.getPrice()).append("\n");
        }

        try (BufferedWriter bw = new BufferedWriter(new FileWriter(SEATS_FILE))) {
            bw.write(sb.toString());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private String generateBookingId() {
        String date = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        int count = countExistingBookings() + 1;
        return String.format("BK-%s-%05d", date, count);
    }

    private int countExistingBookings() {
        int count = 0;
        try (BufferedReader br = new BufferedReader(new FileReader(BOOKINGS_FILE))) {
            while (br.readLine() != null) {
                count++;
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return count;
    }
}