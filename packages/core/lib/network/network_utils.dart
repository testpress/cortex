import 'package:dio/dio.dart';

import '../data/exceptions/api_exception.dart';
export '../data/exceptions/api_exception.dart';

/// Orchestrates a network request with standardized error handling.
/// Converts [DioException] into our semantic [ApiException].
///
/// Unifies both standard object responses and dynamic/list responses under a single
/// signature using Dart's dynamic function invocation to bypass compile-time contravariance limits.
Future<T> performNetworkRequest<T>(
  Future<Response<dynamic>> request, {
  required Function fromJson,
}) async {
  try {
    final response = await request;
    final data = response.data;
    if (data == null) {
      try {
        return fromJson(<String, dynamic>{}) as T;
      } catch (_) {
        return fromJson(null) as T;
      }
    }
    return fromJson(data) as T;
  } on DioException catch (error) {
    throw ApiException.fromDioException(error);
  } catch (e) {
    throw ApiException('An unexpected error occurred: $e');
  }
}
