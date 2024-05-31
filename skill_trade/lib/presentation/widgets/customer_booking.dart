import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/application/notifiers/bookings_notifier.dart';
import 'package:skill_trade/application/providers/providers.dart';
import 'package:skill_trade/application/states/bookings_state.dart';
import 'package:skill_trade/application/states/customer_state.dart';
import 'package:skill_trade/domain/models/booking.dart';
import 'package:skill_trade/domain/models/technician.dart';
import 'package:skill_trade/presentation/widgets/editable_textfield.dart';
import 'package:skill_trade/presentation/widgets/info_label.dart';

class CustomerBooking extends ConsumerStatefulWidget {
  final Booking booking;
  final Technician technician;
// 
  CustomerBooking({
    Key? key,
    required this.booking,
    required this.technician,
  })  : _controllers = {
          "serviceNeeded": TextEditingController(text: booking.serviceNeeded),
          "problemDescription":
              TextEditingController(text: booking.problemDescription),
          "serviceLocation":
              TextEditingController(text: booking.serviceLocation),
        },
        _selectedDate = booking.serviceDate,
        super(key: key);

  late DateTime? _selectedDate;
  final Map<String, TextEditingController> _controllers;

  @override
  ConsumerState<CustomerBooking> createState() => _CustomerBookingState();
}

class _CustomerBookingState extends ConsumerState<CustomerBooking> {
  String? statusMessage;
  Color? statusColor;
  

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget._selectedDate!,
      firstDate: DateTime(2010),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != widget._selectedDate) {
      setState(() {
        widget._selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingsNotifierProvider);
    final bookingNotifier = ref.read(bookingsNotifierProvider.notifier);
    final customerState = ref.watch(customerNotifierProvider);


    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Booked With",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 15),
          bookingState is BookingsLoading
              ? const CircularProgressIndicator()
              : Text(
                  widget.technician.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
          if (statusMessage != null)
            Text(
              statusMessage!,
              style: TextStyle(color: statusColor),
            ),
          const SizedBox(height: 7),
          InfoLabel(label: "Email", data: widget.technician.email),
          const SizedBox(height: 7),
          InfoLabel(label: "Speciality", data: widget.technician.skills),
          const SizedBox(height: 7),
          InfoLabel(label: "Phone", data: widget.technician.phone),
          const SizedBox(height: 20),
          InfoLabel(
              label: "Booked Date",
              data: widget.booking.bookedDate.toString().substring(0, 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Service Date:  ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    widget._selectedDate.toString().substring(0, 10),
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => _selectDate(context),
                child: const Text('Change Date'),
              ),
            ],
          ),
          EditableField(
            label: "Service Needed",
            data: widget.booking.serviceNeeded,
            controller: widget._controllers["serviceNeeded"],
          ),
          EditableField(
            label: "Problem Description",
            data: widget.booking.problemDescription,
            controller: widget._controllers["problemDescription"],
          ),
          EditableField(
            label: "Service Location",
            data: widget.booking.serviceLocation,
            controller: widget._controllers["serviceLocation"],
          ),
          InfoLabel(label: "Status", data: widget.booking.status),
          const SizedBox(height: 15),
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  await editBooking(bookingNotifier, customerState, widget.booking.id);
                  setState(() {
                    if (bookingState is BookingsLoaded) {
                      statusMessage = 'Booking updated successfully!';
                      statusColor = Colors.green;
                    } else if (bookingState is BookingsError != null) {
                      statusMessage = 'Error: ';
                      statusColor = Colors.red;
                    }
                  });
                },
                child: const Text(
                  "Edit",
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () async {
                  await deleteBooking(bookingNotifier, customerState,  widget.booking.id);
                  setState(() {
                    if (bookingState is BookingsLoaded) {
                      statusMessage = 'Booking deleted successfully!';
                      statusColor = Colors.green;
                    } else if (bookingState is BookingsError != null) {
                      statusMessage = 'Error';
                      statusColor = Colors.red;
                    }
                  });
                },
                child: Text(
                  "Delete Booking",
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> editBooking(BookingsNotifier provider, customerState, int bookingId) async {
    final updatedData = {
      "serviceNeeded": widget._controllers["serviceNeeded"]?.text,
      "problemDescription": widget._controllers["problemDescription"]?.text,
      "serviceLocation": widget._controllers["serviceLocation"]?.text,
      "serviceDate": widget._selectedDate.toString().substring(0, 10),
    };
    if (customerState is CustomerLoaded){
    provider.updateBooking(bookingId: bookingId, updates: updatedData, whoUpdated: "customer", updaterId: customerState.customer.id);

    }
    
  }

  Future<void> deleteBooking(BookingsNotifier provider, customerState, int bookingId) async {
    if (customerState is CustomerLoaded){
    await provider.deleteBooking(bookingId: bookingId, customerId: customerState.customer.id);
  }}
}
