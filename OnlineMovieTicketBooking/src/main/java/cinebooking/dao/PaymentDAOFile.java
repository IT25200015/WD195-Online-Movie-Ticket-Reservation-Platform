package com.cinebooking.dao;

import com.cinebooking.models.CardPayment;
import com.cinebooking.models.Payment;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

// Information Hiding - all file reading and writing is hidden inside this class
public class PaymentDAOFile implements PaymentDAO {

    private final String filePath;

    public PaymentDAOFile(String filePath) {
        this.filePath = filePath;
    }

    @Override
    public boolean savePayment(Payment payment) {
        try (FileWriter writer = new FileWriter(new File(filePath), true)) {
            writer.write(payment.toString() + "\n");
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Payment> getPaymentsByUser(String userEmail) {
        List<Payment> result = new ArrayList<>();
        for (Payment p : getAllPayments()) {
            if (p.getUserEmail().equalsIgnoreCase(userEmail.trim())) {
                result.add(p);
            }
        }
        return result;
    }

    @Override
    public Payment getPaymentByTransactionId(String transactionId) {
        for (Payment p : getAllPayments()) {
            if (p.getTransactionId().equals(transactionId)) {
                return p;
            }
        }
        return null;
    }

    @Override
    public List<Payment> getAllPayments() {
        List<Payment> payments = new ArrayList<>();
        File file = new File(filePath);
        if (!file.exists()) return payments;

        try (Scanner scanner = new Scanner(file)) {
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine().trim();
                if (line.isEmpty()) continue;

                // Format: transactionId|userEmail|amount|discount|finalAmount|status|paymentDate|bookingId|paymentType|cardHolder|maskedCard|cardType
                String[] parts = line.split("\\|");
                if (parts.length >= 12 && "CARD".equals(parts[8])) {
                    CardPayment cp = new CardPayment(
                            parts[0], parts[1],
                            Double.parseDouble(parts[2]),
                            Double.parseDouble(parts[3]),
                            Double.parseDouble(parts[4]),
                            parts[5], parts[6], parts[7],
                            parts[9], parts[10], parts[11]
                    );
                    payments.add(cp);
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return payments;
    }
}
