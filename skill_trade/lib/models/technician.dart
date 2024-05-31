// import 'dart:js_util';

import 'package:skill_trade/presentation/widgets/technician_application.dart';

class Technician{ 
  final String name, speciality;
  final int id;
  final String role = "technician";
  String email, phone, password, status, experience, educationLevel, availableLocation, additionalBio;

  Technician({required this.name, required this.id, required this.speciality, this.status ="pending", this.email = "", this.phone = "", this.password = "", this.availableLocation = "", this.additionalBio = "", this.educationLevel = "", this.experience = ""});


  factory Technician.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'fullName': String name,
        'skills': String speciality,
        'id': int id,

      } =>

        Technician(
          name: name,
          speciality: speciality,
          id: id
        ),
      _ => throw const FormatException('Failed to load technician.'),
    };
  }

    factory Technician.fromFullJson(Map<String, dynamic> json) => Technician(
        id: json['id'],
        name: json['fullName'],
        email: json['email'],
        phone: json['phone'],
        speciality: json["skills"],
        experience: json['experience'],
        educationLevel: json['educationLevel'],
        additionalBio: json['additionalBio'], 
        availableLocation: json['availableLocation'],
        status: json['status']
      );


  toJson(){ 
    return ( 
      { 
      "fullName": name,
      "skills": speciality,
      "email": email,
      "password": password,
      "phone": phone,
      "role": role,
      "experience": experience,
      "additionalBio": additionalBio,
      "educationLevel": educationLevel,
      "availableLocation": availableLocation,
      "status": status

      }
    );
  }


}