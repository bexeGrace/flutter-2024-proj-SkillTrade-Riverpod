// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:skill_trade/presentation/widgets/rating_stars.dart';
// import 'package:skill_trade/presentation/widgets/technician_profile.dart';
// import 'package:skill_trade/riverpod/review_provider.dart';
// import 'package:skill_trade/riverpod/technician_provider.dart';
// class AdminTechnician extends ConsumerWidget {
//   final int technicianId;

//   const AdminTechnician({super.key, required this.technicianId});

//   @override
//   Widget build(BuildContext context, ref) {
//     var asyncTechnician =  ref.watch(technicianByIdProvider(technicianId));
//     final asyncReview = ref.watch(fetchReviewProvider(technicianId));
//     final technicianProfileUpdate = ref.watch(technicianProfileUpdateProvider.notifier);
    
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Technician"),
//         centerTitle: true,
//       ),
//       body: ListView(
//         children: [
//           asyncTechnician.when( 
//             data: (technician){
//                 return           Column(
//               children: [
//                 TechnicianSmallProfile(technician: technician,),
//                 SizedBox(height: 30,),
//                 technician.status == "suspended" || technician.status == "accepted" ?
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         technicianProfileUpdate.updateTechnicianById({"status": "suspended"}, technician.id);
//                       },
//                       style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
//                       ),
//                       child: const Text(
//                         "Suspend",
//                         style: TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 20,
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         technicianProfileUpdate.updateTechnicianById({"status": "accepted"}, technician.id);
                        
//                       },
//                       style: ButtonStyle(
//                         backgroundColor:
//                             MaterialStateProperty.all<Color>(Colors.green),
//                       ),
//                       child: const Text(
//                         "Unsuspend",
//                         style: TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                      ElevatedButton(
//                       onPressed: () {
//                         technicianProfileUpdate.updateTechnicianById({"status": "declined"}, technician.id);
                        
//                       },
//                       style: ButtonStyle(
//                         backgroundColor:
//                             MaterialStateProperty.all<Color>(Colors.red),
//                       ),
//                       child: const Text(
//                         "Decline application",
//                         style: TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                   ],
//                 ):
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         technicianProfileUpdate.updateTechnicianById({"status": "accepted"}, technician.id);
                        
//                       },
//                       style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
//                       ),
//                       child: const Text(
//                         "Accept application",
//                         style: TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 20,
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         technicianProfileUpdate.updateTechnicianById({"status": "declined"}, technician.id);
                        
//                       },
//                       style: ButtonStyle(
//                         backgroundColor:
//                             MaterialStateProperty.all<Color>(Colors.red),
//                       ),
//                       child: const Text(
//                         "Decline application",
//                         style: TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                   ],
//                 ), 
//               ],
//             );
//             },
//             loading: () => Center(child: CircularProgressIndicator(),),
//             error: (error, stackTrace) => Text("Could not load technician $error"),
//           ),
//           const SizedBox(
//             height: 30,
//           ),

//           const Padding(
//             padding: EdgeInsets.only(left: 15.0),
//             child: Text(
//               'Reviews',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.only(left: 25.0),
//             child: 
//             asyncReview.when(
//               data: (review){
//                 return review.isNotEmpty ? Container(
//                     height: review.length * 110,
//                     child: ListView.builder(
//                       itemCount: review.length,
//                       itemBuilder: (context, index) {
//                         return Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Image.asset(
//                                   "assets/profile.jpg",
//                                   width: 40,
//                                   height: 40,
//                                 ),
//                                 const SizedBox(
//                                   width: 5,
//                                 ),
//                                 Text(
//                                   review[index].customer,
//                                   style: const TextStyle(
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                               ],
//                             ),
//                             ListTile(
//                               title: RatingStars(
//                                   rating: review[index].rating),
//                               subtitle: Text(review[index].review)
//                               )
//                           ],
//                         );
//                       },
//                     ),
//                   ) 
//                   :const Text(
//                     "No reviews yet!",
//                   );

//               },
//               error:(error, stackTrace) => Text("Could not load reviews $error"),
//               loading:() => Center(child: CircularProgressIndicator(),),)
            
//           ),

//           const SizedBox(
//             height: 30,
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/presentation/widgets/rating_stars.dart';
import 'package:skill_trade/presentation/widgets/technician_profile.dart';
import 'package:skill_trade/riverpod/review_provider.dart';
import 'package:skill_trade/riverpod/technician_provider.dart';

class AdminTechnician extends ConsumerWidget {
  final int technicianId;

  const AdminTechnician({super.key, required this.technicianId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var asyncTechnician = ref.watch(technicianByIdProvider(technicianId));
    final asyncReview = ref.watch(fetchReviewProvider(technicianId));
    final technicianProfileUpdate = ref.watch(technicianProfileUpdateProvider.notifier);
    
    void _updateTechnicianStatus(Map<String, String> updatedData) async {
      await technicianProfileUpdate.updateTechnicianById(updatedData, technicianId);
      ref.invalidate(technicianByIdProvider(technicianId));
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Technician"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          asyncTechnician.when(
            data: (technician) {
              return Column(
                children: [
                  TechnicianSmallProfile(technician: technician),
                  SizedBox(height: 30),
                  technician.status == "suspended" || technician.status == "accepted" ? 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _updateTechnicianStatus({"status": "suspended"});
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                        ),
                        child: const Text(
                          "Suspend",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          _updateTechnicianStatus({"status": "accepted"});
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                        ),
                        child: const Text(
                          "Unsuspend",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                      
                    ],
                  ) :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _updateTechnicianStatus({"status": "accepted"});
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                        ),
                        child: const Text(
                          "Accept application",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          _updateTechnicianStatus({"status": "declined"});
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                        ),
                        child: const Text(
                          "Decline application",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Text("Could not load technician $error"),
          ),
          const SizedBox(height: 30),
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
            child: asyncReview.when(
              data: (review) {
                return review.isNotEmpty ? 
                Container(
                  height: review.length * 110,
                  child: ListView.builder(
                    itemCount: review.length,
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
                              const SizedBox(width: 5),
                              Text(
                                review[index].customer,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ],
                          ),
                          ListTile(
                            title: RatingStars(rating: review[index].rating),
                            subtitle: Text(review[index].review),
                          ),
                        ],
                      );
                    },
                  ),
                ) : const Text("No reviews yet!");
              },
              error: (error, stackTrace) => Text("Could not load reviews $error"),
              loading: () => Center(child: CircularProgressIndicator()),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
