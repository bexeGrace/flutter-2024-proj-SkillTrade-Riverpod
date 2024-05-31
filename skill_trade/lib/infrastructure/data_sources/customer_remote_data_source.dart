import 'package:skill_trade/domain/models/customer.dart';

abstract class CustomerRemoteDataSource {
  Future<Customer> fetchCustomer(int customerId, String endpoint, String token);
  Future<List<Customer>> fetchAllCustomers(String endpoint, String token);
  Future<void> updatePassword(String endpoint, String token, Map<String, dynamic> updates);
}