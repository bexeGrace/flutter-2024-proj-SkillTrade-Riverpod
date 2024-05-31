import 'package:skill_trade/domain/models/customer.dart';
import 'package:skill_trade/domain/repositories/customer_repository.dart';
import 'package:skill_trade/infrastructure/data_sources/customer_remote_data_source.dart';
import 'package:skill_trade/infrastructure/storage/storage.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final SecureStorage secureStorage;
  final CustomerRemoteDataSource remoteDataSource;

  CustomerRepositoryImpl({
    required this.secureStorage,
    required this.remoteDataSource,
  });

  Future<String> _getToken() async {
    return await secureStorage.read("token") ?? "";
  }

  Future<String> _getEndpoint() async {
    return await secureStorage.read("endpoint") ?? "";
  }

  @override
  Future<Customer> fetchCustomer(int customerId) async {
    final endpoint = await _getEndpoint();
    final token = await _getToken();
    return await remoteDataSource.fetchCustomer(customerId, endpoint, token);
  }

  @override
  Future<List<Customer>> fetchAllCustomers() async {
    final endpoint = await _getEndpoint();
    final token = await _getToken();
    return await remoteDataSource.fetchAllCustomers(endpoint, token);
  }
  
  @override
  Future<void> updatePassword(Map<String, dynamic> updates) async {
    final endpoint = await _getEndpoint();
    final token = await _getToken();
    await remoteDataSource.updatePassword(endpoint, token, updates);
  }
}