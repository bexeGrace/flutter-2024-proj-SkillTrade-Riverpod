import 'package:flutter/foundation.dart';
import 'package:skill_trade/models/customer.dart';

class Review {
  final int rating;
  final String review;
  final String customer;
  final int customerId;
  final int id;
  Review({required this.rating, required this.id, required this.review, required this.customerId, required this.customer});

  factory Review.fromJson(json){
    return Review(
      rating: json['rate'],
      review: json['review'],
      customerId: json['userId'],
      id: json['id'],
      customer: json['user']
      );

  }
  toJson(){
    return {
      'rate': rating,
      'review': review,
      'customerId': customerId,
      'id': id,
      
    };

  }


}