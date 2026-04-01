import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/config/app_config.dart';
import '../data/auth/auth_provider.dart';
import '../data/exceptions/api_exception.dart';
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
      getToken: () => ref.read(authRepositoryProvider).getToken(),
      onUnauthorized: () => ref.read(authProvider.notifier).logout(),
    ),
  );
  return dio;
});


/// Orchestrates a network request with standardized error handling.
/// Converts [DioException] into our semantic [ApiException].
Future<T> performNetworkRequest<T>(
  Future<Response<Map<String, dynamic>>> request, {
  required T Function(Map<String, dynamic>) fromJson,
}) async {
  try {
    final response = await request;
    return fromJson(response.data ?? {});
  } on DioException catch (error) {
    throw ApiException.fromDioException(error);
  } catch (e) {
    throw ApiException('An unexpected error occurred: $e');
  }
}
