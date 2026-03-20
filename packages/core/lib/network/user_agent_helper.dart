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
        return '${androidInfo.model} (Android ${androidInfo.version.release}) v$appVersion';
      }

      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return 'ios-app ${iosInfo.utsname.machine} (iOS ${iosInfo.systemVersion}) v$appVersion';
      }

      return 'ios-app ($Platform) v$appVersion';
    } catch (_) {
      return 'ios-app/1.0.0';
    }
  }
}
