import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data.dart';

/// Provider for a pre-configured [Dio] instance.
/// This is the backbone of the network layer, shared by all domain clients.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // Attach global interceptors
  dio.interceptors.addAll([
    AuthInterceptor(),
    LoggingInterceptor(),
  ]);

  return dio;
});
