import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skill_trade/domain/models/review.dart';
import 'package:skill_trade/infrastructure/storage/storage.dart';

class ReviewRemoteDataSource {
  Future<Map<String, String>> _getHeaders() async {
    final token = await SecureStorage.instance.read("token");
    return {"Authorization": "Bearer $token", 
      "Content-Type": "application/json",
    };
  }

  Future<String?> _getEndpoint() async {
    return await SecureStorage.instance.read("endpoint");
  }

  Future<List<Review>> fetchTechnicianReviews(int technicianId) async {
    final endpoint = await _getEndpoint();
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('http://$endpoint:9000/review-rate/technician/$technicianId'), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) {
        Map<String, dynamic> cur = {
          "rate": json["rate"],
          "review": json["review"],
          "user": json["user"]["fullName"],
          "userId": json["user"]["id"],
          "id": json["id"]
        };
        return Review.fromJson(cur);
      }).toList();
    } else {
      throw Exception('Error fetching reviews');
    }
  }

  Future<void> postReview(int technicianId, int customerId, double rate, String review) async {
    final endpoint = await _getEndpoint();
    final headers = await _getHeaders();
    headers['Content-Type'] = 'application/json';
    final response = await http.post(
      Uri.parse('http://$endpoint:9000/review-rate/technician/$technicianId'),
      headers: headers,
      body: json.encode({
        "customerId": customerId,
        "technicianId": technicianId,
        "rate": rate,
        "review": review
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Error posting review');
    }
  }

  Future<void> updateReview(int reviewId, Map<String, dynamic> updates) async {
    final endpoint = await _getEndpoint();
    final headers = await _getHeaders();
    headers['Content-Type'] = 'application/json';
    final response = await http.patch(
      Uri.parse('http://$endpoint:9000/review-rate/$reviewId'),
      headers: headers,
      body: json.encode(updates),
    );
    if (response.statusCode != 200) {
      throw Exception('Error updating review');
    }
  }

  Future<void> deleteReview(int reviewId) async {
    final endpoint = await _getEndpoint();
    final headers = await _getHeaders();
    final response = await http.delete(Uri.parse('http://$endpoint:9000/review-rate/$reviewId'), headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error deleting review');
    }
  }
}