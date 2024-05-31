import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skill_trade/domain/models/technician.dart';
import 'package:skill_trade/infrastructure/storage/storage.dart';

class TechnicianRemoteDataSource {
  Future<Map<String, String>> _getHeaders() async {
    final token = await SecureStorage.instance.read("token");
    return {"Authorization": "Bearer $token"};
  }

  Future<String?> _getEndpoint() async {
    return await SecureStorage.instance.read("endpoint");
  }

  Future<List<Technician>> fetchTechnicians() async {
    final endpoint = await _getEndpoint();
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('http://$endpoint:9000/technician'), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Technician.fromJson(json)).toList();
    } else {
      throw Exception('Error fetching technicians');
    }
  }

  Future<List<Technician>> fetchPendingTechnicians() async {
    final endpoint = await _getEndpoint();
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('http://$endpoint:9000/technician/pending/all'), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Technician.fromJson(json)).toList();
    } else {
      throw Exception('Error fetching pending technicians');
    }
  }

  Future<List<Technician>> fetchSuspendedTechnicians() async {
    final endpoint = await _getEndpoint();
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('http://$endpoint:9000/technician/suspended/all'), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Technician.fromJson(json)).toList();
    } else {
      throw Exception('Error fetching suspended technicians');
    }
  }
}