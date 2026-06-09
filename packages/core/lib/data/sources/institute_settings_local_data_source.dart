import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/institute_settings.dart';

class InstituteSettingsLocalDataSource {
  static const String _settingsKey = 'institute_settings_cache';
  final FlutterSecureStorage _secureStorage;

  InstituteSettingsLocalDataSource({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  Future<void> saveSettings(InstituteSettings settings) async {
    final jsonString = jsonEncode(settings.toJson());
    await _secureStorage.write(key: _settingsKey, value: jsonString);
  }

  Future<InstituteSettings?> loadSettings() async {
    final jsonString = await _secureStorage.read(key: _settingsKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        return InstituteSettings.fromJson(jsonMap);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
