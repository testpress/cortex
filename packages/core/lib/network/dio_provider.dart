import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
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
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (!kIsWeb) {
      final securityContext = SecurityContext(withTrustedRoots: true);
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          return HttpClient(context: securityContext);
        },
      );
    }

    dio.interceptors.add(UserAgentInterceptor());
    dio.interceptors.add(
      AuthInterceptor(getToken: getToken, onSessionExpired: onSessionExpired),
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
    onSessionExpired: (msg) =>
        ref.read(sessionExpiredProvider.notifier).state = msg,
  );
});
