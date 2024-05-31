import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/application/states/bookings_state.dart';
import 'package:skill_trade/domain/models/booking.dart';
import 'package:skill_trade/domain/repositories/bookings_repository.dart';

class BookingsNotifier extends StateNotifier<BookingsState> {
  final IBookingsRepository bookingsRepository;

  BookingsNotifier({required this.bookingsRepository}) : super(BookingsLoading());

  Future<void> loadCustomerBookings(int customerId) async {
    state = BookingsLoading();
    try {
      final bookings = await bookingsRepository.getCustomerBookings(customerId);

      state = BookingsLoaded(bookings);
    } catch (error) {
      state = BookingsError(error.toString());
    }
  }

  Future<void> loadTechnicianBookings(int technicianId) async {
    state = BookingsLoading();
    try {
      final bookings = await bookingsRepository.getTechnicianBookings(technicianId);
      state = BookingsLoaded(bookings);
    } catch (error) {
      state = BookingsError(error.toString());
    }
  }

  Future<void> postBooking({
    required int? customerId,
    required int technicianId,
    required String serviceNeeded,
    required DateTime serviceDate,
    required String serviceLocation,
    required String problemDescription,
  }) async {
    try {
      final booking = Booking(
        id: 0,
        customerId: customerId!,
        technicianId: technicianId,
        serviceNeeded: serviceNeeded,
        serviceLocation: serviceLocation,
        serviceDate: serviceDate,
        problemDescription: problemDescription,
        bookedDate: DateTime.now(),
        status: "pending",
      );
      await bookingsRepository.createBooking(booking);
      await loadCustomerBookings(customerId);
    } catch (error) {
      state = BookingsError(error.toString());
    }
  }

  Future<void> updateBooking({
    required int bookingId,
    required Map<String, dynamic> updates,
    required String whoUpdated,
    required int updaterId,
  }) async {
    try {
      await bookingsRepository.updateBooking(bookingId, updates);
      if (whoUpdated == "technician") {
        await loadTechnicianBookings(updaterId);
      } else {
        await loadCustomerBookings(updaterId);
      }
    } catch (error) {
      state = BookingsError(error.toString());
    }
  }

  Future<void> deleteBooking({
    required int bookingId,
    required int customerId,
  }) async {
    try {
      await bookingsRepository.deleteBooking(bookingId);
      await loadCustomerBookings(customerId);
    } catch (error) {
      state = BookingsError(error.toString());
    }
  }
}

