import 'package:dio/dio.dart';
import 'auth_local_data_source.dart';

/// Interceptor that adds a JWT token to all requests if one is available.
class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource _localDataSource;

  AuthInterceptor({required AuthLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _localDataSource.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'JWT $token';
    }

    return handler.next(options);
  }
}
