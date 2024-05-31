import 'package:flutter/material.dart';

class InfoLabel extends StatelessWidget {
  final String label;
  final String data;
  const InfoLabel({super.key, required this.label, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text(
        "$label:",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      const SizedBox(
        width: 5,
      ),
      Text(
        data,
        style: const TextStyle(fontSize: 15),
      ),
    ]);
  }
}
