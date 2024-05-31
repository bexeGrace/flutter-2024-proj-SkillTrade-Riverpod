import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:skill_trade/models/booking.dart';
import 'package:skill_trade/models/technician.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:skill_trade/riverpod/secure_storage_provider.dart';
import 'package:skill_trade/riverpod/technician_provider.dart';


import '../ip_info.dart'; 

class BookingsState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final List<Booking> bookings;

  BookingsState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.bookings = const [],
  });

  BookingsState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    List<Booking>? bookings,
  }) {
    return BookingsState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      bookings: bookings ?? this.bookings,
    );
  }
}


// Assuming Booking and SecureStorageService are defined elsewhere
class BookingsNotifier extends StateNotifier<BookingsState> {
  final SecureStorageService _secureStorageService;

  BookingsNotifier(this._secureStorageService) : super(BookingsState());

  Future<void> fetchBookings() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final token = await _secureStorageService.read("token");
      final role = await _secureStorageService.read('role');
      final id = await _secureStorageService.read('userId');

      final response = await http.get(
        Uri.parse('http://$endpoint:9000/bookings/$role/$id'),
        headers: { 
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
        },
      );

      print("fetched bookings role $role id $id $response");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> bookingsJson = data["bookings"];
        print("fetched bookings successfully $bookingsJson");

        final bookings = bookingsJson.map((json) => Booking.fromJson(json)).toList();
        state = state.copyWith(isLoading: false, isSuccess: true, bookings: bookings);
      } else {
        throw Exception('Failed to load bookings');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> updateBooking(Map<String, dynamic> booking, int id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final token = await _secureStorageService.read("token");
      print("hey booking $booking, $id");
      final response = await http.patch(
        Uri.parse('http://$endpoint:9000/bookings/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(booking),
      );
      print("hey, response ${response.statusCode}, $response");

      if (response.statusCode == 200) {
        await fetchBookings();
      } else {
        throw Exception('Failed to update booking');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> createBooking(Map<String, dynamic> booking) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final token = await _secureStorageService.read("token");
      final id = await _secureStorageService.read('userId');
      if (id == null) {
        throw Exception("no customer no booking");
      }

      booking["customerId"] = int.parse(id);

      print("creating booking $booking");
      final response = await http.post(
        Uri.parse('http://$endpoint:9000/bookings'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(booking),
      );
      print("create response ${response.statusCode}, $response, ${response.body}");

      if (response.statusCode == 201) {
        await fetchBookings();
      } else {
        throw Exception('Failed to create booking');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> deleteBooking(int id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final token = await _secureStorageService.read("token");
      print("deleting booking $id");
      final response = await http.delete(
        Uri.parse('http://$endpoint:9000/bookings/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print("delete response ${response.statusCode}, $response");

      if (response.statusCode == 200) {
        await fetchBookings();
      } else {
        throw Exception('Failed to delete booking');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final bookingProvider = StateNotifierProvider<BookingsNotifier, BookingsState>((ref) {
  final secureStorageService = ref.read(secureStorageProvider);
  return BookingsNotifier(secureStorageService);
});

final bookingFetchProvider = FutureProvider.autoDispose<void>((ref) async {
  final bookingNotifier = ref.read(bookingProvider.notifier);
  await bookingNotifier.fetchBookings();
});
