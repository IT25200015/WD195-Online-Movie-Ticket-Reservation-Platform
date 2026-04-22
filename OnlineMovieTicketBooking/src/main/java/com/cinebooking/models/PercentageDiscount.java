package com.cinebooking.models;

import java.time.LocalDate;

/**
 * Concrete Promotion subclass for percentage-based discounts.
 * Uses Polymorphism - overrides calculateDiscount() and getPromotionType() methods.
 * Example: "SAVE10" gives 10% discount on booking amount.
 */
public class PercentageDiscount extends Promotion {
    private static final long serialVersionUID = 1L;

    /**
     * Constructor for PercentageDiscount
     * @param promoCode Unique promotion code
     * @param discountPercentage Percentage to discount (e.g., 10 for 10%)
     * @param startDate Promotion start date
     * @param endDate Promotion end date
     * @param usageLimit Max times this promo can be used
     * @param minimumAmount Minimum booking amount to apply this promo
     */
    public PercentageDiscount(String promoCode, double discountPercentage,
                              LocalDate startDate, LocalDate endDate,
                              int usageLimit, double minimumAmount) {
        super(promoCode, discountPercentage, startDate, endDate, usageLimit, minimumAmount);
    }

    /**
     * Calculates discount as a percentage of the booking amount.
     * Implementation of Polymorphism - specific logic for percentage discount.
     */
    @Override
    public double calculateDiscount(double price) {
        if (price < 0) {
            return 0;
        }

        // Calculate percentage discount
        double discount = price * (getDiscountValue() / 100);

        // Cap the discount - cannot exceed the price itself
        return Math.min(discount, price);
    }

    /**
     * Returns the type identifier for this promotion.
     * Used when saving to file to identify the correct subclass.
     */
    @Override
    public String getPromotionType() {
        return "PERCENTAGE";
    }

    @Override
    public String toString() {
        return "PercentageDiscount{" +
                "promoCode='" + getPromoCode() + '\'' +
                ", discountPercentage=" + getDiscountValue() + "%" +
                ", usageCount=" + getUsageCount() + "/" + getUsageLimit() +
                ", isActive=" + isActive() +
                '}';
    }
}
