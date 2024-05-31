import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/models/booking.dart';
import 'package:skill_trade/presentation/widgets/customer_booking.dart';
import 'package:skill_trade/riverpod/booking_provider.dart';
import 'package:skill_trade/riverpod/technician_provider.dart';

class CustomerBookings extends ConsumerStatefulWidget {
  const CustomerBookings({Key? key}) : super(key: key);

  @override
  _CustomerBookingsState createState() => _CustomerBookingsState();
}

class _CustomerBookingsState extends ConsumerState<CustomerBookings> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ref.read(bookingProvider.notifier).fetchBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingProvider);

    if (bookingState.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (bookingState.errorMessage != null) {
      return Center(child: Text(bookingState.errorMessage!));
    } else {
      return ListView.builder(
        itemCount: bookingState.bookings.length,
        itemBuilder: (context, index) {
          final booking = bookingState.bookings[index];

          return Consumer(
            builder: (context, watch, _) {
              final technicianAsync = ref.watch(technicianByIdProvider(booking.technicianId));

              return technicianAsync.when(
                data: (technician) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: CustomerBooking(
                      technician: technician,
                      booking: booking,
                    ),
                  );
                },
                loading: () => Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error loading technician: $error')),
              );
            },
          );
        },
      );
    }
  }
}
