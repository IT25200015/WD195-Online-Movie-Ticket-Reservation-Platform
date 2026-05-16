package cinebooking.models;

import com.cinebooking.models.Promotion;

import java.time.LocalDate;

/**
 * Concrete Promotion subclass for fixed amount discounts.
 * Uses Polymorphism - overrides calculateDiscount() and getPromotionType() methods.
 * Example: "SAVE500" gives fixed 500 rupees discount on booking.
 */
public class FixedAmountDiscount extends Promotion {
    private static final long serialVersionUID = 1L;

    /**
     * Constructor for FixedAmountDiscount
     * @param promoCode Unique promotion code
     * @param discountAmount Fixed amount to discount (e.g., 500 rupees)
     * @param startDate Promotion start date
     * @param endDate Promotion end date
     * @param usageLimit Max times this promo can be used
     * @param minimumAmount Minimum booking amount to apply this promo
     */
    public FixedAmountDiscount(String promoCode, double discountAmount,
                               LocalDate startDate, LocalDate endDate,
                               int usageLimit, double minimumAmount) {
        super(promoCode, discountAmount, startDate, endDate, usageLimit, minimumAmount);
    }

    /**
     * Calculates discount as a fixed amount.
     * Implementation of Polymorphism - specific logic for fixed amount discount.
     */
    @Override
    public double calculateDiscount(double price) {
        if (price < 0) {
            return 0;
        }

        // Return fixed discount but not more than the booking amount
        return Math.min(getDiscountValue(), price);
    }

    /**
     * Returns the type identifier for this promotion.
     * Used when saving to file to identify the correct subclass.
     */
    @Override
    public String getPromotionType() {
        return "FIXED";
    }

    @Override
    public String toString() {
        return "FixedAmountDiscount{" +
                "promoCode='" + getPromoCode() + '\'' +
                ", discountAmount=" + getDiscountValue() +
                ", usageCount=" + getUsageCount() + "/" + getUsageLimit() +
                ", isActive=" + isActive() +
                '}';
    }
}
