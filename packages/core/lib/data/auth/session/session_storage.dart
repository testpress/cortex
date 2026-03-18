import 'package:shared_preferences/shared_preferences.dart';

/// Service responsible for persisting authentication tokens and session status.
/// This uses [SharedPreferences] to ensure auth state is maintained across app restarts.
class SessionStorage {
  SessionStorage._();
  static final instance = SessionStorage._();

  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'auth_refresh_token';
  static const String _profileSyncedAtKey = 'profile_synced_at';

  SharedPreferences? _prefs;

  /// Initialize the persistent storage. Must be called during app bootstrap.
  Future<void> initialize() async {
    if (_prefs != null) return;
    _prefs = await SharedPreferences.getInstance();
  }

  /// Whether a valid auth token is currently available.
  bool get hasSession => authToken != null;

  /// The primary JWT token for API authorization.
  String? get authToken => _prefs?.getString(_tokenKey);

  /// The token used to refresh an expired auth token.
  String? get refreshToken => _prefs?.getString(_refreshTokenKey);

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
    final prefs = await _requirePrefs();
    await prefs.setString(_tokenKey, authToken);
    if (refreshToken != null) {
      await prefs.setString(_refreshTokenKey, refreshToken);
    }
  }

  /// Clears all stored auth data to terminate the session.
  Future<void> clear() async {
    final prefs = await _requirePrefs();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
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
