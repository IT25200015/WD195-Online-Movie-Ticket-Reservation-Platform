package com.cinebooking.services;

import com.cinebooking.models.Review;
import java.util.List;


public interface IReviewService {


    List<Review> getMovieReviews(String movieId);


    List<Review> getAllReviews();


    Review submitReview(Review review);


    boolean editReview(Review updated);



    boolean deleteReview(String reviewId);


    boolean updateReviewStatus(String reviewId, String newStatus);


    boolean upvoteReview(String reviewId);


    boolean reportReview(String reviewId);


    boolean hasUserReviewedMovie(String userId, String movieId);


    double getWeightedAverageRating(String movieId);


    boolean isEditWindowOpen(Review review);
}
