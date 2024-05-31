import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skill_trade/domain/models/booking.dart';
import 'package:skill_trade/infrastructure/data_sources/bookings_remote_data_source.dart';

class BookingsRemoteDataSourceImpl implements IBookingsRemoteDataSource {
  final http.Client httpClient;

  BookingsRemoteDataSourceImpl(this.httpClient);

  @override
  Future<List<Booking>> fetchCustomerBookings(int customerId, String token, String endpoint) async {
    final headers = {"Authorization": "Bearer $token"};
    final response = await httpClient.get(Uri.parse('http://$endpoint:9000/bookings/customer/$customerId'), headers: headers);
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final bookingsJson = data["bookings"] as List<dynamic>;
      return bookingsJson.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Error fetching customer bookings');
    }
  }

  @override
  Future<List<Booking>> fetchTechnicianBookings(int technicianId, String token, String endpoint) async {
    final headers = {"Authorization": "Bearer $token"};
    final response = await httpClient.get(Uri.parse('http://$endpoint:9000/bookings/technician/$technicianId'), headers: headers);
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final bookingsJson = data["bookings"] as List<dynamic>;

      return bookingsJson.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Error fetching technician bookings');
    }
  }

  @override
  Future<void> postBooking(Booking booking, String token, String endpoint) async {
    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
    
    final response = await httpClient.post(
      Uri.parse('http://$endpoint:9000/bookings'),
      headers: headers,
      body: json.encode(booking.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Error posting booking');
    }
  }

  @override
  Future<void> updateBooking(int bookingId, Map<String, dynamic> updates, String token, String endpoint) async {
    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    final response = await httpClient.patch(
      Uri.parse('http://$endpoint:9000/bookings/$bookingId'),
      headers: headers,
      body: json.encode(updates),
    );

    if (response.statusCode != 200) {
      throw Exception('Error updating booking');
    }
  }

  @override
  Future<void> deleteBooking(int bookingId, String token, String endpoint) async {
    final headers = {"Authorization": "Bearer $token"};

    final response = await httpClient.delete(
      Uri.parse('http://$endpoint:9000/bookings/$bookingId'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Error deleting booking');
    }
  }
}