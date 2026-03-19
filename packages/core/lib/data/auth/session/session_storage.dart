import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

/// Service responsible for persisting authentication tokens and session status.
/// This uses [SharedPreferences] to ensure auth state is maintained across app restarts.
class SessionStorage {
  SessionStorage._();
  static final instance = SessionStorage._();
  static const _secureStorage = FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';
  static const String _profileSyncedAtKey = 'profile_synced_at';
  static const String _installIdPrefsKey = 'install_id_v1';
  static const String _installIdSecureKey = 'install_id_v1';

  SharedPreferences? _prefs;
  String? _authToken;
  bool _secureValuesLoaded = false;

  /// Initialize the persistent storage. Must be called during app bootstrap.
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _syncInstallIdentity();
    if (_secureValuesLoaded) return;
    _authToken = await _secureStorage.read(key: _tokenKey);
    _secureValuesLoaded = true;
  }

  /// Whether a valid auth token is currently available.
  bool get hasSession => authToken != null;

  /// The primary JWT token for API authorization.
  String? get authToken => _authToken;

  /// Last time profile data was synced from backend.
  DateTime? get lastProfileSyncedAt {
    final millis = _prefs?.getInt(_profileSyncedAtKey);
    if (millis == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  /// Persists authentication tokens to disk.
  Future<void> persistSession({
    required String authToken,
  }) async {
    await initialize();
    _authToken = authToken;
    await _secureStorage.write(key: _tokenKey, value: authToken);
  }

  /// Clears all stored auth data to terminate the session.
  Future<void> clear() async {
    final prefs = await _requirePrefs();
    _authToken = null;
    await _secureStorage.delete(key: _tokenKey);
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

  Future<void> _syncInstallIdentity() async {
    final prefs = _prefs!;
    final prefsInstallId = prefs.getString(_installIdPrefsKey);
    final secureInstallId = await _secureStorage.read(key: _installIdSecureKey);

    if (prefsInstallId == null) {
      // First launch for this app install. Create an install identity and
      // only clear auth keys if secure storage belongs to a different install.
      final newInstallId = _newInstallId();
      if (secureInstallId != null && secureInstallId != newInstallId) {
        await _clearSecureAuthKeys();
      }
      await _secureStorage.write(key: _installIdSecureKey, value: newInstallId);
      await prefs.setString(_installIdPrefsKey, newInstallId);
      return;
    }

    if (secureInstallId == null) {
      // Upgrade path: don't sign out existing users. Just backfill secure ID.
      await _secureStorage.write(key: _installIdSecureKey, value: prefsInstallId);
      return;
    }

    if (secureInstallId != prefsInstallId) {
      // Secure data belongs to another install (for example iOS reinstall).
      await _clearSecureAuthKeys();
      await _secureStorage.write(key: _installIdSecureKey, value: prefsInstallId);
    }
  }

  Future<void> _clearSecureAuthKeys() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  String _newInstallId() {
    final now = DateTime.now().microsecondsSinceEpoch;
    final random = Random().nextInt(1 << 32);
    return '$now-$random';
  }
}
