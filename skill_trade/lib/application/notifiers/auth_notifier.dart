import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/domain/repositories/auth_repository.dart';
import 'package:skill_trade/application/states/auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;

  AuthNotifier({required this.authRepository}) : super(UnLogged()) {
    _automaticLogIn();
  }

  Future<void> _automaticLogIn() async {
    final token = await authRepository.getToken();
    if (token != null) {
      final role = await authRepository.getRole();
      state = LoggedIn(role: role!);
    }
  }

  Future<void> logIn(String role, String email, String password) async {
    try {
      final loggedInRole = await authRepository.logIn(role, email, password);
      state = LoggedIn(role: loggedInRole);
    } catch (error) {
      state = AuthError(error.toString().split(":")[1]);
    }
  }

  Future<void> signUpCustomer(String email, String password, String phone, String fullName) async {
    try {
      print("hello signup in notifier");
      await authRepository.signUpCustomer(email, password, phone, fullName);
      await logIn("customer", email, password);
    } catch (error) {
      state = AuthError(error.toString());
    }
  }

  Future<void> signUpTechnician(String email, String password, String phone, String fullName, String skills, String experience, String educationLevel, String availableLocation, String additionalBio) async {
    try {
      await authRepository.signUpTechnician(email, password, phone, fullName, skills, experience, educationLevel, availableLocation, additionalBio);
      state = const AuthSuccess('Successfully applied');
    } catch (error) {
      state = AuthError(error.toString());
    }
  }

  Future<void> unlog() async {
    await authRepository.clearData();
    state = UnLogged();
  }

  Future<void> deleteAccount() async {
    await authRepository.deleteAccount();
    state = UnLogged();
  }
}
