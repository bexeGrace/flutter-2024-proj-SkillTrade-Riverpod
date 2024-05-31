import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/presentation/widgets/technician_card.dart';
import 'package:skill_trade/riverpod/technician_provider.dart';

class FindTechnician extends ConsumerWidget {
  const FindTechnician({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final technicians = ref.watch(technicianProvider);
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          hintText: "Search",
                          contentPadding: EdgeInsets.symmetric(vertical: 14.0)),
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
            child: technicians.when(
              data: (technicians){ 
                return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.55, 
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return TechnicianCard(technician : technicians[index]);
                    },
                    itemCount: technicians.length,

                  );
              },
            error: (error, s) => Text(error.toString()),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                ))
                
            
          ),
        ],
      ),
    );
  }
}
