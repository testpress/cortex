import 'package:dio/dio.dart';

/// No-op interceptor retained intentionally.
///
/// Rationale:
/// - keeps interceptor wiring stable across environments/branches
/// - allows toggling request logging in one place without touching dio setup
/// - avoids churn in provider tests that assume this interceptor is present
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
