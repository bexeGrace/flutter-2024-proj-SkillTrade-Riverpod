
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skill_trade/domain/models/customer.dart';
import 'package:skill_trade/infrastructure/data_sources/customer_remote_data_source.dart';

class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  final http.Client client;

  CustomerRemoteDataSourceImpl({required this.client});

  @override
  Future<Customer> fetchCustomer(int customerId, String endpoint, String token) async {
    final headers = {"Authorization": "Bearer $token"};
    final response = await client.get(Uri.parse('http://$endpoint:9000/customer/$customerId'), headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Customer.fromJson(data);
    } else {
      throw Exception('Error fetching customer');
    }
  }

  @override
  Future<List<Customer>> fetchAllCustomers(String endpoint, String token) async {
    final headers = {"Authorization": "Bearer $token"};
    final response = await client.get(Uri.parse('http://$endpoint:9000/customer'), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Customer.fromJson(json)).toList();
    } else {
      throw Exception('Error fetching customers');
    }
  }
  
  @override
  Future<void> updatePassword(String endpoint, String token, Map<String, dynamic> updates) async {
    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
    final response = await client.patch(Uri.parse('http://$endpoint:9000/trader/update-ps'), 
        headers: headers,
        body: json.encode(updates),
      );

    if (response.statusCode != 200) {
      throw Exception('Old password is incorrect');
    }
  }
}
