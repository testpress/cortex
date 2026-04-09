import 'package:dio/dio.dart';

import '../data/exceptions/api_exception.dart';

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
