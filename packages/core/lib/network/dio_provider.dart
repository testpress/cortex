import 'package:dio/dio.dart';

import '../data/config/app_config.dart';

class NetworkProvider {
  NetworkProvider._();

  static Dio create({String? baseUrl, Map<String, Object?>? headers}) {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl ?? AppConfig.apiBaseUrl,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          ...?headers,
        },
      ),
    );
  }
}
