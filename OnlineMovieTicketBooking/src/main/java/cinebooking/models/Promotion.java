package cinebooking.models;

import java.io.Serializable;
import java.time.LocalDate;

/**
 * Abstract base class for all types of promotions.
 * Uses Abstraction principle - defines common structure for all promotions.
 * Uses Encapsulation - protects internal state with private fields and getters/setters.
 * Demonstrating OOP concepts: Abstraction, Encapsulation.
 */
public abstract class Promotion implements Serializable {
    private static final long serialVersionUID = 1L;

    private String promoCode;
    private double discountValue;
    private LocalDate startDate;
    private LocalDate endDate;
    private int usageLimit;
    private int usageCount;
    private double minimumAmount;
    private boolean isActive;

    public Promotion(String promoCode, double discountValue,
                     LocalDate startDate, LocalDate endDate,
                     int usageLimit, double minimumAmount) {
        this.promoCode = promoCode;
        this.discountValue = discountValue;
        this.startDate = startDate;
        this.endDate = endDate;
        this.usageLimit = usageLimit;
        this.minimumAmount = minimumAmount;
        this.usageCount = 0;
        this.isActive = true;
    }

    public abstract double calculateDiscount(double price);

    public abstract String getPromotionType();

    public String getPromoCode() {
        return promoCode;
    }

    public void setPromoCode(String promoCode) {
        this.promoCode = promoCode;
    }

    public double getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(double discountValue) {
        this.discountValue = discountValue;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public int getUsageLimit() {
        return usageLimit;
    }

    public void setUsageLimit(int usageLimit) {
        this.usageLimit = usageLimit;
    }

    public int getUsageCount() {
        return usageCount;
    }

    public void setUsageCount(int usageCount) {
        this.usageCount = usageCount;
    }

    public double getMinimumAmount() {
        return minimumAmount;
    }

    public void setMinimumAmount(double minimumAmount) {
        this.minimumAmount = minimumAmount;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public void incrementUsage() {
        if (usageCount < usageLimit) {
            usageCount++;
        }
    }

    /**
     * Alias method for backward compatibility
     */
    public void incrementUsageCount() {
        incrementUsage();
    }

    public boolean isValidForUse(double bookingAmount) {
        LocalDate today = LocalDate.now();

        if (!isActive) {
            return false;
        }

        if (today.isBefore(startDate) || today.isAfter(endDate)) {
            return false;
        }

        if (usageCount >= usageLimit) {
            return false;
        }

        if (bookingAmount < minimumAmount) {
            return false;
        }

        return true;
    }

    public void toggleStatus() {
        this.isActive = !this.isActive;
    }

    /**
     * Returns a CSV-formatted string representation for file storage.
     * Format: promoCode,type,discountValue,startDate,endDate,usageLimit,usageCount,minimumAmount,isActive
     */
    public String toFileString() {
        return promoCode + "," + getPromotionType() + "," + discountValue + "," +
               startDate + "," + endDate + "," + usageLimit + "," + usageCount + "," +
               minimumAmount + "," + isActive;
    }

    @Override
    public String toString() {
        return "Promotion{" +
                "promoCode='" + promoCode + '\'' +
                ", discountValue=" + discountValue +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", usageLimit=" + usageLimit +
                ", usageCount=" + usageCount +
                ", minimumAmount=" + minimumAmount +
                ", isActive=" + isActive +
                '}';
    }
}
