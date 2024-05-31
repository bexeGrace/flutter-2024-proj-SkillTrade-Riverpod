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
    final asyncValueTechnician =
        ref.watch(technicianByIdProvider(technician.id));
    return asyncValueTechnician.when(
        data: (tech) {
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoLabel(
                        label: "Email",
                        data: tech.email), 
                    const SizedBox(
                      height: 3,
                    ),
                    InfoLabel(
                        label: "Phone", data: tech.phone), 
                    const SizedBox(
                      height: 3,
                    ),
                    InfoLabel(
                        label: "Skills",
                        data:
                            tech.specialty), 
                    const SizedBox(
                      height: 3,
                    ),
                    InfoLabel(
                        label: "Experience",
                        data: tech
                            .experience), 
                    const SizedBox(
                      height: 3,
                    ),
                    InfoLabel(
                        label: "Education Level",
                        data: tech
                            .educationLevel), 
                    const SizedBox(
                      height: 3,
                    ),
                    InfoLabel(
                        label: "Available Location",
                        data: tech.availableLocation), 
                    const SizedBox(
                      height: 3,
                    ),
                    InfoLabel(
                        label: "Additional Bio",
                        data: tech.additionalBio),
                  ],
                ),
              )
            ],
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) => Center(
              child: Text('Error loading technician: $error'),
            ));
  }
}
