import 'package:dio/dio.dart';

import '../config/app_config.dart';
import 'session/session_storage.dart';

/// Shared HTTP client for authenticated API calls.
class NetworkClient {
  NetworkClient({Dio? dio, SessionStorage? sessionStorage})
    : _sessionStorage = sessionStorage ?? SessionStorage.instance,
      _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: AppConfig.apiBaseUrl.replaceAll(RegExp(r'/$'), ''),
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
              sendTimeout: const Duration(seconds: 15),
              responseType: ResponseType.json,
              headers: const {'content-type': 'application/json'},
            ),
          ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final header = _sessionStorage.authorizationHeader;
          if (header != null && header.isNotEmpty) {
            options.headers['Authorization'] = header;
          }
          handler.next(options);
        },
      ),
    );
  }

  final Dio _dio;
  final SessionStorage _sessionStorage;

  Dio get dio => _dio;
}
