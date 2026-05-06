package com.cinebooking.services;

import com.cinebooking.models.Promotion;
import com.cinebooking.models.PromotionFactory;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class PromotionService {

    private String filePath;

    public PromotionService(String rootPath) {
        // Pointing directly to the absolute project path so changes show up in IntelliJ
        // instead of Tomcat's temporary deployment webapps folder.
        this.filePath = "C:\\Users\\User\\Downloads\\New folder (2)\\WD195-Online-Movie-Ticket-Reservation-Platform-main\\OnlineMovieTicketBooking\\data\\promotions.txt";
        ensureFileExists();
    }

    private void ensureFileExists() {
        File file = new File(filePath);
        file.getParentFile().mkdirs();
        try {
            if (file.createNewFile()) {
                System.out.println("Created promotions.txt file at: " + filePath);
            }
        } catch (IOException e) {
            System.err.println("Error creating promotions file: " + e.getMessage());
        }
    }

    /**
     * Reads all promotions from the file.
     */
    public List<Promotion> getAllPromotions() {
        List<Promotion> promotions = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                Promotion promo = PromotionFactory.parsePromotion(line.trim());
                if (promo != null) {
                    promotions.add(promo);
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading promotions: " + e.getMessage());
        }
        return promotions;
    }
    
    /**
     * Gets only active, valid promotions for the public deals page
     */
    public List<Promotion> getActiveValidPromotions() {
        return getAllPromotions().stream()
                .filter(p -> p.isActive() && p.getUsageCount() < p.getUsageLimit())
                .collect(Collectors.toList());
    }

    /**
     * Retrieves a promotion by its code.
     */
    public Promotion getPromotionByCode(String code) {
        return getAllPromotions().stream()
                .filter(p -> p.getPromoCode().equalsIgnoreCase(code))
                .findFirst()
                .orElse(null);
    }

    /**
     * Appends a new promotion to the file. Ensures uniquely checking.
     */
    public boolean createPromotion(Promotion promotion) {
        if (getPromotionByCode(promotion.getPromoCode()) != null) {
            return false; // Code already exists
        }

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath, true))) {
            writer.write(promotion.toFileString());
            writer.newLine();
            return true;
        } catch (IOException e) {
            System.err.println("Error writing promotion: " + e.getMessage());
            return false;
        }
    }

    /**
     * Re-writes the entire file with updated properties (Update / Delete approach).
     */
    private void saveAllPromotions(List<Promotion> promotions) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            for (Promotion promo : promotions) {
                writer.write(promo.toFileString());
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error re-writing promotions file: " + e.getMessage());
        }
    }

    /**
     * Updates an existing promotion.
     */
    public boolean updatePromotion(Promotion updatedPromo) {
        List<Promotion> all = getAllPromotions();
        boolean found = false;
        for (int i = 0; i < all.size(); i++) {
            if (all.get(i).getPromoCode().equalsIgnoreCase(updatedPromo.getPromoCode())) {
                all.set(i, updatedPromo);
                found = true;
                break;
            }
        }
        if (found) {
            saveAllPromotions(all);
        }
        return found;
    }

    /**
     * Deletes a promotion (if it can be safely deleted).
     */
    public boolean deletePromotion(String code) {
        List<Promotion> all = getAllPromotions();
        boolean removed = all.removeIf(p -> p.getPromoCode().trim().equalsIgnoreCase(code.trim()));
        if (removed) {
            saveAllPromotions(all);
        }
        return removed;
    }

    /**
     * Validates a promo code against a booking amount and returns the discount amount.
     * Returns 0 if invalid.
     */
    public double applyPromoCode(String code, double bookingAmount) {
        Promotion promo = getPromotionByCode(code);
        if (promo == null || !promo.isValidForUse(bookingAmount)) {
            return 0; // Invalid or conditions not met
        }
        return promo.calculateDiscount(bookingAmount);
    }

    /**
     * Called upon successful checkout booking to increment the usage counter.
     */
    public boolean recordPromoCodeUsage(String code) {
        List<Promotion> all = getAllPromotions();
        boolean found = false;
        for (Promotion p : all) {
            if (p.getPromoCode().equalsIgnoreCase(code)) {
                p.incrementUsage();
                // Optionally if usageCount == usageLimit, auto deactivate
                if (p.getUsageCount() >= p.getUsageLimit()) {
                    p.setActive(false);
                }
                found = true;
                break;
            }
        }
        if (found) {
            saveAllPromotions(all);
        }
        return found;
    }
    
    // ---- Analytics Methods ----
    
    public int getTotalCodesCount() {
        return getAllPromotions().size();
    }
    
    public int getTotalRedemptions() {
        return getAllPromotions().stream().mapToInt(Promotion::getUsageCount).sum();
    }
    
    // To track total platform discount value, we'd ideally need a ledger of all uses, 
    // but without one we can just calculate an approximate or store total granted in the actual promotion line if needed.
    // For this module, we will just use redemption counts. Providing average or something without modifying the class.
}
