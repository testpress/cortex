import 'dart:io';
import 'package:dio/dio.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Attaches the Testpress-compatible User-Agent to every request.
/// Since it needs async calls (platform version), it caches the string after the first fetch.
class UserAgentInterceptor extends Interceptor {
  String? _userAgent;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    _userAgent ??= await _generateUserAgent();
    
    options.headers['User-Agent'] = _userAgent;
    
    return handler.next(options);
  }

  Future<String> _generateUserAgent() async {
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
