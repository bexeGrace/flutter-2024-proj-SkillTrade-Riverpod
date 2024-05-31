import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final int rating;
  RatingStars({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.star, color: rating >= 1 ? Colors.orange : Colors.grey),
          Icon(Icons.star, color: rating >= 2 ? Colors.orange : Colors.grey),
          Icon(Icons.star, color: rating >= 3 ? Colors.orange : Colors.grey),
          Icon(Icons.star, color: rating >= 4 ? Colors.orange : Colors.grey),
          Icon(Icons.star, color: rating >= 5 ? Colors.orange : Colors.grey),
        ],
      );
  }
}