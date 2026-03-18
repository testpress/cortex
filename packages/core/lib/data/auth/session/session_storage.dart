import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service responsible for persisting authentication tokens and session status.
/// This uses [SharedPreferences] to ensure auth state is maintained across app restarts.
class SessionStorage {
  SessionStorage._();
  static final instance = SessionStorage._();
  static const _secureStorage = FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'auth_refresh_token';
  static const String _profileSyncedAtKey = 'profile_synced_at';

  SharedPreferences? _prefs;
  String? _authToken;
  String? _refreshToken;
  bool _secureValuesLoaded = false;

  /// Initialize the persistent storage. Must be called during app bootstrap.
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    if (_secureValuesLoaded) return;
    _authToken = await _secureStorage.read(key: _tokenKey);
    _refreshToken = await _secureStorage.read(key: _refreshTokenKey);
    _secureValuesLoaded = true;
  }

  /// Whether a valid auth token is currently available.
  bool get hasSession => authToken != null;

  /// The primary JWT token for API authorization.
  String? get authToken => _authToken;

  /// The token used to refresh an expired auth token.
  String? get refreshToken => _refreshToken;

  /// Last time profile data was synced from backend.
  DateTime? get lastProfileSyncedAt {
    final millis = _prefs?.getInt(_profileSyncedAtKey);
    if (millis == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  /// Persists authentication tokens to disk.
  Future<void> persistSession({
    required String authToken,
    String? refreshToken,
  }) async {
    await initialize();
    _authToken = authToken;
    await _secureStorage.write(key: _tokenKey, value: authToken);
    if (refreshToken != null) {
      _refreshToken = refreshToken;
      await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }

  /// Clears all stored auth data to terminate the session.
  Future<void> clear() async {
    final prefs = await _requirePrefs();
    _authToken = null;
    _refreshToken = null;
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await prefs.remove(_profileSyncedAtKey);
  }

  /// Records profile sync completion time for startup throttling.
  Future<void> markProfileSyncedNow() async {
    final prefs = await _requirePrefs();
    await prefs.setInt(
      _profileSyncedAtKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<SharedPreferences> _requirePrefs() async {
    await initialize();
    return _prefs!;
  }
}
