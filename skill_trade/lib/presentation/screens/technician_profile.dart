import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_trade/presentation/widgets/editable_textfield.dart';
import 'package:skill_trade/presentation/widgets/info_label.dart';
import 'package:skill_trade/riverpod/technician_provider.dart';
// import 'package:skill_trade/state_managment/individual_technician/individual_technician_bloc.dart';
// import 'package:skill_trade/state_managment/individual_technician/individual_technician_event.dart';
// import 'package:skill_trade/state_managment/individual_technician/individual_technician_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Technician Profile",
      home: TechnicianProfile(),
    );
  }
}

class TechnicianProfile extends ConsumerStatefulWidget {
  const TechnicianProfile({Key? key}) : super(key: key);

  @override
  ConsumerState<TechnicianProfile> createState() => _TechnicianProfileState();
}

class _TechnicianProfileState extends ConsumerState<TechnicianProfile> {
  final Map<String, TextEditingController> _controllers = {};
  String? _technician_status ;

  @override
  void initState() {
    super.initState();
    ref.read(technicianProfileProvider);
 }

  @override
  Widget build(BuildContext context) {
    final technicianState = ref.watch(technicianProfileUpdateProvider);
    final technicianProfile = ref.watch(technicianProfileProvider);
    
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            const SizedBox(height: 16),
            if (technicianState.isLoading) CircularProgressIndicator(),
              if (technicianState.errorMessage != null)
                Text(
                  technicianState.errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              
              // Text('Update Successful!'),
            technicianProfile.when(
              data: (profile) {
                if (_controllers.isEmpty) {
                    _controllers['phone'] = TextEditingController(text: profile.phone);
                    _controllers['skills'] = TextEditingController(text: profile.speciality);
                    _controllers['experience'] = TextEditingController(text: profile.experience);
                    _controllers['education_level'] = TextEditingController(text: profile.educationLevel);
                    _controllers['available_location'] = TextEditingController(text: profile.availableLocation);
                    _controllers['additional_bio'] = TextEditingController(text: profile.additionalBio);
                  }
                _technician_status = profile.status;



                return Column(
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
                        profile.name,
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
                            InfoLabel(label: "Email", data: profile.email,),
                            const SizedBox(height: 3),
                            EditableField(label: "Phone", data: profile.phone, controller: _controllers['phone'],),
                            const SizedBox(height: 3),
                            EditableField(label: "Skills", data: profile.speciality, controller: _controllers['skills'],),
                            const SizedBox(height: 3),
                            EditableField(label: "Experience", data: profile.experience, controller: _controllers['experience'],),
                            const SizedBox(height: 3),
                            EditableField(label: "Education Level", data: profile.educationLevel, controller: _controllers['education_level'],),
                            const SizedBox(height: 3),
                            EditableField(label: "Available Location", data: profile.availableLocation, controller: _controllers['available_location'],),
                            const SizedBox(height: 3),
                            EditableField(label: "Additional Bio", data: profile.additionalBio, controller: _controllers['additional_bio'],),
                            const SizedBox(height: 16),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  updateProfile();
                                  if (technicianState.success) 
                                    ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text( 'Successfully updated!'),
                                          ),
                                        );
    
                                },
                                child: const Text("Update Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                                style: TextButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  );
      
                },
          
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error loading technician profile: $error')),
        ),

            
          ],
        ),
      ),
    );
  }

  void updateProfile() {
    final updatedData = {
      'phone': _controllers['phone']?.text,
      'skills': _controllers['skills']?.text,
      'experience': _controllers['experience']?.text,
      'educationLevel': _controllers['education_level']?.text,
      'availableLocation': _controllers['available_location']?.text,
      'additionalBio': _controllers['additional_bio']?.text,
      'status': _technician_status,
    };
    
    
    ref.read(technicianProfileUpdateProvider.notifier).updateTechnician(updatedData);
    

    // BlocProvider.of<IndividualTechnicianBloc>(context).add(UpdateTechnicianProfile(technicianId: technicianId, updates: updatedData));
  }
}


