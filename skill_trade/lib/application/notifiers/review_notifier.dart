import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/infrastructure/repositories/review_repository.dart';
import 'package:skill_trade/application/states/review_state.dart';

class ReviewsNotifier extends StateNotifier<ReviewsState> {
  final ReviewRepository reviewRepository;

  ReviewsNotifier({required this.reviewRepository}) : super(ReviewsLoading());

  Future<void> loadTechnicianReviews(int technicianId) async {
    state = ReviewsLoading();
    try {
      final reviews = await reviewRepository.getTechnicianReviews(technicianId);
      state = ReviewsLoaded(reviews);
    } catch (error) {
      state = ReviewsError(error.toString());
    }
  }

  Future<void> postReview({
    required int technicianId,
    required int customerId,
    required double rate,
    required String review,
  }) async {
    try {
      await reviewRepository.postReview(technicianId, customerId, rate, review);
      await loadTechnicianReviews(technicianId);
    } catch (error) {
      state = ReviewsError(error.toString());
    }
  }

  Future<void> updateReview({
    required int reviewId,
    required Map<String, dynamic> updates,
    required int technicianId,
  }) async {
    try {
      await reviewRepository.updateReview(reviewId, updates);
      await loadTechnicianReviews(technicianId);
    } catch (error) {
      state = ReviewsError(error.toString());
    }
  }

  Future<void> deleteReview({required int reviewId, required int technicianId}) async {
    try {
      await reviewRepository.deleteReview(reviewId);
      await loadTechnicianReviews(technicianId);
    } catch (error) {
      state = ReviewsError(error.toString());
    }
  }
}
