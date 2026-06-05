package com.cinebooking.models;


public class PublicReview extends Review {

    public PublicReview() {
        super();
        setVerified(false);
    }

    public PublicReview(String reviewId,
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
                status, isSpoiler, helpfulCount, false);
        setVerified(false);
    }

    /**
     * Returns a Bootstrap-friendly review card for a normal public review.
     */
    @Override
    public String getDisplayCard() {
        String badge = "<span class='badge bg-secondary ms-2'>Public Review</span>";
        String spoilerBadge = isSpoiler()
                ? "<span class='badge bg-danger ms-2'>Spoiler Alert</span>"
                : "";

        return "<div class='card shadow-sm mb-3 border-0'>"
                + "<div class='card-body'>"
                + "<div class='d-flex justify-content-between align-items-start'>"
                + "<div>"
                + "<h5 class='card-title mb-1'>" + escapeHtml(safeText(getTitle())) + badge + spoilerBadge + "</h5>"
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
    /**
     * Static version of escapeHtml for use in JSP scriptlets.
     */
    public static String escapeStatic(String text) {
        if (text == null) return "";
        return text
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}

