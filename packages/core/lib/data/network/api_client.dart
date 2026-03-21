import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../auth/auth_interceptor.dart';
import '../auth/auth_local_data_source.dart';
import 'api_exception.dart';

/// Centralized API Client for Testpress LMS communication.
/// Handles headers, interceptors, and error translation.
class ApiClient {
  final Dio _dio;

  ApiClient({
    required AuthLocalDataSource authLocalDataSource,
    Dio? dio,
  }) : _dio = dio ?? _createDio(authLocalDataSource);

  static Dio _createDio(AuthLocalDataSource authLocalDataSource) {
    final dio = Dio(BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Dynamic JWT injection from secure storage
    dio.interceptors.add(AuthInterceptor(localDataSource: authLocalDataSource));

    // Log interceptor for debugging in dev mode
    dio.interceptors.add(LogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
    ));

    return dio;
  }

  /// Perform a GET request with error handling.
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw ApiException(message: 'Unexpected error: ${e.toString()}', error: e);
    }
  }

  /// Perform a POST request with error handling.
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(path,
          data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw ApiException(message: 'Unexpected error: ${e.toString()}', error: e);
    }
  }

  // Add more methods (put, delete, etc.) as needed.
}
