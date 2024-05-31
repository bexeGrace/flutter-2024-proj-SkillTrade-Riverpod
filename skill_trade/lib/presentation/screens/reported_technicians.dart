import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/presentation/widgets/customer_tile.dart';
import 'package:skill_trade/presentation/widgets/technician_tile.dart';
import 'package:skill_trade/riverpod/technician_provider.dart';

void main() {
  runApp(const MaterialApp(
    home: ReportedTechnicians(),
  ));
}

class ReportedTechnicians extends ConsumerWidget {
  const ReportedTechnicians({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final reported = ref.watch(suspendedTechniciansProvider);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView(
        children: [
          const Text(
            "Reported Users",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
          child: reported.when( 
            data: (reportedTech){
              return reportedTech.isNotEmpty ? ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return TechnicianTile(technician: reportedTech[index]);
                  },
                itemCount: reportedTech.length,
                ) : const Center(child: Text("No reported users"),);

            },
            error:(error, StackTrace) => Center(child: Text("Error loading reported technicians $error")),
            loading: () => const Center(child: CircularProgressIndicator()),

          )
          
          
        ),
        ],
      ),
    );
  }
}
