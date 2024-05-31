import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/application/providers/providers.dart';
import 'package:skill_trade/domain/models/booking.dart';
import 'package:skill_trade/domain/models/customer.dart';
import 'package:skill_trade/presentation/widgets/info_label.dart';
class TechnicianBookingCard extends ConsumerWidget {
  final Booking booking;
  final bool editAccess;
  final Customer customer;
  final int technicianId;
  const TechnicianBookingCard({super.key, required this.technicianId, required this.booking, required this.editAccess, required this.customer});


  @override
  Widget build(BuildContext context, ref) {
    final bookingNotifier = ref.watch(bookingsNotifierProvider.notifier);
    return Card(
        elevation: 4.0,
        color: Theme.of(context).colorScheme.secondary,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking.serviceNeeded,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                booking.problemDescription,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              InfoLabel(label: 'Location', data: booking.serviceLocation,),
              const SizedBox(height: 8),
              InfoLabel(label: 'Booked Date', data: booking.bookedDate.toString().substring(0, 10),),
              const SizedBox(height: 8),
              InfoLabel(label: 'Service Date', data: booking.serviceDate.toString().substring(0, 10),),
              const SizedBox(height: 8),
              InfoLabel(label: 'Status', data: booking.status,),
              const SizedBox(height: 5),
              const Divider(thickness: 2,),
              const SizedBox(height: 5),
              InfoLabel(label: 'Name', data: customer.fullName,),
              const SizedBox(height: 8),
              InfoLabel(label: 'Phone', data: customer.phone,),
              const SizedBox(height: 8),
              InfoLabel(label: 'Email', data: customer.email,),
              const SizedBox(height: 16),
              if (editAccess) Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      bookingNotifier.updateBooking(updates: const {"status": "accepted"}, bookingId: booking.id, whoUpdated: "technician", updaterId: technicianId);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    child: const Text('Accept', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      bookingNotifier.updateBooking(updates: const {"status": "declined"}, bookingId: booking.id, whoUpdated: "technician", updaterId: technicianId);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    child: const Text('Decline', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      bookingNotifier.updateBooking(updates: const {"status": "serviced"}, bookingId: booking.id, whoUpdated: "technician", updaterId: technicianId);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    child: const Text('Serviced', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  }
}