import 'package:dio/dio.dart';
import 'api_endpoints.dart';
import '../data/exceptions/api_exception.dart';

/// Attaches the JWT authentication token to the Authorization header.
/// Fetches the token asynchronously from storage to ensure it's always fresh.
/// Also handles global 401 Unauthorized responses to trigger session expiry dialog.
class AuthInterceptor extends Interceptor {
  final Future<String?> Function() getToken;
  final void Function(String message)? onSessionExpired;
  final bool Function()? isLoggingOut;
  bool _sessionExpiryTriggered = false;

  /// Paths that should not have an Authorization header attached.
  static const _authFlowPaths = [
    ApiEndpoints.login,
    ApiEndpoints.socialAuth,
    ApiEndpoints.register,
    ApiEndpoints.generateOtp,
    ApiEndpoints.verifyOtp,
    ApiEndpoints.resetPassword,
  ];

  AuthInterceptor({
    required this.getToken,
    this.onSessionExpired,
    this.isLoggingOut,
  });

  /// Explicitly resets the session expiry guard (e.g. on fresh login).
  void resetSessionExpiry() {
    _sessionExpiryTriggered = false;
  }

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
      _sessionExpiryTriggered = false;
    } else {
      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'JWT $token';
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // A successful response with an auth header proves the session is valid.
    if (response.requestOptions.headers.containsKey('Authorization')) {
      _sessionExpiryTriggered = false;
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      final hasAuthHeader = err.requestOptions.headers['Authorization'] != null;

      final isAuthFlowPath = _authFlowPaths.any(
        (path) => err.requestOptions.path.contains(path),
      );

      final isLogoutRequest =
          err.requestOptions.path.contains(ApiEndpoints.logout) ||
          err.requestOptions.path.contains(ApiEndpoints.logoutDevices);

      final loggingOut = isLoggingOut?.call() ?? false;

      // Only trigger session expired dialog if:
      // 1. The request was actually authenticated (had Authorization header).
      // 2. It was not an auth flow endpoint (login/signup/otp).
      // 3. It was not an explicit logout request.
      // 4. A manual logout is not currently in progress.
      // 5. We haven't already shown the session expired dialog for this session.
      if (hasAuthHeader && !isAuthFlowPath && !isLogoutRequest && !loggingOut) {
        if (!_sessionExpiryTriggered) {
          _sessionExpiryTriggered = true;
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
