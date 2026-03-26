import 'package:dio/dio.dart';

/// Attaches the JWT authentication token to the Authorization header.
/// Fetches the token asynchronously from storage to ensure it's always fresh.
class AuthInterceptor extends Interceptor {
  final Future<String?> Function() getToken;

  const AuthInterceptor(this.getToken);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'JWT $token';
    }
    handler.next(options);
  }
}
