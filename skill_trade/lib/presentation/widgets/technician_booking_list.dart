import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/presentation/widgets/technician_booking_card.dart';
import 'package:skill_trade/riverpod/booking_provider.dart';
import 'package:skill_trade/riverpod/customer_provider.dart';

class TechnicianBookingList extends ConsumerStatefulWidget {
  const TechnicianBookingList({super.key});

  @override
  ConsumerState<TechnicianBookingList> createState() =>
      _TechnicianBookingListState();
}

class _TechnicianBookingListState extends ConsumerState<TechnicianBookingList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bookingProvider.notifier).fetchBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingProvider);

    return Column(
      children: [
        Container(
          color: Theme.of(context).colorScheme.background,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(5),
          child: const Text(
            "Booked To You...",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: bookingState.isLoading
              ? Center(child: const CircularProgressIndicator())
              : bookingState.errorMessage != null
                  ? Center(child: Text('Error: ${bookingState.errorMessage}'))
                  : ListView.builder(
                      itemCount: bookingState.bookings.length,
                      itemBuilder: (context, index) {
                        final booking = bookingState.bookings[index];
                        final customerAsync =
                            ref.watch(customerByIdProvider(booking.customerId));

                        return customerAsync.when(
                            data: (customer) {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TechnicianBookingCard(
                                  booking: booking,
                                  editAccess: true,
                                  customer: customer,
                                ),
                              );
                            },
                            loading: () => const Center(
                                child: CircularProgressIndicator()),
                            error: ((error, stackTrace) =>
                                Text('Error loading customer: ${error}')));
                      },
                    ),
        ),
      ],
    );
  }
}
