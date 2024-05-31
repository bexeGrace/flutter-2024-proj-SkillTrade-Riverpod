import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/models/technician.dart';
import 'package:skill_trade/presentation/widgets/editable_textfield.dart';
import 'package:skill_trade/presentation/widgets/technician_profile.dart';
import 'package:skill_trade/presentation/widgets/rating_stars.dart';
import 'package:skill_trade/riverpod/booking_provider.dart';
import 'package:skill_trade/riverpod/customer_provider.dart';
import 'package:skill_trade/riverpod/review_provider.dart';

class MyBookings extends ConsumerStatefulWidget {
  final Technician technician;

  const MyBookings({super.key, required this.technician});

  @override
  ConsumerState<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends ConsumerState<MyBookings> {
  late DateTime? _selectedDate;

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
  final TextEditingController _reviewController = TextEditingController();
  TextEditingController serviceNeededController = TextEditingController();
  TextEditingController serviceLocationController = TextEditingController();
  TextEditingController problemDescriptionController = TextEditingController();  

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

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(customerNotifierProvider.notifier).fetchProfile();
      ref.read(reviewProvider.notifier).fetchReviews(widget.technician.id);
    });
  }

  void submitBooking() {
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
    ref.watch(customerNotifierProvider);

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
                const Center(child: CircularProgressIndicator(),)
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
                                  : _selectedDate.toString().substring(0, 10),
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
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
                        const Text(
                          "Service \nNeeded:",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        SizedBox(
                          width: 220,
                          height: 40,
                          child: TextField(
                            controller: serviceNeededController,
                            decoration: const InputDecoration(
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
                        const Text(
                          "Service \nLocation:",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        SizedBox(
                          width: 220,
                          height: 40,
                          child: TextField(
                            controller: serviceLocationController,
                            decoration: const InputDecoration(
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
                        const Text(
                          "Problem \nDescription:",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        SizedBox(
                          width: 220,
                          height: 60,
                          child: TextField(
                            controller: problemDescriptionController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        )
                      ],
                    ),
                    
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      width: 250,
                      child:  TextButton(
                          onPressed:(){

                            submitBooking();
                            ref.watch(bookingProvider);
                            if (bookingState.isSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Booking created successfully!')),
                              );
                              // Optionally, navigate to another page
                            } else if (bookingState.errorMessage != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: ${bookingState.errorMessage}')),
                              );
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
                          ),
                          child: const Text(
                            "Book",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const Divider(
                  thickness: 1,
                  color: Colors.black,
                ),
              ),
        
              // Review //
        
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Previous reviews
                    const Text(
                      'Reviews',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    if(reviewState.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if(reviewState.isSuccess) ...[
                      reviewState.reviews.isEmpty ?
                          const Text(
                            "No reviews yet!",
                          )
                      : SizedBox(
                            height: reviewState.reviews.length * 110,
                            child: ListView.builder(
                              itemCount: reviewState.reviews.length,
                              itemBuilder: (context, index) {
                                final curReview = reviewState.reviews[index];
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
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          curReview.customer,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    ListTile(
                                      title: RatingStars(
                                          rating: curReview.rating),
                                      subtitle: Consumer( 
                                        builder: (context, watch, child){
                                          final customerState = ref.watch(customerNotifierProvider);

                                            if (!customerState.isLoading) {

                                              if (customerState.customer!.id == curReview.customerId) {
                                                TextEditingController curController = TextEditingController();
                                                curController.text = curReview.review;

                                                return Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    EditableField(data: curReview.review, controller: curController, label: 'review,${curReview.id}',),
                                                    IconButton(
                                                      onPressed: () {
                                                        ref.read(reviewProvider.notifier).deleteReview(curReview.id, widget.technician.id);
                                                      }, 
                                                      icon: const Icon(Icons.delete, color: Colors.red, ))
                                                  ],
                                                );
                                              } else {
                                                return Text(curReview.review);
                                              }
                                            } else {
                                              return Text(curReview.review);
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
                    const SizedBox(height: 20),
                    const Text(
                      'Leave a Review',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 20),
                    // Text input for review
                    TextField(
                      controller: _reviewController,
                      onChanged: (value) => _review = value,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: 'Write your review here...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Submit button
                    ElevatedButton(
                      onPressed: _submitReview,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
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