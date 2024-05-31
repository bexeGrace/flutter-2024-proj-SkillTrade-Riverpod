import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/application/providers/providers.dart';
import 'package:skill_trade/application/states/bookings_state.dart';
import 'package:skill_trade/domain/models/booking.dart';
import 'package:skill_trade/presentation/widgets/technician_booking_card.dart';

class TechnicianBookingList extends ConsumerWidget {
  
  TechnicianBookingList({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final bookingState = ref.watch(bookingsNotifierProvider);
    return Consumer(builder: ((context, ref, child) {
      if (bookingState is BookingsLoading){
            return const Center(child: CircularProgressIndicator());
          } else if (bookingState is BookingsLoaded) {
            final List<Booking> bookings = bookingState.bookings.reversed.toList();
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
                    child: ListView.builder(             
                      scrollDirection: Axis.vertical,
                      itemCount: bookingState.bookings.length,
                      
                      itemBuilder: (context, index) { 
                          final booking = bookingState.bookings[index];

                          final customerState = ref.watch(customerFutureProvider(booking.customerId));


                        return customerState.when(data: (data) {
                          return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TechnicianBookingCard(booking: bookings[index], editAccess: true, customer: data, technicianId: bookings[index].technicianId,),
                              );
                          
                        },loading:() =>  const Center(child: CircularProgressIndicator()) ,
                        error: (error, stackTrace) => Center(child: Text(error.toString()),),);
                        
                        
                      },
                    ),
                  ),
                ],
              );
          } else if (bookingState is BookingsError) {
            return Center(child: Text(bookingState.error));
          } else {
            return Container();
          }
      
    }));
  }
}