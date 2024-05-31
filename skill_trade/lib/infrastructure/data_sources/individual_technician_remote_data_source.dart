import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skill_trade/domain/models/technician.dart';
import 'package:skill_trade/infrastructure/storage/storage.dart';

class IndividualTechnicianRemoteDataSource {
  Future<Map<String, String>> _getHeaders() async {
    final token = await SecureStorage.instance.read("token");
    return {"Authorization": "Bearer $token"};
  }

  Future<String?> _getEndpoint() async {
    return await SecureStorage.instance.read("endpoint");
  }

  Future<Technician> fetchIndividualTechnician(int technicianId) async {
    final endpoint = await _getEndpoint();
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('http://$endpoint:9000/technician/$technicianId'), headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      data['id'] = technicianId;
      return Technician.fromJson(data);
    } else {
      throw Exception('Error fetching technician');
    }
  }

  Future<void> updateTechnicianProfile(int technicianId, Map<String, dynamic> updates) async {
    final endpoint = await _getEndpoint();
    final headers =  await _getHeaders();
    headers["Content-Type"] = "application/json";
    final response = await http.patch(
      Uri.parse('http://$endpoint:9000/technician/$technicianId'),
      headers: headers,
      body: json.encode(updates)
    );
    if (response.statusCode != 200) {
      throw Exception('Error updating technician');
    }
  }

  Future<void> updatePassword(Map<String, dynamic> updates) async {
    final endpoint = await _getEndpoint();
    final headers =  await _getHeaders();
    headers["Content-Type"] = "application/json";
    final response = await http.patch(Uri.parse('http://$endpoint:9000/trader/update-ps'), 
        headers: headers,
        body: json.encode(updates),
      );

    if (response.statusCode != 200) {
      throw Exception('Error changing password');
    }
  }
}