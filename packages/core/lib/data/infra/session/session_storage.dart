import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_dto.dart';

/// In-memory + persistent storage for the authenticated session.
class SessionStorage extends ChangeNotifier {
  SessionStorage._();

  static final SessionStorage instance = SessionStorage._();

  static const _tokenKey = 'cortex_session_token';
  static const _userKey = 'cortex_session_user';
  static const _isNewUserKey = 'cortex_session_is_new_user';

  SharedPreferences? _preferences;
  String? _token;
  String? _userJson;
  bool _isNewUser = false;
  bool _initialized = false;

  /// Loads any persisted session data from shared preferences.
  Future<void> initialize() async {
    if (_initialized) return;
    _preferences = await SharedPreferences.getInstance();
    _token = _preferences?.getString(_tokenKey);
    _userJson = _preferences?.getString(_userKey);
    _isNewUser = _preferences?.getBool(_isNewUserKey) ?? false;
    _initialized = true;
    notifyListeners();
  }

  bool get hasSession => _token != null && _token!.isNotEmpty;

  String? get token => _token;

  String? get authorizationHeader => hasSession ? 'JWT $_token' : null;

  Map<String, dynamic>? get rawUserData {
    if (_userJson == null) return null;
    return jsonDecode(_userJson!);
  }

  UserDto? get cachedUser {
    final data = rawUserData;
    if (data == null || data.isEmpty) return null;
    try {
      return UserDto.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  bool get isNewUser => _isNewUser;

  Future<void> persistSession({
    required String token,
    UserDto? user,
    bool isNewUser = false,
  }) async {
    await _ensurePrefs();
    _token = token;
    _isNewUser = isNewUser;
    if (user != null) {
      _userJson = jsonEncode(user.toJson());
      await _preferences?.setString(_userKey, _userJson!);
    }
    await _preferences?.setString(_tokenKey, token);
    await _preferences?.setBool(_isNewUserKey, isNewUser);
    notifyListeners();
  }

  Future<void> persistUserProfile(UserDto user) async {
    await _ensurePrefs();
    _userJson = jsonEncode(user.toJson());
    await _preferences?.setString(_userKey, _userJson!);
    notifyListeners();
  }

  Future<void> clear() async {
    _token = null;
    _userJson = null;
    _isNewUser = false;
    notifyListeners();

    await _ensurePrefs();
    await _preferences?.remove(_tokenKey);
    await _preferences?.remove(_userKey);
    await _preferences?.remove(_isNewUserKey);
  }

  Future<void> _ensurePrefs() async {
    if (_preferences != null) return;
    _preferences = await SharedPreferences.getInstance();
  }
}
