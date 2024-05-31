import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/application/providers/providers.dart';
import 'package:skill_trade/application/states/find_technician_state.dart';
import 'package:skill_trade/domain/models/technician.dart';
import 'package:skill_trade/presentation/widgets/technician_card.dart';

class FindTechnician extends ConsumerWidget {
  const FindTechnician({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final techniciansState = ref.watch(techniciansNotifierProvider);

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        hintText: "Search",
                        contentPadding: EdgeInsets.symmetric(vertical: 14.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Consumer(builder: (context, ref, child) {
              if (techniciansState is TechniciansLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (techniciansState is TechniciansLoaded) {
                final List<Technician> technicians = techniciansState.technicians!
                    .where((tech) => tech.status == "accepted")
                    .toList();
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.55,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return TechnicianCard(
                      technician: technicians[index],
                    );
                  },
                  itemCount: technicians.length,
                );
              } else if (techniciansState is TechniciansError) {
                return Center(child: Text(techniciansState.error));
              } else {
                return Container();
              }
            }),
          ),
        ],
      ),
    );
  }
}
