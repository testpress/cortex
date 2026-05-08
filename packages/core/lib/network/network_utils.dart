import 'package:dio/dio.dart';

import '../data/exceptions/api_exception.dart';
export '../data/exceptions/api_exception.dart';

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

/// Variant of [performNetworkRequest] that handles any response type (e.g. List).
Future<T> performDynamicNetworkRequest<T>(
  Future<Response<dynamic>> request, {
  required T Function(dynamic) fromJson,
}) async {
  try {
    final response = await request;
    return fromJson(response.data);
  } on DioException catch (error) {
    throw ApiException.fromDioException(error);
  } catch (e) {
    throw ApiException('An unexpected error occurred: $e');
  }
}
