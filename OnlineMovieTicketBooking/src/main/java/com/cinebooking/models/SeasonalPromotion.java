package com.cinebooking.models;

import java.time.LocalDate;

/**
 * Concrete Promotion subclass for seasonal promotions.
 * Uses Polymorphism - overrides calculateDiscount() and getPromotionType() methods.
 * Example: "DIWALI20" gives 20% discount during Diwali season.
 */
public class SeasonalPromotion extends PercentageDiscount {
    private static final long serialVersionUID = 1L;

    private String seasonName;

    /**
     * Constructor for SeasonalPromotion
     * @param promoCode Unique promotion code
     * @param discountPercentage Percentage to discount
     * @param startDate Promotion start date
     * @param endDate Promotion end date
     * @param usageLimit Max times this promo can be used
     * @param minimumAmount Minimum booking amount to apply this promo
     * @param seasonName Name of the season
     */
    public SeasonalPromotion(String promoCode, double discountPercentage,
                             LocalDate startDate, LocalDate endDate,
                             int usageLimit, double minimumAmount,
                             String seasonName) {
        super(promoCode, discountPercentage, startDate, endDate, usageLimit, minimumAmount);
        this.seasonName = seasonName;
    }

    /**
     * Returns the type identifier for this promotion.
     * Used when saving to file to identify the correct subclass.
     */
    @Override
    public String getPromotionType() {
        return "SEASONAL";
    }

    /**
     * Gets the season name
     */
    public String getSeasonName() {
        return seasonName;
    }

    public void setSeasonName(String seasonName) {
        this.seasonName = seasonName;
    }

    @Override
    public boolean isValidForUse(double bookingAmount) {
        // Additional date logic could go here based on seasonName
        // For now, relies on super class date checks
        return super.isValidForUse(bookingAmount);
    }
    
    @Override
    public String toFileString() {
        // Append season name to the standard promotion serialization
        return super.toFileString() + "," + seasonName;
    }

    @Override
    public String toString() {
        return "SeasonalPromotion{" +
                "promoCode='" + getPromoCode() + '\'' +
                ", season='" + seasonName + '\'' +
                ", discountPercentage=" + getDiscountValue() + "%" +
                ", usageCount=" + getUsageCount() + "/" + getUsageLimit() +
                ", isActive=" + isActive() +
                '}';
    }
}
