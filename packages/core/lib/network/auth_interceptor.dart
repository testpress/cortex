import 'package:dio/dio.dart';

/// Attaches the JWT authentication token to the Authorization header.
/// Fetches the token asynchronously from storage to ensure it's always fresh.
/// Also handles global 401 Unauthorized responses to trigger session invalidation.
class AuthInterceptor extends Interceptor {
  final Future<String?> Function() getToken;
  final void Function()? onUnauthorized;

  /// Paths that should not have an Authorization header attached.
  static const _loginPaths = [
    '/auth-token/',
    '/generate-otp/',
    '/otp-login/',
    '/password/reset/',
  ];

  const AuthInterceptor({
    required this.getToken,
    this.onUnauthorized,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip attaching token for login related paths
    final isLoginPath = _loginPaths.any((path) => options.path.contains(path));
    
    if (!isLoginPath) {
      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'JWT $token';
      }
    }
    
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Trigger global logout logic if token is invalid/expired
      onUnauthorized?.call();
    }
    super.onError(err, handler);
  }
}
