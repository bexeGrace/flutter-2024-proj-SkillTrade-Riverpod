import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/models/customer.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_trade/models/review.dart';
import 'package:skill_trade/models/technician.dart';
import 'package:skill_trade/presentation/widgets/editable_textfield.dart';
import 'package:skill_trade/presentation/widgets/technician_profile.dart';
import 'package:skill_trade/presentation/widgets/rating_stars.dart';
import 'package:skill_trade/riverpod/booking_provider.dart';
import 'package:skill_trade/riverpod/customer_provider.dart';
import 'package:skill_trade/riverpod/review_provider.dart';
import 'package:skill_trade/riverpod/secure_storage_provider.dart';
// import 'package:skill_trade/state_managment/bookings/bookings_bloc.dart';
// import 'package:skill_trade/state_managment/bookings/bookings_event.dart';

class MyBookings extends ConsumerStatefulWidget {
  final Technician technician;

  const MyBookings({super.key, required this.technician});

  @override
  ConsumerState<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends ConsumerState<MyBookings> {
  late DateTime? _selectedDate = null;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Initial date selected
      firstDate: DateTime(2010), // First selectable date
      lastDate: DateTime(2050), // Last selectable date
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  double _rating = 0;
  String _review = '';
  List<Review> _reviews = []; // List to store previous reviews
  TextEditingController _reviewController = TextEditingController();
  TextEditingController serviceNeededController = TextEditingController();
  TextEditingController serviceLocationController = TextEditingController();
  TextEditingController problemDescriptionController = TextEditingController();
  var _customer;
  

  void _submitReview() async {

    // _reviews.add(newReview);
    ref.read(reviewProvider.notifier).createReview(widget.technician.id, _review, _rating );
    ref.read(reviewProvider.notifier).fetchReviews(widget.technician.id);
        
    setState(() {
      _rating = 0;
      _review = '';
      _reviewController.clear();
    });
    
  }

  void initState(){
    
    // ref.read(customerNotifierProvider.notifier).fetchProfile();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(customerNotifierProvider.notifier).fetchProfile();
      ref.read(reviewProvider.notifier).fetchReviews(widget.technician.id);
    });
    
