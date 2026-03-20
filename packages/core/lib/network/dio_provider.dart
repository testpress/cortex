import 'package:dio/dio.dart';

import '../data/config/app_config.dart';
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
}
