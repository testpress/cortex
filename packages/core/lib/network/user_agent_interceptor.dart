import 'dart:io';
import 'package:dio/dio.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Attaches the Testpress-compatible User-Agent to every request.
/// Since it needs async calls (platform version), it caches the string after the first fetch.
class UserAgentInterceptor extends Interceptor {
  static const _userAgentPrefix = 'flutter-app';
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
        return '$_userAgentPrefix/$appVersion (${androidInfo.model}; Android ${androidInfo.version.release})';
      }
 
      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return '$_userAgentPrefix/$appVersion (${iosInfo.utsname.machine}; iOS ${iosInfo.systemVersion})';
      }

      return '$_userAgentPrefix/$appVersion (${Platform.operatingSystem}; ${Platform.operatingSystemVersion})';
    } catch (_) {
      return '$_userAgentPrefix/1.0.0';
    }
  }
}
