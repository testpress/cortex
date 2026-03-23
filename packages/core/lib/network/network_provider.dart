import 'package:dio/dio.dart';

import '../data/config/app_config.dart';
import '../data/exceptions/api_exception.dart';
import 'user_agent_interceptor.dart';

class NetworkProvider {
  NetworkProvider._();

  static Dio create({String? baseUrl, Map<String, Object?>? headers}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? AppConfig.apiBaseUrl,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          ...?headers,
        },
      ),
    );

    dio.interceptors.add(UserAgentInterceptor());

    return dio;
  }

  /// Orchestrates a network request with standardized error handling.
  /// Converts [DioException] into our semantic [ApiException].
  static Future<T> perform<T>(
    Future<Response<Map<String, dynamic>>> request, {
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await request;
      return fromJson(response.data ?? {});
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    } catch (e) {
      throw ApiException('An unexpected error occurred: $e');
    }
  }
}
