import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/models/technician.dart';
import 'package:skill_trade/presentation/widgets/info_label.dart';
import 'package:skill_trade/riverpod/technician_provider.dart';

class TechnicianSmallProfile extends ConsumerWidget {
  final Technician technician;
  const TechnicianSmallProfile({super.key, required this.technician});

  @override
  Widget build(BuildContext context, ref) {
    final asyncValueTechnician = ref.watch(technicianByIdProvider(technician.id));
    // print("tech small profile says $technician");
    return asyncValueTechnician.when(
      data: (tech){

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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoLabel(label: "Email", data: tech.email),//"mysteryabe456@gmail.com"),
               SizedBox(
                height: 3,
              ),
              InfoLabel(label: "Phone", data: tech.phone),//"0936120470"),
               SizedBox(
                height: 3,
              ),
              InfoLabel(label: "Skills", data: tech.speciality),//"Electrican, Dish technician"),
               SizedBox(
                height: 3,
              ),
              InfoLabel(
                  label: "Experience",
                  data: tech.experience),//"15 years in ELPA, 3 amet did mastat"),
               SizedBox(
                height: 3,
              ),
              InfoLabel(
                  label: "Education Level",
                  data: tech.educationLevel),//"Bsc. in Electrical Engineering"),
               SizedBox(
                height: 3,
              ),
              InfoLabel(label: "Available Location", data: tech.availableLocation),//"Harar"),
               SizedBox(
                height: 3,
              ),
              InfoLabel(label: "Additional Bio", data: tech.additionalBio),//"Tiris yeneqelkubet"),
            ],
          ),
        )
      ],
    );

      },
      loading: () => CircularProgressIndicator(),
      error: (error, stackTrace) => Center(child: Text('Error loading technician: $error'),
    ));
    
  }
}