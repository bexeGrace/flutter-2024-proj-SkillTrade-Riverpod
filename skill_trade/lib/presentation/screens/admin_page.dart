import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/models/technician.dart';
import 'package:skill_trade/presentation/widgets/technician_tile.dart';
import 'package:skill_trade/riverpod/technician_provider.dart';

void main() {
  runApp(const MaterialApp(
    home: AdminPage(),
  ));
}

class AdminPage extends ConsumerWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final pendingTechs = ref.watch(pendingTechniciansProvider);
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
          child: pendingTechs.when( 
            data: (techs){
              return techs.isNotEmpty? 
              ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return TechnicianTile(technician: techs[index]);
                  },
                itemCount: techs.length,
                ): const Center(child: Text("No pending applications"),);

            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: ((error, stackTrace) => Text("Error loading technician applications.${error}"))
          )
          
          
        ),
      ],
    );
  }
}
