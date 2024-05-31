import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/application/providers/providers.dart';
import 'package:skill_trade/application/states/find_technician_state.dart';
import 'package:skill_trade/domain/models/technician.dart';
import 'package:skill_trade/presentation/widgets/technician_tile.dart';

class TechniciansList extends ConsumerWidget {
  const TechniciansList({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final techniciansState = ref.watch(techniciansNotifierProvider);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Technicians",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Consumer( 
              builder: (context, ref, child) {
                if (techniciansState is TechniciansLoading){
                  return const Center(child: CircularProgressIndicator());
                } else if (techniciansState is TechniciansLoaded) {
                  final List<Technician> technicians = techniciansState.technicians!;
                  print("technicians $technicians");
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      
                      return TechnicianTile(technician: technicians[index]);
                    },
                  itemCount: technicians.length,
                  );
                } else if (techniciansState is TechniciansError) {
                  return Center(child: Text(techniciansState.error));
                } else {
                  return Container(child: Text("No technicians"),);
                }
              },
            )
            ),
          
        ],
      ),
    );
  }
}