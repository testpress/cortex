import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/config/app_config.dart';
import '../data/auth/auth_provider.dart';
import 'user_agent_interceptor.dart';
import 'auth_interceptor.dart';

class DioFactory {
  static Dio createBackgroundDio({
    required Future<String?> Function() getToken,
    void Function(String message)? onSessionExpired,
    void Function()? onEnforceStudentDataRequired,
    void Function(String message)? onParallelLoginRestriction,
    bool Function()? isLoggingOut,
    bool Function()? isAuthenticated,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        // Use Dio's default platform HTTP client and keep redirects disabled
        // globally. API redirects must be handled explicitly per endpoint.
        followRedirects: false,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(UserAgentInterceptor());
    dio.interceptors.add(
      AuthInterceptor(
        getToken: getToken,
        onSessionExpired: onSessionExpired,
        onEnforceStudentDataRequired: onEnforceStudentDataRequired,
        onParallelLoginRestriction: onParallelLoginRestriction,
        isLoggingOut: isLoggingOut,
        isAuthenticated: isAuthenticated,
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        // requestBody is false to avoid logging plaintext credentials (e.g. passwords during login).
        LogInterceptor(responseBody: true, requestBody: false),
      );
    }

    return dio;
  }
}

/// Provider that manages the app-wide singleton Dio instance.
/// It includes the default UserAgentInterceptor and is intended to be
/// the primary consumer of network requests.
final Provider<Dio> dioProvider = Provider<Dio>((ref) {
  return DioFactory.createBackgroundDio(
    getToken: () => ref.read(authLocalDataSourceProvider).getToken(),
    isLoggingOut: () => ref.read(isLoggingOutProvider),
    isAuthenticated: () => ref.read(authProvider).asData?.value != false,
    onSessionExpired: (msg) =>
        ref.read(sessionExpiredProvider.notifier).state = msg,
    onEnforceStudentDataRequired: () =>
        ref.read(enforceStudentDataRequiredProvider.notifier).state = true,
    onParallelLoginRestriction: (msg) =>
        ref.read(parallelLoginRequiredProvider.notifier).state = msg,
  );
});
