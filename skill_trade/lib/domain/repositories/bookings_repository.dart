import 'package:skill_trade/domain/models/booking.dart';

abstract class IBookingsRepository {
  Future<List<Booking>> getCustomerBookings(int customerId);
  Future<List<Booking>> getTechnicianBookings(int technicianId);
  Future<void> createBooking(Booking booking);
  Future<void> updateBooking(int bookingId, Map<String, dynamic> updates);
  Future<void> deleteBooking(int bookingId);
}