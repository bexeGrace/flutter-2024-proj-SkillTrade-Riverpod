import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:skill_trade/models/customer.dart';
import 'dart:convert';
import 'package:skill_trade/riverpod/secure_storage_provider.dart';

import '../ip_info.dart';

final customerByIdProvider = FutureProvider.family<Customer, int>((ref, customerId) async {
  final secureStorageService = ref.read(secureStorageProvider);
  final token = await secureStorageService.read("token");

  final response = await http.get(
    Uri.parse("http://$endpoint:9000/customer/$customerId"),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return Customer.fromJson(data);
  } else {
    throw Exception("Failed to load customer.");
  }
});

final customerProfileProvider = FutureProvider<Customer>((ref) async {
  final secureStorageService = ref.read(secureStorageProvider);
  final id = await secureStorageService.read('userId');
  if (id == null) {
    throw Exception("No customer found");
  }

  final customer = await ref.read(customerByIdProvider(int.parse(id)).future);

  return customer;
});



final fetchAllCustomers = FutureProvider<List<Customer>>((ref) async {
  final secureStorageService = ref.read(secureStorageProvider);

  final token = await secureStorageService.read("token");
  final response = await http.get(
    Uri.parse("http://$endpoint:9000/customer"),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );


  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Customer.fromJson(json)).toList();
  } else {
    throw Exception("Failed to load customers.");
  }
});

class CustomerState {
  final Customer? customer;
  final bool isLoading;
  final String? error;

  CustomerState({this.customer, this.isLoading = false, this.error});

  CustomerState copyWith({Customer? customer, bool? isLoading, String? error}) {
    return CustomerState(
      customer: customer ?? this.customer,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class CustomerNotifier extends StateNotifier<CustomerState> {
  final SecureStorageService _secureStorageService;

  CustomerNotifier(this._secureStorageService) : super(CustomerState());

  Future<void> fetchProfile() async {
    try {
      state = state.copyWith(isLoading: true);
      final token = await _secureStorageService.read("token");
      final role = await _secureStorageService.read('role');
      final id = await _secureStorageService.read('userId');

      final response = await http.get(
        Uri.parse('http://$endpoint:9000/customer/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final customer = Customer.fromJson(data);
        state = state.copyWith(customer: customer, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false, error: 'Failed to load profile');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchCustomerById(int customerId) async {
    try {
      state = state.copyWith(isLoading: true);
      final token = await _secureStorageService.read("token");

      final response = await http.get(
        Uri.parse('http://$endpoint:9000/customer/$customerId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final customer = Customer.fromJson(data);
        state = state.copyWith(customer: customer, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false, error: 'Failed to load customer');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final customerNotifierProvider = StateNotifierProvider<CustomerNotifier, CustomerState>((ref) {
  final secureStorageService = ref.read(secureStorageProvider);
  return CustomerNotifier(secureStorageService);
});
