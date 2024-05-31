import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/models/booking.dart';
import 'package:skill_trade/models/technician.dart';
import 'package:skill_trade/presentation/widgets/editable_textfield.dart';
import 'package:skill_trade/presentation/widgets/info_label.dart';
import 'package:skill_trade/riverpod/booking_provider.dart';

class CustomerBooking extends ConsumerStatefulWidget {
  final Booking booking;
  final Technician technician;

  CustomerBooking({
    Key? key,
    required this.booking,
    required this.technician,
  })  : _controllers = {
          "serviceNeeded": TextEditingController(text: booking.serviceNeeded),
          "problemDescription": TextEditingController(text: booking.problemDescription),
          "serviceLocation": TextEditingController(text: booking.serviceLocation),
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
    final bookingState = ref.watch(bookingProvider);
    final bookingNotifier = ref.read(bookingProvider.notifier);

    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Booked With",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 15),
          bookingState.isLoading
              ? CircularProgressIndicator()
              : Text(
                  widget.technician.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
          if (statusMessage != null)
            Text(
              statusMessage!,
              style: TextStyle(color: statusColor),
            ),
          SizedBox(height: 7),
          InfoLabel(label: "Email", data: widget.technician.email),
          SizedBox(height: 7),
          InfoLabel(label: "Speciality", data: widget.technician.speciality),
          SizedBox(height: 7),
          InfoLabel(label: "Phone", data: widget.technician.phone),
          SizedBox(height: 20),
          InfoLabel(label: "Booked Date", data: widget.booking.bookedDate.toString().substring(0, 10)),
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
          SizedBox(height: 15),
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  await editBooking(bookingNotifier, widget.booking.id);
                  setState(() {
                    if (bookingState.isSuccess) {
                      statusMessage = 'Booking updated successfully!';
                      statusColor = Colors.green;
                    } else if (bookingState.errorMessage != null) {
                      statusMessage = 'Error: ${bookingState.errorMessage}';
                      statusColor = Colors.red;
                    }
                  });
                },
                child: Text(
                  "Edit",
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () async {
                  await deleteBooking(bookingNotifier, widget.booking.id);
                  setState(() {
                    if (bookingState.isSuccess) {
                      statusMessage = 'Booking deleted successfully!';
                      statusColor = Colors.green;
                    } else if (bookingState.errorMessage != null) {
                      statusMessage = 'Error: ${bookingState.errorMessage}';
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

  Future<void> editBooking(BookingsNotifier provider, int bookingId) async {
    final updatedData = {
      "serviceNeeded": widget._controllers["serviceNeeded"]?.text,
      "problemDescription": widget._controllers["problemDescription"]?.text,
      "serviceLocation": widget._controllers["serviceLocation"]?.text,
      "serviceDate": widget._selectedDate.toString().substring(0, 10),
    };
    await provider.updateBooking(updatedData, bookingId);
  }

  Future<void> deleteBooking(BookingsNotifier provider, int bookingId) async {
    await provider.deleteBooking(bookingId);
  }
}
