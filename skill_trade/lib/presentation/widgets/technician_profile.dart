import 'package:flutter/material.dart';
import 'package:skill_trade/domain/models/technician.dart';
import 'package:skill_trade/presentation/widgets/info_label.dart';

class TechnicianSmallProfile extends StatelessWidget {
  final Technician technician;
  const TechnicianSmallProfile({super.key, required this.technician});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        const SizedBox(
          height: 20,
        ),
        Image.asset(
          "assets/technician.png",
          width: 125,
          height: 125,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          technician.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoLabel(label: "Email", data: technician.email),
               const SizedBox(
                height: 3,
              ),
              InfoLabel(label: "Phone", data: technician.phone),
               const SizedBox(
                height: 3,
              ),
              InfoLabel(label: "Skills", data: technician.skills),
               const SizedBox(
                height: 3,
              ),
              InfoLabel(
                  label: "Experience",
                  data: technician.experience),
               const SizedBox(
                height: 3,
              ),
              InfoLabel(
                  label: "Education Level",
                  data: technician.education_level),
               const SizedBox(
                height: 3,
              ),
              InfoLabel(label: "Available Location", data: technician.available_location),
               const SizedBox(
                height: 3,
              ),
              InfoLabel(label: "Additional Bio", data: technician.additional_bio),
              InfoLabel(label: "Status", data: technician.status),
            ],
          ),
        )
      ],
    );
  }
}