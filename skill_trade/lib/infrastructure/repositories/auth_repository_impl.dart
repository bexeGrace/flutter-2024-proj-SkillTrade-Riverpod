import 'package:skill_trade/domain/repositories/auth_repository.dart';
import 'package:skill_trade/infrastructure/data_sources/remote_data_source.dart';
import 'package:skill_trade/infrastructure/storage/storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteDataSource remoteDataSource;
  final SecureStorage secureStorage;

  AuthRepositoryImpl(this.remoteDataSource, this.secureStorage);

  @override
  Future<String> logIn(String role, String email, String password) async {
    final endpoint = await secureStorage.read("endpoint");
    try {
      final data = await remoteDataSource.logIn(endpoint!, role, email, password);
      if (data["role"] == "technician") {
        print(data["status"]);
        if (data["status"] == "pending") {
          throw Exception("Your application is being processed. Thank you for your patience");
        } else if (data["status"] == "declined") {
          throw Exception("Your application has been declined");
        } else if (data["status"] == "suspended") {
          throw Exception("Your account has been suspended");
        }
      }
      await secureStorage.write("token", data["access_token"]);
      await secureStorage.write("role", data["role"]);
      await secureStorage.write("id", data["userId"].toString());
      return data["role"];
    } catch (error) {
      throw Exception(error.toString().split(":")[1]);
    }
  }

  @override
  Future<void> signUpCustomer(String email, String password, String phone, String fullName) async {
    final endpoint = await secureStorage.read("endpoint");
    print("hello in repo impl");
    await remoteDataSource.signUpCustomer(endpoint!, email, password, phone, fullName);
  }

  @override
  Future<void> signUpTechnician(String email, String password, String phone, String fullName, String skills, String experience, String educationLevel, String availableLocation, String additionalBio) async {
    final endpoint = await secureStorage.read("endpoint");
    await remoteDataSource.signUpTechnician(endpoint!, email, password, phone, fullName, skills, experience, educationLevel, availableLocation, additionalBio);
  }

  @override
  Future<String?> getToken() async {
    return await secureStorage.read("token");
  }

  @override
  Future<String?> getRole() async {
    return await secureStorage.read("role");
  }

  @override
  Future<void> clearData() async {
    await secureStorage.write("token", null);
    await secureStorage.write("role", null);
    await secureStorage.write("id", null);
  }

  @override
  Future<void> deleteAccount() async {
    final role = await secureStorage.read("role");
    final id = await secureStorage.read("id");
    final endpoint = await secureStorage.read("endpoint");
    await remoteDataSource.deleteAccount(endpoint!, id!, role!);
    clearData();
  }
}