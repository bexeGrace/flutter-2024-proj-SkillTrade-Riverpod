class Review {
  final int rating;
  final String comment;
  final String customer;
  final int customerId;
  final int id;
  Review({required this.rating, required this.comment, required this.customer, required this.customerId, required this.id});

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    rating: json['rate'],
    comment: json['review'],
    customer: json['user'], 
    customerId: json['userId'],
    id: json["id"]
  );
}