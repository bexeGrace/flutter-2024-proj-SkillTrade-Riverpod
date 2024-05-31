class Technician{ 
  final String name, specialty;
  final int id;
  final String role = "technician";
  String email, phone, password, status, experience, educationLevel, availableLocation, additionalBio;

  Technician({required this.name, required this.id, required this.specialty, this.status ="pending", this.email = "", this.phone = "", this.password = "", this.availableLocation = "", this.additionalBio = "", this.educationLevel = "", this.experience = ""});


  factory Technician.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'fullName': String name,
        'skills': String specialty,
        'id': int id,

      } =>

        Technician(
          name: name,
          specialty: specialty,
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
        specialty: json["skills"],
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
      "skills": specialty,
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