import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/application/providers/providers.dart';
import 'package:skill_trade/application/states/find_technician_state.dart';
import 'package:skill_trade/domain/models/technician.dart';
import 'package:skill_trade/presentation/widgets/technician_tile.dart';


class AdminPage extends ConsumerWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final pendingTechnicianState = ref.watch(techniciansNotifierProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
          child: Text(
              "Technician Applications",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
          ),
        ),
        Expanded(
          child: Consumer( 
            builder: (context, ref, child) {
              if (pendingTechnicianState is TechniciansLoading){
                return const Center(child: CircularProgressIndicator());
              } else if (pendingTechnicianState is TechniciansLoaded && pendingTechnicianState.pendingTechnicians != null) {
                final List<Technician> technicians = pendingTechnicianState.pendingTechnicians;
                return technicians.isNotEmpty? ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return TechnicianTile(technician: technicians[index]);
                  },
                itemCount: technicians.length,
                ): const Center(child: Text("No pending applications"),);
              } else if (pendingTechnicianState is TechniciansError) {
                return Center(child: Text(pendingTechnicianState.error));
              } else {
                return Container();
              }
            },
          ),
          ),
        
      ],
    );
  }
}