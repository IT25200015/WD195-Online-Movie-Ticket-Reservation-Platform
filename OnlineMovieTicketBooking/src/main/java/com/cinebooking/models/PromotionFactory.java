package com.cinebooking.models;

import java.time.LocalDate;

public class PromotionFactory {

    public static Promotion parsePromotion(String csvLine) {
        String[] parts = csvLine.split(",");
        
        if (parts.length < 9) {
            System.err.println("Invalid promotion CSV line: " + csvLine);
            return null;
        }

        try {
            String promoCode = parts[0];
            String type = parts[1];
            double discountValue = Double.parseDouble(parts[2]);
            LocalDate startDate = LocalDate.parse(parts[3]);
            LocalDate endDate = LocalDate.parse(parts[4]);
            int usageLimit = Integer.parseInt(parts[5]);
            int usageCount = Integer.parseInt(parts[6]);
            double minimumAmount = Double.parseDouble(parts[7]);
            boolean isActive = Boolean.parseBoolean(parts[8]);

            Promotion promo = null;

            switch (type) {
                case "PERCENTAGE":
                    promo = new PercentageDiscount(promoCode, discountValue, startDate, endDate, usageLimit, minimumAmount);
                    break;
                case "FIXED":
                    promo = new FixedAmountDiscount(promoCode, discountValue, startDate, endDate, usageLimit, minimumAmount);
                    break;
                case "SEASONAL":
                    String seasonName = parts.length > 9 ? parts[9] : "Unknown Season";
                    promo = new SeasonalPromotion(promoCode, discountValue, startDate, endDate, usageLimit, minimumAmount, seasonName);
                    break;
                default:
                    System.err.println("Unknown promotion type: " + type);
                    return null;
            }

            promo.setUsageCount(usageCount);
            promo.setActive(isActive);
            return promo;

        } catch (Exception e) {
            System.err.println("Error parsing promotion: " + e.getMessage());
            return null;
        }
    }
}
