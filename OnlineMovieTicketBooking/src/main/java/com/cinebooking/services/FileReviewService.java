package com.cinebooking.services;

import com.cinebooking.models.PublicReview;
import com.cinebooking.models.Review;
import com.cinebooking.models.VerifiedReview;

import java.io.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;


public class FileReviewService implements IReviewService {

    // ── Thread-safety lock (shared across all instances of this class) ──
    private static final Object FILE_LOCK = new Object();

    private static final DateTimeFormatter DATE_FMT =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    private static final int    AUTO_HIDE_REPORT_THRESHOLD = 5;
    private static final int    EDIT_LIMIT_DAYS            = 7;
    private static final double VERIFIED_WEIGHT            = 1.5;
    private static final double PUBLIC_WEIGHT              = 1.0;

    /** Absolute path to the pipe-delimited reviews.txt in the deployed webapp. */
    private final String reviewsFilePath;

    /**
     * @param reviewsFilePath absolute path — must be getRealPath("/data/reviews.txt")
     * @param ratingsFilePath kept for API compatibility; currently unused
     */
    public FileReviewService(String reviewsFilePath, String ratingsFilePath) {
        this.reviewsFilePath = reviewsFilePath;
        ensureFileExists(reviewsFilePath);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // IReviewService implementation
    // ─────────────────────────────────────────────────────────────────────────

    @Override
    public List<Review> getMovieReviews(String movieId) {
        if (movieId == null || movieId.trim().isEmpty()) return new ArrayList<>();
        List<Review> result = new ArrayList<>();
        for (Review r : readAll()) {
            if (movieId.trim().equals(r.getMovieId() == null ? null : r.getMovieId().trim())) {
                result.add(r);
            }
        }
        return result;
    }

    @Override
    public List<Review> getAllReviews() {
        return readAll();
    }

    /**
     * Persists a new review.
     * Enforces anti-duplicate: one review per (userId × movieId).
     */
    @Override
    public Review submitReview(Review review) {
        if (review == null || review.getMovieId() == null || review.getUserId() == null) {
            return null;
        }

        synchronized (FILE_LOCK) {
            // Anti-duplicate check inside the lock to prevent race conditions
            if (hasUserReviewedMovieUnlocked(review.getUserId(), review.getMovieId())) {
                return null;
            }

            review.setReviewId(UUID.randomUUID().toString().substring(0, 12));
            String now = LocalDateTime.now().format(DATE_FMT);
            review.setSubmissionDate(now);
            review.setEditDate("");
            if (review.getStatus() == null || review.getStatus().isBlank()) {
                review.setStatus("PENDING");
            }
            review.setHelpfulCount(0);

            List<Review> all = readAllUnlocked();
            all.add(review);
            writeAllUnlocked(all);
        }
        return review;
    }

    /**
     * Updates an existing review in-place.
     * Enforces the 7-day edit window from the original submissionDate.
     */
    @Override
    public boolean editReview(Review updated) {
        if (updated == null || updated.getReviewId() == null) return false;

        synchronized (FILE_LOCK) {
            List<Review> all = readAllUnlocked();
            boolean found = false;
            for (int i = 0; i < all.size(); i++) {
                Review existing = all.get(i);
                if (existing.getReviewId().equals(updated.getReviewId())) {

                    // Enforce 7-day edit limit
                    if (!canEditReview(existing)) {
                        return false;
                    }

                    updated.setSubmissionDate(existing.getSubmissionDate()); // keep original date
                    updated.setEditDate(LocalDateTime.now().format(DATE_FMT));
                    updated.setStatus("PENDING"); // re-moderate after edit
                    all.set(i, updated);
                    found = true;
                    break;
                }
            }
            if (found) {
                writeAllUnlocked(all);
            }
            return found;
        }
    }

    /**
     * Permanently removes a review by its ID.
     */
    @Override
    public boolean deleteReview(String reviewId) {
        if (reviewId == null || reviewId.isBlank()) return false;

        synchronized (FILE_LOCK) {
            List<Review> all = readAllUnlocked();
            boolean removed = all.removeIf(r -> reviewId.equals(r.getReviewId()));
            if (removed) {
                writeAllUnlocked(all);
            }
            return removed;
        }
    }

    /**
     * Updates the moderation status (PENDING / APPROVED / REJECTED / HIDDEN).
     */
    @Override
    public boolean updateReviewStatus(String reviewId, String newStatus) {
        if (reviewId == null || newStatus == null) return false;

        synchronized (FILE_LOCK) {
            List<Review> all = readAllUnlocked();
            boolean found = false;
            for (Review r : all) {
                if (reviewId.equals(r.getReviewId())) {
                    r.setStatus(newStatus.toUpperCase());
                    found = true;
                    break;
                }
            }
            if (found) {
                writeAllUnlocked(all);
            }
            return found;
        }
    }

    /** Increments the helpful/upvote counter. */
    @Override
    public boolean upvoteReview(String reviewId) {
        if (reviewId == null || reviewId.isBlank()) return false;

        synchronized (FILE_LOCK) {
            List<Review> all = readAllUnlocked();
            boolean found = false;
            for (Review r : all) {
                if (reviewId.equals(r.getReviewId())) {
                    r.setHelpfulCount(r.getHelpfulCount() + 1);
                    found = true;
                    break;
                }
            }
            if (found) writeAllUnlocked(all);
            return found;
        }
    }

    /** Increments the report counter; auto-hides at threshold 5. */
    @Override
    public boolean reportReview(String reviewId) {
        if (reviewId == null || reviewId.isBlank()) return false;

        synchronized (FILE_LOCK) {
            List<Review> all = readAllUnlocked();
            boolean found = false;
            for (Review r : all) {
                if (reviewId.equals(r.getReviewId())) {
                    int newCount = r.getReportCount() + 1;
                    r.setReportCount(newCount);
                    if (newCount >= AUTO_HIDE_REPORT_THRESHOLD) {
                        r.setStatus("HIDDEN");
                    }
                    found = true;
                    break;
                }
            }
            if (found) writeAllUnlocked(all);
            return found;
        }
    }

    @Override
    public boolean hasUserReviewedMovie(String userId, String movieId) {
        if (userId == null || movieId == null) return false;
        synchronized (FILE_LOCK) {
            return hasUserReviewedMovieUnlocked(userId, movieId);
        }
    }

    @Override
    public double getWeightedAverageRating(String movieId) {
        List<Review> reviews = getMovieReviews(movieId);
        if (reviews.isEmpty()) return 0.0;

        double weightedSum = 0.0;
        double totalWeight = 0.0;
        for (Review r : reviews) {
            double w = r.isVerified() ? VERIFIED_WEIGHT : PUBLIC_WEIGHT;
            weightedSum += r.getRating() * w;
            totalWeight += w;
        }
        return totalWeight == 0 ? 0.0 : weightedSum / totalWeight;
    }

    @Override
    public boolean isEditWindowOpen(Review review) {
        return canEditReview(review);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Private helpers — "Unlocked" variants are called inside a synchronized block
    // ─────────────────────────────────────────────────────────────────────────

    private boolean hasUserReviewedMovieUnlocked(String userId, String movieId) {
        for (Review r : readAllUnlocked()) {
            if (userId.equalsIgnoreCase(r.getUserId())
                    && movieId.trim().equals(r.getMovieId() == null ? null : r.getMovieId().trim())) {
                return true;
            }
        }
        return false;
    }

    private boolean canEditReview(Review review) {
        String dateStr = review.getSubmissionDate();
        if (dateStr == null || dateStr.isBlank()) return true;
        try {
            LocalDate submitted = LocalDate.parse(dateStr.substring(0, 10));
            long daysSince = ChronoUnit.DAYS.between(submitted, LocalDate.now());
            return daysSince <= EDIT_LIMIT_DAYS;
        } catch (Exception e) {
            return true; // parse failure → be permissive
        }
    }

    private void ensureFileExists(String path) {
        File f = new File(path);
        try {
            if (f.getParentFile() != null) f.getParentFile().mkdirs();
            f.createNewFile();
        } catch (IOException ignored) { /* best effort */ }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Flat-file persistence — MUST be called from within synchronized(FILE_LOCK)
    //
    // Format: reviewId|movieId|userId|rating|title|body|submissionDate|
    //         editDate|status|isSpoiler|helpfulCount|isVerified|reportCount
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Reads all reviews from disk. Caller is responsible for locking.
     */
    private List<Review> readAllUnlocked() {
        List<Review> list = new ArrayList<>();
        File f = new File(reviewsFilePath);
        if (!f.exists() || f.length() == 0) return list;

        try (BufferedReader br = new BufferedReader(new FileReader(f))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (line.isBlank()) continue;
                Review r = fromLine(line);
                if (r != null) list.add(r);
            }
        } catch (IOException e) {
            System.err.println("[FileReviewService] Read error: " + e.getMessage());
        }
        return list;
    }

    /** Public read — acquires lock, reads, releases. */
    private List<Review> readAll() {
        synchronized (FILE_LOCK) {
            return readAllUnlocked();
        }
    }


    private void writeAllUnlocked(List<Review> reviews) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(reviewsFilePath, false))) {
            for (Review r : reviews) {
                bw.write(toLine(r));
                bw.newLine();
            }
            bw.flush(); // guarantee immediate write to storage
        } catch (IOException e) {
            System.err.println("[FileReviewService] Write error: " + e.getMessage());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Line serialisation / deserialisation
    // ─────────────────────────────────────────────────────────────────────────

    private String toLine(Review r) {
        return join(
                safe(r.getReviewId()),
                safe(r.getMovieId()),
                safe(r.getUserId()),
                String.valueOf(r.getRating()),
                safe(r.getTitle()),
                safe(r.getBody()),
                safe(r.getSubmissionDate()),
                safe(r.getEditDate()),
                safe(r.getStatus()),
                String.valueOf(r.isSpoiler()),
                String.valueOf(r.getHelpfulCount()),
                String.valueOf(r.isVerified()),
                String.valueOf(r.getReportCount())
        );
    }

    private Review fromLine(String line) {
        String[] p = line.split("\\|", -1);
        if (p.length < 12) return null;
        try {
            String  reviewId       = p[0].trim();
            String  movieId        = p[1].trim();
            String  userId         = p[2].trim();
            int     rating         = Integer.parseInt(p[3].trim());
            String  title          = p[4].trim();
            String  body           = p[5].trim();
            String  submissionDate = p[6].trim();
            String  editDate       = p[7].trim();
            String  status         = p[8].trim();
            boolean isSpoiler      = Boolean.parseBoolean(p[9].trim());
            int     helpfulCount   = parseIntSafe(p[10].trim(), 0);
            boolean isVerified     = Boolean.parseBoolean(p[11].trim());
            int     reportCount    = p.length > 12 ? parseIntSafe(p[12].trim(), 0) : 0;

            Review r = isVerified
                    ? new VerifiedReview(reviewId, movieId, userId, rating, title, body,
                                         submissionDate, editDate, status, isSpoiler, helpfulCount)
                    : new PublicReview(reviewId, movieId, userId, rating, title, body,
                                       submissionDate, editDate, status, isSpoiler, helpfulCount);
            r.setReportCount(reportCount);
            return r;
        } catch (Exception e) {
            System.err.println("[FileReviewService] Skipping bad line: " + e.getMessage());
            return null;
        }
    }

    // Escape pipe chars to avoid corrupting the delimiter
    private static String safe(String s) {
        if (s == null) return "";
        return s.replace("|", "&#124;");
    }

    private static String join(String... parts) {
        return String.join("|", parts);
    }

    private static int parseIntSafe(String s, int fallback) {
        try { return Integer.parseInt(s); } catch (Exception e) { return fallback; }
    }
}