    // _customer = customerState.customer;

  }
  void submitBooking() {
    // BlocProvider.of<BookingsBloc>(context).add();
    final booking = {
      "problemDescription": problemDescriptionController.text,
      "technicianId": widget.technician.id, 
      "serviceNeeded": serviceNeededController.text, 
      "serviceDate": _selectedDate.toString().substring(0, 10),
      "serviceLocation": serviceLocationController.text
    };
    ref.watch(bookingProvider.notifier).createBooking(booking);

    serviceNeededController.clear();
    serviceLocationController.clear();
    problemDescriptionController.clear();
    setState(() {
        _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingProvider);
    final reviewState = ref.watch(reviewProvider);
    final customerState = ref.watch(customerNotifierProvider);

    return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Technician",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            centerTitle: true,
          ),
          body: ListView(
            children: [
              TechnicianSmallProfile(technician: widget.technician,),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const Divider(
                  thickness: 1,
                  color: Colors.black,
                ),
              ),
              const Text(
                "Book Service",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              if(bookingState.isLoading)
                Center(child: CircularProgressIndicator(),)
              else Container(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Service \nDate:",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'No date selected'
                                  : '${_selectedDate.toString().substring(0, 10)}',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            // SizedBox(height: 20),
                            TextButton(
                              onPressed: () => _selectDate(context),
                              child: const Text('Select Date'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Service \nNeeded:",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        SizedBox(
                          width: 220,
                          height: 40,
                          child: TextField(
                            controller: serviceNeededController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Service \nLocation:",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        SizedBox(
                          width: 220,
                          height: 40,
                          child: TextField(
                            controller: serviceLocationController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Problem \nDescription:",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        SizedBox(
                          width: 220,
                          height: 60,
                          child: TextField(
                            controller: problemDescriptionController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        )
                      ],
                    ),
                    
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      width: 250,
                      child:  TextButton(
                          onPressed:(){

                            submitBooking();
                            ref.watch(bookingProvider);
                            if (bookingState.isSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Booking created successfully!')),
                              );
                              // Optionally, navigate to another page
                            } else if (bookingState.errorMessage != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: ${bookingState.errorMessage}')),
                              );
                            };
                          },
                          child: Text(
                            "Book",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  thickness: 1,
                  color: Colors.black,
                ),
              ),
        
              // Review //
        
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Previous reviews
                    Text(
                      'Reviews',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    if(reviewState.isLoading)
                      Center(child: CircularProgressIndicator())
                    else if(reviewState.isSuccess) ...[
                      reviewState.reviews.length == 0 ?
                          Text(
                            "No reviews yet!",
                          )
                      : Container(
                            height: reviewState.reviews.length * 110,
                            child: ListView.builder(
                              itemCount: reviewState.reviews.length,
                              itemBuilder: (context, index) {
                                final cur_review = reviewState.reviews[index];
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/profile.jpg",
                                          width: 40,
                                          height: 40,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          cur_review.customer,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    ListTile(
                                      title: RatingStars(
                                          rating: cur_review.rating),
                                      subtitle: Consumer( 
                                        builder: (context, watch, child){
                                          final customerState = ref.watch(customerNotifierProvider);

                                            if (!customerState.isLoading) {

                                              if (customerState.customer!.id == cur_review.customerId) {
                                                TextEditingController curController = TextEditingController();
                                                curController.text = cur_review.review;

                                                return Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    EditableField(data: cur_review.review, controller: curController, label: 'review,${cur_review.id}',),
                                                    IconButton(
                                                      onPressed: () {
                                                        ref.read(reviewProvider.notifier).deleteReview(cur_review.id, widget.technician.id);
                                                      }, 
                                                      icon: Icon(Icons.delete, color: Colors.red, ))
                                                  ],
                                                );
                                              } else {
                                                return Text(cur_review.review);
                                              }
                                            } else {
                                              return Text(cur_review.review);
                                            }
                                        },
                                      )
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
            

                    ],
                    
                     
                    
                    // _reviews.length > 0
                        // ? Container(
                        //     height: _reviews.length * 110,
                        //     child: ListView.builder(
                        //       itemCount: _reviews.length,
                        //       itemBuilder: (context, index) {
                        //         return Column(
                        //           mainAxisSize: MainAxisSize.min,
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             Row(
                        //               crossAxisAlignment: CrossAxisAlignment.center,
                        //               children: [
                        //                 Image.asset(
                        //                   "assets/profile.jpg",
                        //                   width: 40,
                        //                   height: 40,
                        //                 ),
                        //                 SizedBox(
                        //                   width: 5,
                        //                 ),
                        //                 Text(
                        //                   _reviews[index].customer.fullName,
                        //                   style: TextStyle(
                        //                       fontSize: 15,
                        //                       fontWeight: FontWeight.w500),
                        //                 ),
                        //               ],
                        //             ),
                        //             ListTile(
                        //               title: RatingStars(
                        //                   rating: _reviews[index].rating),
                        //               subtitle: Text(_reviews[index].review),
                        //             ),
                        //           ],
                        //         );
                        //       },
                        //     ),
                        //   )
                        // : Text(
                        //     "No reviews yet!",
                        //   ),
        
                    SizedBox(height: 20),
                    Text(
                      'Leave a Review',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    // Star rating widget
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.star,
                              color: _rating >= 1 ? Colors.orange : Colors.grey),
                          onPressed: () => setState(() => _rating = 1),
                        ),
                        IconButton(
                          icon: Icon(Icons.star,
                              color: _rating >= 2 ? Colors.orange : Colors.grey),
                          onPressed: () => setState(() => _rating = 2),
                        ),
                        IconButton(
                          icon: Icon(Icons.star,
                              color: _rating >= 3 ? Colors.orange : Colors.grey),
                          onPressed: () => setState(() => _rating = 3),
                        ),
                        IconButton(
                          icon: Icon(Icons.star,
                              color: _rating >= 4 ? Colors.orange : Colors.grey),
                          onPressed: () => setState(() => _rating = 4),
                        ),
                        IconButton(
                          icon: Icon(Icons.star,
                              color: _rating >= 5 ? Colors.orange : Colors.grey),
                          onPressed: () => setState(() => _rating = 5),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Text input for review
                    TextField(
                      controller: _reviewController,
                      onChanged: (value) => _review = value,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Write your review here...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Submit button
                    ElevatedButton(
                      onPressed: _submitReview,
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}