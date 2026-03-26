import 'package:dio/dio.dart';
import 'user_agent_helper.dart';

/// Attaches the Testpress-compatible User-Agent to every request.
/// Since it needs async calls (platform version), it caches the string after the first fetch.
class UserAgentInterceptor extends Interceptor {
  String? _userAgent;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    _userAgent ??= await UserAgentHelper.generate();
    
    options.headers['User-Agent'] = _userAgent;
    
    return handler.next(options);
  }
}
