import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/presentation/widgets/technician_tile.dart';
import 'package:skill_trade/riverpod/technician_provider.dart';

class TechniciansList extends ConsumerWidget {
  const TechniciansList({super.key});

  @override
  Widget build(BuildContext context, ref) {
    
    final asyncTechnicians = ref.watch(allTechnicianProvider);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          const Text(
            "Technicians",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          asyncTechnicians.when(
            data: (techs){
              return Expanded(
                child: ListView.builder(
                  
                  itemCount: techs.length,
                  itemBuilder: (context, index){
                    return TechnicianTile(technician: techs[index]);
                  },),
              );
              
            },
            error: (error, stack) => Center(child: Text('Error loading technicians: $error')), 
            loading: () => const Center(child: CircularProgressIndicator())),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
