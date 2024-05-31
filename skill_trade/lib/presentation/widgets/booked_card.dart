// import 'package:flutter/material.dart';

// class TechnicianBookingScreen extends StatelessWidget {
//   const TechnicianBookingScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Sample data for the booking card
//     final bookingData = {
//       'problemTitle': 'Leaking Pipe',
//       'problemDescription': 'The kitchen sink pipe is leaking.',
//       'location': 'Addis Ababa',
//       'name': 'John Doe',
//     };

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Card(
//         elevation: 4.0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 bookingData['problemTitle'] ?? "None",
//                 style:
//                     const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 bookingData['problemDescription'] ?? "None",
//                 style: const TextStyle(fontSize: 14),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Location: ${bookingData['location']}',
//                 style: const TextStyle(fontSize: 14),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Name: ${bookingData['name']}',
//                 style: const TextStyle(fontSize: 14),
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       // Handle accept button press
//                       print('Accept button pressed');
//                     },
//                     child: const Text('Accept'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Handle decline button press
//                       print('Decline button pressed');
//                     },
//                     child: const Text('Decline'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Handle delete button press
//                       print('Delete button pressed');
//                     },
//                     child: const Text('Delete'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

// A function to fetch booking data from the backend
// Replace this with your actual API call logic
Future<Map<String, dynamic>> fetchBookingData() async {
  await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
  return {
    'problemTitle': 'Leaking Pipe',
    'problemDescription': 'The kitchen sink pipe is leaking.',
    'location': 'Addis Ababa',
    'name': 'John Doe',
  };
}

class TechnicianBookingScreen extends StatefulWidget {
  const TechnicianBookingScreen({super.key});

  @override
  _TechnicianBookingScreenState createState() =>
      _TechnicianBookingScreenState();
}

class _TechnicianBookingScreenState extends State<TechnicianBookingScreen> {
  late Future<Map<String, dynamic>> _bookingDataFuture;

  @override
  void initState() {
    super.initState();
    // Fetch booking data when the widget is initialized
    _bookingDataFuture = fetchBookingData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _bookingDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the data is being fetched, show a loading indicator
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // If there was an error fetching data, display an error message
          return const Center(child: Text('Error loading data'));
        } else {
          // Data has been successfully fetched
          final bookingData = snapshot.data ?? {};

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bookingData['problemTitle'] ?? 'None',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bookingData['problemDescription'] ?? 'None',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Location: ${bookingData['location']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Name: ${bookingData['name']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Handle accept button press
                            print('Accept button pressed');
                          },
                          child: const Text('Accept'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle decline button press
                            print('Decline button pressed');
                          },
                          child: const Text('Decline'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle delete button press
                            print('Delete button pressed');
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
