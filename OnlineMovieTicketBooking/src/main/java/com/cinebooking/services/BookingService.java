package com.cinebooking.services;

import com.cinebooking.models.Booking;
import com.cinebooking.models.Seat;

import java.io.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;



public class BookingService {

    private static final Object FILE_LOCK = new Object();
    private final String SEATS_FILE;
    private final String BOOKINGS_FILE;

    public BookingService(String seatsFilepath, String bookingFilepath) {
        this.SEATS_FILE = seatsFilepath;
        this.BOOKINGS_FILE = bookingFilepath;
    }

    public List<Seat> getAllSeats() {
        List<Seat> seatList = new ArrayList<>();
        synchronized (FILE_LOCK) {
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
                System.err.println("Unable to read seats file: " + e.getMessage());
            }
        }
        return seatList;
    }

    public List<Seat> getAvailableSeats(int showtimeId) {
        // 1. Load all seats (all start as available)
        List<Seat> allSeats = getAllSeats();

        // 2. Find which seats are already booked for this showtime
        List<String> bookedSeatIds = new ArrayList<>();
        synchronized (FILE_LOCK) {
            try (BufferedReader br = new BufferedReader(new FileReader(BOOKINGS_FILE))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] data = line.split("\\|");
                    if (data.length >= 10) {
                        String bookingSeatId   = data[3];
                        String bookingShowtime = data[8];
                        String bookingStatus = data[9];

                        if (!bookingStatus.equals("PENDING") && bookingShowtime.equals(String.valueOf(showtimeId))) {
                            bookedSeatIds.add(bookingSeatId);
                        }
                    }
                }
            } catch (IOException e) {
                System.err.println("Unable to read bookings file: " + e.getMessage());
            }
        }

        // 3. Mark seats as booked if they appear in bookings for this showtime
        for (Seat seat : allSeats) {
            seat.setBooked(bookedSeatIds.contains(seat.getSeatId()));
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

    public List<Booking> getPendingBookingsByEmail(String email) {
        List<Booking> bookings = new ArrayList<>();
        synchronized (FILE_LOCK) {
            try (BufferedReader br = new BufferedReader(new FileReader(BOOKINGS_FILE))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] data = line.split("\\|");
                    if (data.length == 10 && data[2].equals(email) && data[9].equals("PENDING")) {
                        Booking b = new Booking(
                                data[0], data[1], data[2], data[3],
                                data[4], Double.parseDouble(data[5]),
                                data[6], data[7], data[8], data[9]
                        );
                        bookings.add(b);
                    }
                }
            } catch (IOException e) {
                System.err.println("Unable to read bookings file: " + e.getMessage());
            }
        }
        return bookings;
    }

    public List<Booking> getConfirmedBookingsByEmail(String email) {
        List<Booking> bookings = new ArrayList<>();
        synchronized (FILE_LOCK) {
            try (BufferedReader br = new BufferedReader(new FileReader(BOOKINGS_FILE))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] data = line.split("\\|");
                    if (data.length == 10 && data[2].equals(email) && data[9].equals("CONFIRMED")) {
                        Booking b = new Booking(
                                data[0], data[1], data[2], data[3],
                                data[4], Double.parseDouble(data[5]),
                                data[6], data[7], data[8], data[9]
                        );
                        bookings.add(b);
                    }
                }
            } catch (IOException e) {
                System.err.println("Unable to read bookings file: " + e.getMessage());
            }
        }
        return bookings;
    }

    public Booking createBooking(String customerName, String customerEmail,
                                 String seatId, String movieName, String showtimeId, String status) {

        Seat seat = getSeatById(seatId);
        if (seat == null) {
            return null;
        }

        // Check if seat is already booked for this showtime
        List<Seat> availableSeats = getAvailableSeats(Integer.parseInt(showtimeId));
        for (Seat s : availableSeats) {
            if (s.getSeatId().equals(seatId) && s.isBooked()) return null; // already booked for this showtime
        }

        String bookingId   = generateBookingId();
        String bookingDate = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        Booking booking = new Booking(bookingId, customerName, customerEmail,
                seatId, seat.getSeatType(), seat.getPrice(),
                bookingDate, movieName, showtimeId, status);

        synchronized (FILE_LOCK) {
            saveBooking(booking);
        }
        return booking;
    }

    public void cancelBooking(String bookingId) {
        List<String> lines = new ArrayList<>();

        synchronized (FILE_LOCK) {
            try (BufferedReader br = new BufferedReader(new FileReader(BOOKINGS_FILE))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] data = line.split("\\|");
                    if (!data[0].equals(bookingId)) {
                        lines.add(line);
                    }
                }
            } catch (IOException e) {
                System.err.println("Unable to cancel booking: " + e.getMessage());
                return;
            }

            try (BufferedWriter bw = new BufferedWriter(new FileWriter(BOOKINGS_FILE))) {
                for (String line : lines) {
                    bw.write(line);
                    bw.newLine();
                }
            } catch (IOException e) {
                System.err.println("Unable to cancel booking write: " + e.getMessage());
                return;
            }
        }
    }

    private void saveBooking(Booking booking) {
        synchronized (FILE_LOCK) {
            try (BufferedWriter bw = new BufferedWriter(new FileWriter(BOOKINGS_FILE, true))) {
                bw.write(booking.getBookingId() + "|" +
                        booking.getCustomerName() + "|" +
                        booking.getCustomerEmail() + "|" +
                        booking.getSeatId() + "|" +
                        booking.getSeatType() + "|" +
                        booking.getTotalPrice() + "|" +
                        booking.getBookingDate() + "|" +
                        booking.getMovieName() + "|" +
                        booking.getShowTime() + "|" +
                        booking.getBookingStatus());
                bw.newLine();
            } catch (IOException e) {
                System.err.println("Unable to write booking: " + e.getMessage());
            }
        }
    }

    public boolean updateBooking(Booking booking) {
        List<String> lines = new ArrayList<>();
        boolean updated = false;

        synchronized (FILE_LOCK) {
            try (BufferedReader br = new BufferedReader(new FileReader(BOOKINGS_FILE))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] data = line.split("\\|");
                    if (data[0].equals(booking.getBookingId())) {
                        // Replace with updated booking data
                        line = booking.getBookingId() + "|" +
                                booking.getCustomerName() + "|" +
                                booking.getCustomerEmail() + "|" +
                                booking.getSeatId() + "|" +
                                booking.getSeatType() + "|" +
                                booking.getTotalPrice() + "|" +
                                booking.getBookingDate() + "|" +
                                booking.getMovieName() + "|" +
                                booking.getShowTime() + "|" +
                                booking.getBookingStatus();
                        updated = true;
                    }
                    lines.add(line);
                }
            } catch (IOException e) {
                System.err.println("Unable to update booking: " + e.getMessage());
                return false;
            }

            if (!updated) return false;

            try (BufferedWriter bw = new BufferedWriter(new FileWriter(BOOKINGS_FILE))) {
                for (String line : lines) {
                    bw.write(line);
                    bw.newLine();
                }
            } catch (IOException e) {
                System.err.println("Unable to update booking write: " + e.getMessage());
                return false;
            }
        }

        return true;
    }

    private String generateBookingId() {
        String date = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        int count = countExistingBookings() + 1;
        return String.format("BK-%s-%05d", date, count);
    }

    private int countExistingBookings() {
        int count = 0;
        synchronized (FILE_LOCK) {
            try (BufferedReader br = new BufferedReader(new FileReader(BOOKINGS_FILE))) {
                while (br.readLine() != null) {
                    count++;
                }
            } catch (IOException e) {
                System.err.println("Unable to count bookings: " + e.getMessage());
            }
        }
        return count;
    }
}