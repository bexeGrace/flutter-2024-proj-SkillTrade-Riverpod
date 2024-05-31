import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:skill_trade/models/technician.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:skill_trade/riverpod/secure_storage_provider.dart';


import '../ip_info.dart';


// @Immutable
class AuthState {
  final bool isLoading;
  final String? token;

  final String? role;
  final String? errorMessage;
  final String? successMessage;
  final bool success;
  final bool isAuthenticated;

  AuthState({this.isLoading = false, this.role, this.isAuthenticated = false, this.success = false, this.successMessage,  this.token, this.errorMessage});
  bool get isLoggedIn => token != null;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final SecureStorageService _secureStorageService;

  AuthNotifier(this._secureStorageService) : super(AuthState()) {
    _loadToken();
  }

  

  // final _storage = FlutterSecureStorage();

  Future<void> signup(user) async {
    state = AuthState(isLoading: true);
    print("signing up ${user}");
    final response = await http.post(
      Uri.parse('http://$endpoint:9000/trader/signup'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user),
    );
    print(response.body);

    if (response.statusCode == 201) {
      print("yay");
      await signin(user["role"], user["email"], user["password"]);
      if (state.isAuthenticated){
      state = AuthState(successMessage: "You have successfully signed up!", success: true, isAuthenticated: true);

      } else{
      state = AuthState(successMessage: "You have successfully signed up!", success: true);
      }
    } else {
      print("Nay");
      state = AuthState(errorMessage: "Signup has failed.");
    }
  }

  Future<void> signin(String role, String email, String password) async {
    state = AuthState(isLoading: true);
    print("signing in");
    print("sign in inputs $role, $email, $password");
    try {
      final response = await http.post(
        Uri.parse('http://$endpoint:9000/trader/signin'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "role": role,
          "email": email,
          "password": password,
        }),
      );
      print("response ${response.body} $response");

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final token = data['access_token'];

        // Save token securely
        await _secureStorageService.write("token", token);
        await _secureStorageService.write('role', data['role']);
        await _secureStorageService.write('userId', data['userId'].toString());
        state = AuthState(isLoading: false, token: token, role: role, isAuthenticated: true);

        // final storedToken = await _storage.read(key: 'token');
        // print('Stored Token: $storedToken');
      } else {
        state = AuthState(isLoading: false, errorMessage: 'Signin failed');
      }
    } catch (e) {
      state = AuthState(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> _loadToken() async {
    final token = await _secureStorageService.read("token");
    final role = await _secureStorageService.read("role");
    state = AuthState(token: token, role: role);
    if(state.token != null){
      state = AuthState(token: token, role: role, isAuthenticated: true);
    }
  }
  

  Future<void> logout() async {
    await _secureStorageService.delete("token");
    state = AuthState(token: null,);
  }
}


final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final secureStorageService = ref.read(secureStorageProvider);
  return AuthNotifier(secureStorageService);
});