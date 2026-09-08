import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'types/auth_exception.dart';

class AuthLocalDataSource {
  /// Pre-boot helper: called in main() before runApp() to obtain a fast
  /// synchronous-equivalent auth signal without duplicating storage logic.
  ///
  /// Never throws — a bad Android Keystore (e.g. after an OS/backup restore)
  /// returns false so the app starts in a graceful unauthenticated state
  /// instead of crashing before runApp().
  static Future<bool> checkCachedLogin() async {
    try {
      return await AuthLocalDataSource().isUserLoggedIn();
    } catch (_) {
      return false;
    }
  }

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
