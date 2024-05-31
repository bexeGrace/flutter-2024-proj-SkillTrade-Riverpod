import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage._privateConstructor() {
    _initialize();
  }

  static final SecureStorage instance = SecureStorage._privateConstructor();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> write(String key, value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(key) async {
    await _storage.delete(key: key);
  }

  Future<void> _initialize() async {
    await write("endpoint", "localhost");
  }

  Future<void> init() async {
    await write("endpoint", "localhost");
  }
}