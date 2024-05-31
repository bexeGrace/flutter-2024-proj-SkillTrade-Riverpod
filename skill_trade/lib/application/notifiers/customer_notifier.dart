import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/domain/repositories/customer_repository.dart';
import 'package:skill_trade/application/states/customer_state.dart';

class CustomerNotifier extends StateNotifier<CustomerState> {
  final CustomerRepository customerRepository;

  CustomerNotifier({required this.customerRepository}) : super(CustomerLoading()){
    
  }

  Future<void> loadCustomer(int customerId) async {
    state = CustomerLoading();
    try {
      final customer = await customerRepository.fetchCustomer(customerId);
      state = CustomerLoaded(customer: customer);
    } catch (error) {
      state = CustomerError(error.toString());
    }
  }

  Future<void> loadAllCustomers() async {
    state = CustomerLoading();
    try {
      final customers = await customerRepository.fetchAllCustomers();
      state = AllCustomersLoaded(customers);
    } catch (error) {
      state = CustomerError(error.toString());
    }
  }

  Future<void> updatePassword({
    required String role,
    required int id,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await customerRepository.updatePassword({
        "role": role,
        "id": id,
        "newPassword": newPassword,
        "password": oldPassword,
      });
    } catch (error) {
      state = CustomerError(error.toString());
    }
  }
}

