class Technician{
  final int id;
  final String name;
  final String email;
  final String phone; 
  final String skills;
  final String experience; 
  final String education_level; 
  final String available_location; 
  final String additional_bio; 
  final String status; 

  Technician({
    required this.id, 
    required this.name, 
    required this.email, 
    required this.phone, 
    required this.skills,
    required this.experience, 
    required this.education_level, 
    required this.available_location, 
    required this.additional_bio,
    required this.status,
  });

  factory Technician.fromJson(Map<String, dynamic> json) => Technician(
        id: json['id'],
        name: json['fullName'],
        email: json['email'],
        phone: json['phone'],
        skills: json["skills"],
        experience: json['experience'],
        education_level: json['educationLevel'],
        additional_bio: json['additionalBio'], 
        available_location: json['availableLocation'],
        status: json['status'],
      );

}