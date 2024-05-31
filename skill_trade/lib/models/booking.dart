class Booking {
 final int id;
 final int customerId;
 final int technicianId;
 final DateTime bookedDate;
 final DateTime serviceDate;
 final String serviceNeeded;
 final String problemDescription;
 final String serviceLocation;
 final String status;

 Booking({
  required this.id, 
  required this.customerId, 
  required this.technicianId, 
  required this.bookedDate, 
  required this.serviceDate, 
  required this.serviceNeeded, 
  required this.problemDescription, 
  required this.serviceLocation,
  required this.status
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json["id"], 
    customerId: json["customerId"], 
    technicianId: json["technicianId"], 
    bookedDate: DateTime(int.parse(json["createdDate"].substring(0,4)), int.parse(json["createdDate"].substring(5,7)), int.parse(json["createdDate"].substring(8,10))), 
    serviceDate: DateTime(int.parse(json["serviceDate"].substring(0,4)), int.parse(json["serviceDate"].substring(5,7)), int.parse(json["serviceDate"].substring(8,10))), 
    serviceNeeded: json["serviceNeeded"], 
    problemDescription: json["problemDescription"], 
    serviceLocation: json["serviceLocation"], 
    status: json["status"],
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'technicianId': technicianId,
      'bookedDate': bookedDate.toIso8601String(),
      'serviceDate': serviceDate.toIso8601String(),
      'serviceNeeded': serviceNeeded,
      "problemDescription": problemDescription,
      "serviceLocation": serviceLocation,
      'status': status,
    };
  }
}