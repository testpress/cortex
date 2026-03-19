import 'package:dio/dio.dart';
import '../../auth/session/session_storage.dart';

/// Interceptor that attaches the JWT authentication token to every outgoing request.
/// Uses the `JWT <token>` format required by v2.5 API.
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = SessionStorage.instance.authToken;

    if (token != null) {
      options.headers['Authorization'] = 'JWT $token';
    }

    handler.next(options);
  }
}
