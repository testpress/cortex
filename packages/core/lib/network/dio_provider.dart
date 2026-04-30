import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/config/app_config.dart';
import '../data/auth/auth_provider.dart';
import 'user_agent_interceptor.dart';
import 'auth_interceptor.dart';


/// Provider that manages the app-wide singleton Dio instance.
/// It includes the default UserAgentInterceptor and is intended to be
/// the primary consumer of network requests.
final Provider<Dio> dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );
  
  dio.interceptors.add(UserAgentInterceptor());
  dio.interceptors.add(
    AuthInterceptor(
      getToken: () => ref.read(authLocalDataSourceProvider).getToken(),
      onUnauthorized: () => ref.read(authProvider.notifier).logout(),
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  return dio;
});

