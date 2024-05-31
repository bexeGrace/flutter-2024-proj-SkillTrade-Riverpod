import 'package:skill_trade/domain/models/review.dart';
import 'package:skill_trade/infrastructure/data_sources/review_remote_data_source.dart';

class ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepository({required this.remoteDataSource});

  Future<List<Review>> getTechnicianReviews(int technicianId) async {
    return await remoteDataSource.fetchTechnicianReviews(technicianId);
  }

  Future<void> postReview(int technicianId, int customerId, double rate, String review) async {
    await remoteDataSource.postReview(technicianId, customerId, rate, review);
  }

  Future<void> updateReview(int reviewId, Map<String, dynamic> updates) async {
    await remoteDataSource.updateReview(reviewId, updates);
  }

  Future<void> deleteReview(int reviewId) async {
    await remoteDataSource.deleteReview(reviewId);
  }
}