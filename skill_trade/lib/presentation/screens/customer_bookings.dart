import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/application/providers/providers.dart';
import 'package:skill_trade/application/states/bookings_state.dart';
import 'package:skill_trade/domain/models/booking.dart';
import 'package:skill_trade/presentation/widgets/customer_booking.dart';


class CustomerBookings extends ConsumerWidget {
  CustomerBookings({super.key});

  @override
  Widget build(BuildContext context, ref) {
    
    final bookingsState = ref.watch(bookingsNotifierProvider);
    return Consumer(builder: (context, ref, child){
      if (bookingsState is BookingsLoading){
            return const Center(child: CircularProgressIndicator());
          } else if (bookingsState is BookingsLoaded) {
            final List<Booking> bookings = bookingsState.bookings.reversed.toList();
          
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) { 
                final technicianAsync = ref.watch(individualTechnicianFutureProvider(bookings[index].technicianId));
               
                return technicianAsync.when(data: (technician){
                  return CustomerBooking(
                        technician: technician,
                        booking: bookings[index],
                      );
                },
                 error: (error, StackTrace) => Text("errror ${error.toString()}"),
                 loading: () => Center(child: CircularProgressIndicator(),));
                
                
              },
              itemCount: bookings.length,
            );
          } else if (bookingsState is BookingsError) {
            return Center(child: Text(bookingsState.error));
          } else {
            return Container();
          }
    });
  }
}

