package com.cinebooking.models;


public abstract class Review {

    private String reviewId;
    private String movieId;
    private String userId;
    private int rating; // 1 to 5 stars
    private String title;
    private String body;
    private String submissionDate;
    private String editDate;
    private String status;
    private boolean isSpoiler;
    private int helpfulCount;
    private boolean isVerified;
    private int reportCount;

    public Review() {
        // Default constructor needed for flexible object creation.
    }

    public Review(String reviewId,
                  String movieId,
                  String userId,
                  int rating,
                  String title,
                  String body,
                  String submissionDate,
                  String editDate,
                  String status,
                  boolean isSpoiler,
                  int helpfulCount,
                  boolean isVerified) {
        this.reviewId = reviewId;
        this.movieId = movieId;
        this.userId = userId;
        setRating(rating);
        this.title = title;
        this.body = body;
        this.submissionDate = submissionDate;
        this.editDate = editDate;
        this.status = status;
        this.isSpoiler = isSpoiler;
        setHelpfulCount(helpfulCount);
        this.isVerified = isVerified;
    }

    /**
     * Child classes must provide their own Bootstrap-friendly review card HTML.
     */
    public abstract String getDisplayCard();

    // -----------------------------
    // Encapsulated getters/setters
    // -----------------------------

    public String getReviewId() {
        return reviewId;
    }

    public void setReviewId(String reviewId) {
        this.reviewId = reviewId;
    }

    public String getMovieId() {
        return movieId;
    }

    public void setMovieId(String movieId) {
        this.movieId = movieId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        if (rating < 1) {
            this.rating = 1;
        } else if (rating > 5) {
            this.rating = 5;
        } else {
            this.rating = rating;
        }
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public String getSubmissionDate() {
        return submissionDate;
    }

    public void setSubmissionDate(String submissionDate) {
        this.submissionDate = submissionDate;
    }

    public String getEditDate() {
        return editDate;
    }

    public void setEditDate(String editDate) {
        this.editDate = editDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isSpoiler() {
        return isSpoiler;
    }

    public void setSpoiler(boolean spoiler) {
        isSpoiler = spoiler;
    }

    public int getHelpfulCount() {
        return helpfulCount;
    }

    public void setHelpfulCount(int helpfulCount) {
        this.helpfulCount = Math.max(0, helpfulCount);
    }

    public boolean isVerified() {
        return isVerified;
    }

    public void setVerified(boolean verified) {
        isVerified = verified;
    }

    public int getReportCount() {
        return reportCount;
    }

    public void setReportCount(int reportCount) {
        this.reportCount = Math.max(0, reportCount);
    }


    // Small helper methods for HTML output
    // -----------------------------

    protected String escapeHtml(String text) {
        if (text == null) {
            return "";
        }
        return text
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    protected String buildStarIcons() {
        StringBuilder html = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            if (i <= rating) {
                html.append("<i class='bi bi-star-fill text-warning'></i>");
            } else {
                html.append("<i class='bi bi-star text-warning'></i>");
            }
        }
        return html.toString();
    }

    protected String safeText(String value) {
        return value == null ? "" : value;
    }
}

