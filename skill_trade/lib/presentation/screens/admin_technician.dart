import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/application/providers/providers.dart';
import 'package:skill_trade/application/states/individual_technician_state.dart';
import 'package:skill_trade/application/states/review_state.dart';
import 'package:skill_trade/presentation/widgets/rating_stars.dart';
import 'package:skill_trade/presentation/widgets/technician_profile.dart';

class AdminTechnician extends ConsumerWidget {
  final int technicianId;
  const AdminTechnician({super.key, required this.technicianId});

  @override
  Widget build(BuildContext context, ref) {
    final technicianState = ref.watch(individualTechnicianNotifierProvider);
    final reviewsState = ref.watch(reviewsNotifierProvider);
    final individualTechniciaNotifier = ref.read(individualTechnicianNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Technician"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          
          Consumer(builder: (context, ref, child){
              if(technicianState is IndividualTechnicianLoaded){
                final data = technicianState.technician;
                    return Column(
                    children: [
                      
                      TechnicianSmallProfile(technician: technicianState.technician,),
                      const SizedBox(height: 30,),
                      data.status == "suspended" || data.status == "accepted" ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: ()async {
                              await individualTechniciaNotifier.updateTechnicianProfile(technicianId: data.id, updates: const {"status": "suspended"});
                              ref.read(techniciansNotifierProvider.notifier).loadTechnicians();
                              ref.read(techniciansNotifierProvider.notifier).loadSuspendedTechnicians();

                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                            ),
                            child: const Text(
                              "Suspend",
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            onPressed: () async{
                                await individualTechniciaNotifier.updateTechnicianProfile(technicianId: data.id, updates: const {"status": "accepted"});
                                ref.read(techniciansNotifierProvider.notifier).loadTechnicians();
                                ref.read(techniciansNotifierProvider.notifier).loadSuspendedTechnicians();
                             
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.green),
                            ),
                            child: const Text(
                              "Unsuspend",
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ):
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async{
                              await individualTechniciaNotifier.updateTechnicianProfile(technicianId: data.id, updates: const {"status": "accepted"});
                               ref.read(techniciansNotifierProvider.notifier).loadTechnicians();
                               ref.read(techniciansNotifierProvider.notifier).loadPendingTechnicians();

                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                            ),
                            child: const Text(
                              "Accept application",
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            onPressed: ()async {
                              await individualTechniciaNotifier.updateTechnicianProfile(technicianId: data.id, updates: const {"status": "declined"});
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                            ),
                            child: const Text(
                              "Decline application",
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      )
                      
                      
                    ],);
                      } else if(technicianState is IndividualTechnicianLoading){
                        return Center(child: CircularProgressIndicator(),);
                      } else{
                        return Center(child: Text("Error loading the technician"),);
                      }
                
          })
         
          ,
          const SizedBox(
            height: 30,
          ),

          const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(
              'Reviews',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Consumer( builder: (context, ref, child){
                if(reviewsState is ReviewsLoaded){
                  final reviews = reviewsState.reviews;
                  if (reviews.isEmpty){
                    return const Text(
                        "No reviews yet!",
                      );
                  } else {
                      return SizedBox(
                    height: reviews.length * 110,
                    child: ListView.builder(
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/profile.jpg",
                                  width: 40,
                                  height: 40,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  reviews[index].customer,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            ListTile(
                              title: RatingStars(
                                  rating: reviews[index].rating),
                              subtitle: Text(reviews[index].comment)
                              )
                          ],
                        );
                      },
                    ),
                  );
                  }

                } else if (reviewsState is ReviewsError){
                  return Center(child: Text("Error loading reviews"),);

                } else{
                  return Center(child: CircularProgressIndicator(),);
                }
              
            },
              
            )
            ),
            const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}



