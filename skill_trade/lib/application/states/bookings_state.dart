import 'package:equatable/equatable.dart';
import 'package:skill_trade/domain/models/booking.dart';

abstract class BookingsState extends Equatable {
  const BookingsState();

  @override
  List<Object?> get props => [];
}

class BookingsLoading extends BookingsState {}

class BookingsLoaded extends BookingsState {
  final List<Booking> bookings;

  const BookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

class BookingsError extends BookingsState {
  final String error;

  const BookingsError(this.error);

  @override
  List<Object?> get props => [error];
}
