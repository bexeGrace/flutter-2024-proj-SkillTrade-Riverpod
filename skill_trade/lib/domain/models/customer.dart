class Customer{
  final int id;
  final String fullName;
  final String email;
  final String phone; 

  Customer({
    required this.id, 
    required this.fullName, 
    required this.email, 
    required this.phone, 
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json['id'],
        fullName: json['fullName'],
        email: json['email'],
        phone: json['phone'],
      );
}