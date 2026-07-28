import 'package:dio/dio.dart';
import 'api_endpoints.dart';
import '../data/exceptions/api_exception.dart';

/// Attaches the JWT authentication token to the Authorization header.
/// Fetches the token asynchronously from storage to ensure it's always fresh.
/// Also handles global 401 Unauthorized responses to trigger session expiry dialog.
class AuthInterceptor extends Interceptor {
  final Future<String?> Function() getToken;
  final void Function(String message)? onSessionExpired;
  bool _isLoggingOut = false;

  /// Paths that should not have an Authorization header attached.
  static const _authFlowPaths = [
    ApiEndpoints.login,
    ApiEndpoints.generateOtp,
    ApiEndpoints.verifyOtp,
    ApiEndpoints.resetPassword,
  ];

  AuthInterceptor({required this.getToken, this.onSessionExpired});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip attaching token for login related paths
    final isAuthFlowPath = _authFlowPaths.any(
      (path) => options.path.contains(path),
    );

    if (isAuthFlowPath) {
      _isLoggingOut = false;
    } else {
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
      final isAuthFlowPath = _authFlowPaths.any(
        (path) => err.requestOptions.path.contains(path),
      );

      final isLogoutRequest = err.requestOptions.path.contains(
        ApiEndpoints.logout,
      );

      if (!isAuthFlowPath && !isLogoutRequest) {
        if (!_isLoggingOut) {
          _isLoggingOut = true;
          final apiException = ApiException.fromDioException(err);
          // Pass the backend message, or empty string if none — the dialog
          // resolves an empty message to a localized fallback at render time.
          onSessionExpired?.call(apiException.message);
        }
      }
    }
    super.onError(err, handler);
  }
}
