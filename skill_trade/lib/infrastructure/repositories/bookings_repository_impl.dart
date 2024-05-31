import 'package:skill_trade/domain/models/booking.dart';
import 'package:skill_trade/domain/repositories/bookings_repository.dart';
import 'package:skill_trade/infrastructure/data_sources/bookings_remote_data_source.dart';
import 'package:skill_trade/infrastructure/storage/storage.dart';

class BookingsRepositoryImpl implements IBookingsRepository {
  final IBookingsRemoteDataSource remoteDataSource;
  final SecureStorage secureStorage;

  BookingsRepositoryImpl(this.remoteDataSource, this.secureStorage);

  Future<String> _getEndpoint() async => await secureStorage.read("endpoint") ?? "";
  Future<String> _getToken() async => await secureStorage.read("token") ?? "";
  Future<String> _getId() async => await secureStorage.read("id") ?? "";

  @override
  Future<List<Booking>> getCustomerBookings(int customerId) async {
    final endpoint = await _getEndpoint();
    final token = await _getToken();
    return await remoteDataSource.fetchCustomerBookings(customerId, token, endpoint);
  }

  @override
  Future<List<Booking>> getTechnicianBookings(int technicianId) async {
    final endpoint = await _getEndpoint();
    final token = await _getToken();
    return await remoteDataSource.fetchTechnicianBookings(technicianId, token, endpoint);
  }

  @override
  Future<void> createBooking(Booking booking) async {
    final endpoint = await _getEndpoint();
    final token = await _getToken();
    await remoteDataSource.postBooking(booking, token, endpoint);
  }

  @override
  Future<void> updateBooking(int bookingId, Map<String, dynamic> updates) async {
    final endpoint = await _getEndpoint();
    final token = await _getToken();
    await remoteDataSource.updateBooking(bookingId, updates, token, endpoint);
  }

  @override
  Future<void> deleteBooking(int bookingId) async {
    final endpoint = await _getEndpoint();
    final token = await _getToken();
    await remoteDataSource.deleteBooking(bookingId, token, endpoint);
  }
}