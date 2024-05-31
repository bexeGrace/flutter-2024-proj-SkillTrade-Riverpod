import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/application/providers/providers.dart';
import 'package:skill_trade/application/states/individual_technician_state.dart';
import 'package:skill_trade/application/states/review_state.dart';
import 'package:skill_trade/presentation/widgets/editable_textfield.dart';
import 'package:skill_trade/presentation/widgets/info_label.dart';
import 'package:skill_trade/presentation/widgets/rating_stars.dart';


class TechnicianProfile extends ConsumerStatefulWidget {
  const TechnicianProfile({Key? key}) : super(key: key);

  @override
  ConsumerState<TechnicianProfile> createState() => _TechnicianProfileState();
}

class _TechnicianProfileState extends ConsumerState<TechnicianProfile> {
  final Map<String, TextEditingController> _controllers = {};

  bool changePassword = false;
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final reviewsState = ref.watch(reviewsNotifierProvider);
    final technicianState = ref.watch(individualTechnicianNotifierProvider);
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            const SizedBox(height: 16),


            Consumer(builder: (context, ref, child){
               if(technicianState is IndividualTechnicianLoaded){
                if (_controllers.isEmpty) {
                  _controllers['phone'] = TextEditingController(text: technicianState.technician.phone);
                  _controllers['skills'] = TextEditingController(text: technicianState.technician.skills);
                  _controllers['experience'] = TextEditingController(text: technicianState.technician.experience);
                  _controllers['education_level'] = TextEditingController(text: technicianState.technician.education_level);
                  _controllers['available_location'] = TextEditingController(text: technicianState.technician.available_location);
                  _controllers['additional_bio'] = TextEditingController(text: technicianState.technician.additional_bio);
                }}
                return (technicianState is IndividualTechnicianLoaded) ? Column(
                  children: [

                    const SizedBox(height: 10),
                    const SizedBox(height: 20),
                    Image.asset(
                      "assets/technician.png",
                      width: 125,
                      height: 125,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      technicianState.technician.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InfoLabel(label: "Email", data: technicianState.technician.email),
                          const SizedBox(height: 3),
                          EditableField(label: "Phone", data: technicianState.technician.phone, controller: _controllers['phone']),
                          const SizedBox(height: 3),
                          EditableField(label: "Skills", data: technicianState.technician.skills, controller: _controllers['skills']),
                          const SizedBox(height: 3),
                          EditableField(label: "Experience", data: technicianState.technician.experience, controller: _controllers['experience']),
                          const SizedBox(height: 3),
                          EditableField(label: "Education Level", data: technicianState.technician.education_level, controller: _controllers['education_level']),
                          const SizedBox(height: 3),
                          EditableField(label: "Available Location", data: technicianState.technician.available_location, controller: _controllers['available_location']),
                          const SizedBox(height: 3),
                          EditableField(label: "Additional Bio", data: technicianState.technician.additional_bio, controller: _controllers['additional_bio']),
                          const SizedBox(height: 16),
                          Center(
                            child: ElevatedButton(
                              onPressed: () => updateProfile(technicianState.technician),
                              style: TextButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                              ),
                              child: const Text(
                                "Update Profile",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          changePassword
                              ? Center(
                                  child: SizedBox(
                                    width: 250,
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: oldPasswordController,
                                          decoration: const InputDecoration(
                                            hintText: 'Enter old password',
                                            border: OutlineInputBorder(),
                                          ),
                                          obscureText: true,
                                        ),
                                        const SizedBox(height: 15),
                                        TextField(
                                          controller: newPasswordController,
                                          decoration: const InputDecoration(
                                            hintText: 'Enter new password',
                                            border: OutlineInputBorder(),
                                          ),
                                          obscureText: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(height: 15),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (changePassword && oldPasswordController.text.isNotEmpty && newPasswordController.text.isNotEmpty) {
                                    updatePassword(technicianState.technician.id);
                                  }
                                  changePassword = !changePassword;
                                });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                              ),
                              child: Text(
                                changePassword ? "Save Changes" : "Change Password",
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
      ),
    ),
  ],
): Center(child: Text("Loading"));

            }),
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
              
            ),
          
        );
      
  }

  void updateProfile(technician) {
    final updatedData = {
      'phone': _controllers['phone']?.text,
      'skills': _controllers['skills']?.text,
      'experience': _controllers['experience']?.text,
      'educationLevel': _controllers['education_level']?.text,
      'availableLocation': _controllers['available_location']?.text,
      'additionalBio': _controllers['additional_bio']?.text,
      "status": technician.status
    };

    ref.read(individualTechnicianNotifierProvider.notifier).updateTechnicianProfile(technicianId: technician.id, updates: updatedData);
  }

  void updatePassword(id) {
    // Implement the password update logic here using the notifier
    ref.read(individualTechnicianNotifierProvider.notifier).updatePassword(id: id, oldPassword: oldPasswordController.text, newPassword:  newPasswordController.text, role: "technician");
    oldPasswordController.clear();
    newPasswordController.clear();
  }
}




