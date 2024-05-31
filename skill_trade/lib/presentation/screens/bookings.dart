import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/application/providers/providers.dart';
import 'package:skill_trade/application/states/customer_state.dart';
import 'package:skill_trade/application/states/review_state.dart';
import 'package:skill_trade/domain/models/review.dart';
import 'package:skill_trade/domain/models/technician.dart';
import 'package:skill_trade/presentation/widgets/editable_textfield.dart';
import 'package:skill_trade/presentation/widgets/technician_profile.dart';
import 'package:skill_trade/presentation/widgets/rating_stars.dart';
import 'package:skill_trade/infrastructure/storage/storage.dart';

class MyBookings extends ConsumerStatefulWidget {
  final Technician technician;

  const MyBookings({super.key, required this.technician});

  @override
  ConsumerState<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends ConsumerState<MyBookings> {
  DateTime? _selectedDate;
  double _rating = 0;
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController serviceNeededController = TextEditingController();
  final TextEditingController serviceLocationController = TextEditingController();
  final TextEditingController problemDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reviewsNotifierProvider.notifier).loadTechnicianReviews(widget.technician.id);
    });
  }

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

  void _submitReview() async {
    final customerId = int.tryParse((await SecureStorage.instance.read("id"))!)!;
    ref.read(reviewsNotifierProvider.notifier).postReview(
      technicianId: widget.technician.id,
      review: _reviewController.text,
      rate: _rating,
      customerId: customerId,
    );
    ref.read(reviewsNotifierProvider.notifier).loadTechnicianReviews(widget.technician.id);

    _reviewController.clear();
    setState(() {
      _rating = 0;
    });
  }

  void submitBooking() async {
    final customerId = int.tryParse((await SecureStorage.instance.read("id"))!)!;
    ref.read(bookingsNotifierProvider.notifier).postBooking(
      problemDescription: problemDescriptionController.text,
      customerId: customerId,
      technicianId: widget.technician.id,
      serviceNeeded: serviceNeededController.text,
      serviceDate: _selectedDate!,
      serviceLocation: serviceLocationController.text,
    );
    serviceNeededController.clear();
    serviceLocationController.clear();
    problemDescriptionController.clear();
    setState(() {
      _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final customerState = ref.watch(customerNotifierProvider);
    final reviewsState = ref.watch(reviewsNotifierProvider);

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
          TechnicianSmallProfile(technician: widget.technician),
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
          Container(
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
                const SizedBox(height: 10),
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
                    const SizedBox(width: 7),
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
                const SizedBox(height: 15),
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
                    const SizedBox(width: 7),
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
                const SizedBox(height: 15),
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
                    const SizedBox(width: 7),
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
                  child: TextButton(
                    onPressed: submitBooking,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).colorScheme.primary),
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
          // This is the review section
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
                reviewsState is ReviewsLoaded
                    ? reviewsState.reviews.isNotEmpty
                        ? Container(
                            height: reviewsState.reviews.length * 150.0,
                            child: ListView.builder(
                              itemCount: reviewsState.reviews.length,
                              itemBuilder: (context, index) {
                                Review curReview =
                                    reviewsState.reviews[index];
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/profile.jpg",
                                          width: 40,
                                          height: 40,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          reviewsState.reviews[index].customer,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    ListTile(
                                      title: RatingStars(
                                          rating: reviewsState
                                              .reviews[index].rating),
                                      subtitle: customerState is CustomerLoaded
                                          ? customerState.customer.id ==
                                                  curReview.customerId
                                              ? Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                  children: [
                                                    EditableField(
                                                      data: curReview.comment,
                                                      controller:
                                                          TextEditingController()
                                                            ..text = curReview
                                                                .comment,
                                                      label:
                                                          'review,${curReview.id},${widget.technician.id}',
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        ref
                                                            .read(
                                                                reviewsNotifierProvider
                                                                    .notifier)
                                                            .deleteReview(
                                                              reviewId:
                                                                  curReview.id,
                                                              technicianId: widget
                                                                  .technician
                                                                  .id,
                                                            );
                                                      },
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : Text(curReview.comment)
                                          : customerState is CustomerError
                                              ? Text(
                                                  "Error loading customer")
                                              : const SizedBox.shrink(),
                                    )
                                  ],
                                );
                              },
                            ),
                          )
                        : const Text("No reviews yet!")
                    : reviewsState is ReviewsError
                        ? const Text("Error loading reviews")
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
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
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.primary),
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
