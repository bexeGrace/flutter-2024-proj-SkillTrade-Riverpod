import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/application/providers/providers.dart';

class EditableField extends StatefulWidget {
  final String label;
  final String data;
  final TextEditingController? controller;

  const EditableField(
      {super.key, 
      required this.label,
      required this.data,
      required this.controller});

  @override
  State<EditableField> createState() => _EditableFieldState();
}

class _EditableFieldState extends State<EditableField> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label.split(',')[0] != "review")
            Text(
              widget.label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 210,
                child: TextField(
                  controller: widget.controller,
                  enabled: isEditing,
                  decoration: const InputDecoration(
                    hintText: 'Editable TextField',
                  ),
                ),
              ),
              Consumer(builder: (context, ref, child) {
                return IconButton(
                  icon: Icon(isEditing ? Icons.check : Icons.edit),
                  onPressed: () {
                    if (widget.label.split(',')[0] == "review" && isEditing) {
                      ref.read(reviewsNotifierProvider.notifier).updateReview(
                         reviewId: int.parse(widget.label.split(",")[1]),
                        updates: {"review": widget.controller!.text},
                        technicianId: int.parse(
                          widget.label.split(",")[2],
                        )
                      );
                    }
                    setState(() {
                      isEditing = !isEditing;
                    });
                  },
                );
              })
            ],
          ),
        ],
      ),
    );
  }
}
