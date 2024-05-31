import 'package:skill_trade/domain/models/customer.dart';

abstract class CustomerRepository {
  Future<Customer> fetchCustomer(int customerId);
  Future<List<Customer>> fetchAllCustomers();
  Future<void> updatePassword(Map<String, dynamic> updates);
}