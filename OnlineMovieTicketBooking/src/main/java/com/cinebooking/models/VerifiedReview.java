package com.cinebooking.models;


public class VerifiedReview extends Review {

    public VerifiedReview() {
        super();
        setVerified(true);
    }

    public VerifiedReview(String reviewId,
                          String movieId,
                          String userId,
                          int rating,
                          String title,
                          String body,
                          String submissionDate,
                          String editDate,
                          String status,
                          boolean isSpoiler,
                          int helpfulCount) {
        super(reviewId, movieId, userId, rating, title, body, submissionDate, editDate,
                status, isSpoiler, helpfulCount, true);
        setVerified(true);
    }

    /**
     * Returns a Bootstrap-friendly review card with a "Verified Booking" badge.
     */
    @Override
    public String getDisplayCard() {
        String verifiedBadge = "<span class='badge bg-success ms-2'>Verified Booking</span>";
        String spoilerBadge = isSpoiler()
                ? "<span class='badge bg-danger ms-2'>Spoiler Alert</span>"
                : "";

        return "<div class='card shadow-sm mb-3 border-success border-1'>"
                + "<div class='card-body'>"
                + "<div class='d-flex justify-content-between align-items-start'>"
                + "<div>"
                + "<h5 class='card-title mb-1'>" + escapeHtml(safeText(getTitle())) + verifiedBadge + spoilerBadge + "</h5>"
                + "<div class='mb-2'>" + buildStarIcons() + " <small class='text-muted ms-2'>" + getRating() + "/5</small></div>"
                + "</div>"
                + "<small class='text-muted'>" + escapeHtml(safeText(getSubmissionDate())) + "</small>"
                + "</div>"
                + "<p class='card-text'>" + escapeHtml(safeText(getBody())) + "</p>"
                + "<div class='d-flex justify-content-between align-items-center'>"
                + "<small class='text-muted'>Helpful votes: " + getHelpfulCount() + "</small>"
                + (safeText(getEditDate()).isEmpty() ? "" : "<small class='text-muted'>Edited: " + escapeHtml(getEditDate()) + "</small>")
                + "</div>"
                + "</div>"
                + "</div>";
    }
}

