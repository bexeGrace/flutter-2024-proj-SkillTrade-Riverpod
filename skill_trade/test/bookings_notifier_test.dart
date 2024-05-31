import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skill_trade/application/providers/providers.dart';
import 'package:skill_trade/domain/models/booking.dart';
import 'package:skill_trade/application/states/bookings_state.dart';
import 'package:skill_trade/infrastructure/repositories/bookings_repository_impl.dart';

import 'bookings_notifier_test.mocks.dart';


@GenerateMocks([BookingsRepositoryImpl])
void main() {
  late MockBookingsRepositoryImpl mockBookingsRepository;
  late ProviderContainer container;

  setUp(() {
    mockBookingsRepository = MockBookingsRepositoryImpl();
    container = ProviderContainer(
      overrides: [
        bookingsRepositoryProvider.overrideWithValue(mockBookingsRepository),
         ],
    );
  }); 

  tearDown(() {
    container.dispose();
  });

  group('BookingsNotifier', () {
    final booking = Booking(
      id: 1,
      customerId: 1,
      technicianId: 1,
      serviceNeeded: 'repair',
      serviceLocation: 'location',
      serviceDate: DateTime.now(),
      problemDescription: 'problem',
      bookedDate: DateTime.now(),
      status: 'pending',
    );

test('emits [BookingsLoading, BookingsLoaded] when LoadCustomerBookings event is added', () async {
  when(mockBookingsRepository.getCustomerBookings(1)).thenAnswer((_) async => [booking]);

  final bookingsNotifier = container.read(bookingsNotifierProvider.notifier);
  
  // Create a list to collect emitted states
  final List<BookingsState> states = [];
  
  // Listen to state changes and collect them in the list
  final listener = container.listen<BookingsState>(
    bookingsNotifierProvider,
    (previous, next) {
      states.add(next);
    },
  );

  bookingsNotifier.loadCustomerBookings(1);
  await container.pump();

  // Expect the collected states to match the expected sequence
  expect(states, [
    BookingsLoading(),
    BookingsLoaded([booking]),
  ]);
});


    
          test('emits [BookingsLoading, BookingsLoaded] when LoadTechnicianBookings event is added', () async {
      when(mockBookingsRepository.getTechnicianBookings(1)).thenAnswer((_) async => [booking]);

      final bookingsNotifier = container.read(bookingsNotifierProvider.notifier);
      final List<BookingsState> states = [];
      container.listen<BookingsState>(
        bookingsNotifierProvider,
        (previous, next) {
          states.add(next);
        },
      );

      bookingsNotifier.loadTechnicianBookings(1);
      await container.pump();

      expect(states, [
        BookingsLoading(),
        BookingsLoaded([booking]),
      ]);
    });

    test('emits [BookingsLoading, BookingsError] when LoadCustomerBookings event is added and an error occurs', () async {
      when(mockBookingsRepository.getCustomerBookings(1)).thenThrow(Exception('Failed to load bookings'));

      final bookingsNotifier = container.read(bookingsNotifierProvider.notifier);
      final List<BookingsState> states = [];
      container.listen<BookingsState>(
        bookingsNotifierProvider,
        (previous, next) {
          states.add(next);
        },
      );

      bookingsNotifier.loadCustomerBookings(1);
      await container.pump();

      expect(states, [
        BookingsLoading(),
        BookingsError('Exception: Failed to load bookings'),
      ]);
    });

    test('emits [BookingsLoading, BookingsError] when LoadTechnicianBookings event is added and an error occurs', () async {
      when(mockBookingsRepository.getTechnicianBookings(1)).thenThrow(Exception('Failed to load bookings'));

      final bookingsNotifier = container.read(bookingsNotifierProvider.notifier);
      final List<BookingsState> states = [];
      container.listen<BookingsState>(
        bookingsNotifierProvider,
        (previous, next) {
          states.add(next);
        },
      );

      bookingsNotifier.loadTechnicianBookings(1);
      await container.pump();

      expect(states, [
        BookingsLoading(),
        BookingsError('Exception: Failed to load bookings'),
      ]);
    });

    test('emits [BookingsLoading, BookingsLoaded] when PostBooking event is added and booking is created successfully', () async {
      when(mockBookingsRepository.createBooking(any)).thenAnswer((_) async => Future.value());
      when(mockBookingsRepository.getCustomerBookings(1)).thenAnswer((_) async => [booking]);

      final bookingsNotifier = container.read(bookingsNotifierProvider.notifier);
      final List<BookingsState> states = [];
      container.listen<BookingsState>(
        bookingsNotifierProvider,
        (previous, next) {
          states.add(next);
        },
      );

      bookingsNotifier.postBooking(
        customerId: 1,
        technicianId: 1,
        serviceNeeded: 'repair',
        serviceLocation: 'location',
        serviceDate: DateTime.now(),
        problemDescription: 'problem',
      );
      await container.pump();

      expect(states, await [
        BookingsLoading(),
        BookingsLoaded([booking]),
      ]);
    });

    test('emits [BookingsLoading, BookingsError] when PostBooking event is added and an error occurs', () async {
      when(mockBookingsRepository.createBooking(any)).thenThrow(Exception('Failed to create booking'));

      final bookingsNotifier = container.read(bookingsNotifierProvider.notifier);
      final List<BookingsState> states = [];
      container.listen<BookingsState>(
        bookingsNotifierProvider,
        (previous, next) {
          states.add(next);
        },
      );

      bookingsNotifier.postBooking(
        customerId: 1,
        technicianId: 1,
        serviceNeeded: 'repair',
        serviceLocation: 'location',
        serviceDate: DateTime.now(),
        problemDescription: 'problem',
      );
      await container.pump();

      expect(states,  [
        BookingsError('Exception: Failed to create booking'),
      ]);
    });

    test('emits [BookingsLoading, BookingsLoaded] when UpdateBooking event is added and booking is updated successfully', () async {
      when(mockBookingsRepository.updateBooking(any, any)).thenAnswer((_) async => Future.value());
      when(mockBookingsRepository.getCustomerBookings(1)).thenAnswer((_) async => [booking]);
      when(mockBookingsRepository.getTechnicianBookings(1)).thenAnswer((_) async => [booking]);

      final bookingsNotifier = container.read(bookingsNotifierProvider.notifier);
      final List<BookingsState> states = [];
      container.listen<BookingsState>(
        bookingsNotifierProvider,
        (previous, next) {
          states.add(next);
        },
      );

      bookingsNotifier.updateBooking(
        bookingId: 1,
        updates: {'status': 'completed'},
        whoUpdated: 'customer',
        updaterId: 1,
      );
      await container.pump();

      expect(states, await [
        BookingsLoading(),
        BookingsLoaded([booking]),
      ]);
    });

    test('emits [BookingsLoading, BookingsError] when UpdateBooking event is added and an error occurs', () async {
      when(mockBookingsRepository.updateBooking(any, any)).thenThrow(Exception('Failed to update booking'));

      final bookingsNotifier = container.read(bookingsNotifierProvider.notifier);
      final List<BookingsState> states = [];
      container.listen<BookingsState>(
        bookingsNotifierProvider,
        (previous, next) {
          states.add(next);
        },
      );

      bookingsNotifier.updateBooking(
        bookingId: 1,
        updates: {'status': 'completed'},
        whoUpdated: 'customer',
        updaterId: 1,
      );
      await container.pump();

      expect(states, await [
        BookingsError('Exception: Failed to update booking'),
      ]);
    });

    test('emits [BookingsLoading, BookingsLoaded] when DeleteBooking event is added and booking is deleted successfully', () async {
      when(mockBookingsRepository.deleteBooking(1)).thenAnswer((_) async => Future.value());
      when(mockBookingsRepository.getCustomerBookings(1)).thenAnswer((_) async => []);

      final bookingsNotifier = container.read(bookingsNotifierProvider.notifier);
      final List<BookingsState> states = [];
      container.listen<BookingsState>(
        bookingsNotifierProvider,
        (previous, next) {
          states.add(next);
        },
      );

      bookingsNotifier.deleteBooking(bookingId: 1, customerId: 1);
      await container.pump();

      expect(states, await  [
        BookingsLoading(),
        BookingsLoaded([]),
      ]);
    });

    test('emits [BookingsLoading, BookingsError] when DeleteBooking event is added and an error occurs', () async {
      when(mockBookingsRepository.deleteBooking(1)).thenThrow(Exception('Failed to delete booking'));

      final bookingsNotifier = container.read(bookingsNotifierProvider.notifier);
      final List<BookingsState> states = [];
      container.listen<BookingsState>(
        bookingsNotifierProvider,
        (previous, next) {
          states.add(next);
        },
      );

      bookingsNotifier.deleteBooking(bookingId: 1, customerId: 1);
      await container.pump();

      expect(states, await [
        BookingsError('Exception: Failed to delete booking'),
      ]);
    });
  });
}
