package com.cinebooking.dao; // ← change

import com.cinebooking.models.Payment; // ← change
import java.util.List;

// Abstraction - interface defines what must be done, not how
public interface PaymentDAO {

    boolean savePayment(Payment payment);

    List<Payment> getPaymentsByUser(String userEmail);

    Payment getPaymentByTransactionId(String transactionId);

    List<Payment> getAllPayments();
}
