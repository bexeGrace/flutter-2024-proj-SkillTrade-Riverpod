abstract class AuthRepository {
  Future<String> logIn(String role, String email, String password);
  Future<void> signUpCustomer(String email, String password, String phone, String fullName);
  Future<void> signUpTechnician(String email, String password, String phone, String fullName, String skills, String experience, String educationLevel, String availableLocation, String additionalBio);
  Future<String?> getToken();
  Future<String?> getRole();
  Future<void> clearData();
  Future<void> deleteAccount();
}