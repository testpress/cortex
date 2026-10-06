import 'package:dio/dio.dart';
import 'api_endpoints.dart';
import '../data/exceptions/api_exception.dart';

/// Attaches the JWT authentication token to the Authorization header.
/// Fetches the token asynchronously from storage to ensure it's always fresh.
/// Also handles global 401 Unauthorized responses to trigger session expiry dialog.
class AuthInterceptor extends Interceptor {
  final Future<String?> Function() getToken;
  final void Function(String message)? onSessionExpired;
  final void Function()? onEnforceStudentDataRequired;
  final void Function(String message)? onParallelLoginRestriction;
  final bool Function()? isLoggingOut;
  final bool Function()? isAuthenticated;
  bool _sessionExpiryTriggered = false;
  bool _parallelLoginTriggered = false;

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
    this.onEnforceStudentDataRequired,
    this.onParallelLoginRestriction,
    this.isLoggingOut,
    this.isAuthenticated,
  });

  /// Explicitly resets the session expiry guard (e.g. on fresh login).
  void resetSessionExpiry() {
    _sessionExpiryTriggered = false;
    _parallelLoginTriggered = false;
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
      final authenticated = isAuthenticated?.call() ?? true;

      // Only trigger session expired dialog if:
      // 1. The request was actually authenticated (had Authorization header).
      // 2. It was not an auth flow endpoint (login/signup/otp).
      // 3. It was not an explicit logout request.
      // 4. A manual logout is not currently in progress.
      // 5. The user is not already unauthenticated (e.g. lingering requests after logout).
      // 6. We haven't already shown the session expired dialog for this session.
      if (hasAuthHeader &&
          !isAuthFlowPath &&
          !isLogoutRequest &&
          !loggingOut &&
          authenticated) {
        if (!_sessionExpiryTriggered) {
          _sessionExpiryTriggered = true;
          final apiException = ApiException.fromDioException(err);
          // Pass the backend message, or empty string if none — the dialog
          // resolves an empty message to a localized fallback at render time.
          onSessionExpired?.call(apiException.message);
        }
      }
    } else if (err.response?.statusCode == 403) {
      final hasAuthHeader = err.requestOptions.headers['Authorization'] != null;
      final isLogoutRequest =
          err.requestOptions.path.contains(ApiEndpoints.logout) ||
          err.requestOptions.path.contains(ApiEndpoints.logoutDevices);
      final authenticated = isAuthenticated?.call() ?? true;

      if (hasAuthHeader &&
          !isLogoutRequest &&
          authenticated &&
          !_parallelLoginTriggered &&
          _isParallelLoginRestriction(err.response?.data)) {
        _parallelLoginTriggered = true;
        onParallelLoginRestriction?.call(
          _extractDetailMessage(err.response?.data),
        );
      }
    } else if (err.response?.statusCode == 302) {
      final location = err.response?.headers.value('location') ?? '';
      if (location.contains('/settings/force/')) {
        onEnforceStudentDataRequired?.call();
      }
    }
    super.onError(err, handler);
  }

  static bool _isParallelLoginRestriction(dynamic data) {
    if (data is Map) return data['error_code'] == 'parallel_login_restriction';
    if (data is String) return data.contains('parallel_login_restriction');
    return false;
  }

  static String _extractDetailMessage(dynamic data) {
    if (data is Map) return (data['detail'] as String?) ?? '';
    return '';
  }
}
