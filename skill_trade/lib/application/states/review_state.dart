import 'package:equatable/equatable.dart';
import 'package:skill_trade/domain/models/review.dart';

abstract class ReviewsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReviewsLoading extends ReviewsState {}

class ReviewsLoaded extends ReviewsState {
  final List<Review> reviews;

  ReviewsLoaded(this.reviews);

  @override
  List<Object?> get props => [reviews];
}

class ReviewsError extends ReviewsState {
  final String error;

  ReviewsError(this.error);

  @override
  List<Object?> get props => [error];
}
