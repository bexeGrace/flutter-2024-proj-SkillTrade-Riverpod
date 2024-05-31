import 'package:skill_trade/domain/models/booking.dart';

abstract class IBookingsRemoteDataSource {
  Future<List<Booking>> fetchCustomerBookings(int customerId, String token, String endpoint);
  Future<List<Booking>> fetchTechnicianBookings(int technicianId, String token, String endpoint);
  Future<void> postBooking(Booking booking, String token, String endpoint);
  Future<void> updateBooking(int bookingId, Map<String, dynamic> updates, String token, String endpoint);
  Future<void> deleteBooking(int bookingId, String token, String endpoint);
}