import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UserAgentHelper {
  UserAgentHelper._();

  /// Returns a user agent string in the format:
  /// {Device} ({OS} {OSVersion}) v{AppVersion}
  /// 
  /// Example: Pixel 7 (Android 14) v1.0.0
  static Future<String> generate() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final packageInfo = await PackageInfo.fromPlatform();
      final appVersion = packageInfo.version;

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return 'android-app/$appVersion (${androidInfo.model}; Android ${androidInfo.version.release})';
      }
 
      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return 'ios-app/$appVersion (${iosInfo.utsname.machine}; iOS ${iosInfo.systemVersion})';
      }
 
      return 'flutter-app/$appVersion ($Platform)';
    } catch (_) {
      return 'flutter-app/1.0.0';
    }
  }
}
