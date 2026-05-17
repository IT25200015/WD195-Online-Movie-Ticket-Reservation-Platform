package com.cinebooking.services;

import com.cinebooking.models.Booking;
import com.cinebooking.models.Seat;

import java.io.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class BookingService {

    private static final String SEATS_FILE = "C:/Users/Lenovo/IdeaProjects/WD195-Online-Movie-Ticket-Reservation-Platform/OnlineMovieTicketBooking/data/seats.txt";
    private static final String BOOKINGS_FILE = "C:/Users/Lenovo/IdeaProjects/WD195-Online-Movie-Ticket-Reservation-Platform/OnlineMovieTicketBooking/data/bookings.txt";

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

    public List<Seat> getAvailableSeats(int showtimeId) {
        // 1. Load all seats (all start as available)
        List<Seat> allSeats = getAllSeats();

        // 2. Find which seats are already booked for this showtime
        List<String> bookedSeatIds = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(BOOKINGS_FILE))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] data = line.split("\\|");
                if (data.length >= 9) {
                    String bookingSeatId   = data[3];
                    String bookingShowtime = data[8];
                    // data[8] is showtimeId
                    if (bookingShowtime.equals(String.valueOf(showtimeId))) {
                        bookedSeatIds.add(bookingSeatId);
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        // 3. Mark seats as booked if they appear in bookings for this showtime
        for (Seat seat : allSeats) {
            if (bookedSeatIds.contains(seat.getSeatId())) {
                seat.setBooked(true);
            } else {
                seat.setBooked(false);
            }
        }

        return allSeats;
    }

    public Seat getSeatById(String seatId) {
        for (Seat s : getAllSeats()) {
            if (s.getSeatId().equals(seatId)) {
                return s;
            }
        }
        return null;
    }

    public List<Booking> getBookingsByEmail(String email) {
        List<Booking> bookings = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(BOOKINGS_FILE))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] data = line.split("\\|");
                if (data.length == 9 && data[2].equals(email)) {
                    Booking b = new Booking(
                            data[0], data[1], data[2], data[3],
                            data[4], Double.parseDouble(data[5]),
                            data[6], data[7], data[8]
                    );
                    bookings.add(b);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    public Booking createBooking(String customerName, String customerEmail,
                                 String seatId, String movieName, String showtimeId) {

        Seat seat = getSeatById(seatId);
        if (seat == null) {
            return null;
        }

        // Check if seat is already booked for this showtime
        List<Seat> availableSeats = getAvailableSeats(Integer.parseInt(showtimeId));
        for (Seat s : availableSeats) {
            if (s.getSeatId().equals(seatId) && s.isBooked()) {
                return null; // already booked for this showtime
            }
        }

        String bookingId   = generateBookingId();
        String bookingDate = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        Booking booking = new Booking(bookingId, customerName, customerEmail,
                seatId, seat.getSeatType(), seat.getPrice(),
                bookingDate, movieName, showtimeId);

        saveBooking(booking);
        return booking;
    }

    public boolean cancelBooking(String bookingId) {
        List<String> lines = new ArrayList<>();

        try (BufferedReader br = new BufferedReader(new FileReader(BOOKINGS_FILE))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] data = line.split("\\|");
                if (!data[0].equals(bookingId)) {
                    lines.add(line);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }

        try (BufferedWriter bw = new BufferedWriter(new FileWriter(BOOKINGS_FILE))) {
            for (String line : lines) {
                bw.write(line);
                bw.newLine();
            }
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }

        return true;
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