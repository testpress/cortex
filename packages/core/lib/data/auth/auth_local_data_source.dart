import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'types/auth_exception.dart';

class AuthLocalDataSource {
  static const _authTokenKey = 'auth_token';

  final FlutterSecureStorage _storage;

  AuthLocalDataSource({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  Future<bool> isUserLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<String?> getToken() async {
    try {
      final token = await _storage.read(key: _authTokenKey);
      if (token == null || token.trim().isEmpty) {
        return null;
      }
      return token;
    } catch (_) {
      throw const AuthException(
        'Failed to read auth token from secure storage',
      );
    }
  }

  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _authTokenKey, value: token);
    } catch (_) {
      throw const AuthException('Failed to save auth token in secure storage');
    }
  }

  Future<void> clearToken() async {
    try {
      await _storage.delete(key: _authTokenKey);
    } catch (_) {
      throw const AuthException(
        'Failed to clear auth token from secure storage',
      );
    }
  }
}
