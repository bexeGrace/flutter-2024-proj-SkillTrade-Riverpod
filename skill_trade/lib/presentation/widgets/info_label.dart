import 'package:flutter/material.dart';

class InfoLabel extends StatelessWidget {
  final String label;
  final String data;
  const InfoLabel({super.key, required this.label, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text(
        this.label + ":",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      SizedBox(
        width: 5,
      ),
      Text(
        this.data,
        style: TextStyle(fontSize: 15),
      ),
    ]);
  }
}
