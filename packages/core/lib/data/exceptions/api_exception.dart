import 'package:dio/dio.dart';

enum ApiErrorType {
  /// No internet connection (offline, DNS failure, etc.)
  noInternet,

  /// Request timed out (connection, send, receive)
  timeout,

  /// 400 Bad Request
  badRequest,

  /// 401 Unauthorized
  unauthorized,

  /// 403 Forbidden
  forbidden,

  /// 404 Not Found
  notFound,

  /// 429 Too Many Requests
  rateLimited,

  /// 5xx Server errors
  serverError,

  /// Response parsing / invalid JSON
  malformedResponse,

  /// Fallback
  unknown,
}

/// Base class for all API-related exceptions in the application.
class ApiException implements Exception {
  final String message;
  final ApiErrorType type;
  final int? statusCode;
  final dynamic data;
  final dynamic error;

  const ApiException(
    this.message, {
    this.type = ApiErrorType.unknown,
    this.statusCode,
    this.data,
    this.error,
  });

  factory ApiException.fromDioException(DioException error) {
    if (error.type == DioExceptionType.connectionError) {
      return ApiException(
        'We couldn\'t connect. Please check your internet and try again.',
        type: ApiErrorType.noInternet,
        error: error.error,
      );
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return ApiException(
        'The request timed out. Please try again.',
        type: ApiErrorType.timeout,
        error: error.error,
      );
    }

    if (error.type == DioExceptionType.badResponse) {
       final statusCode = error.response?.statusCode;
       final data = error.response?.data;
       final backendMessage = _extractApiMessage(data);

       if (statusCode == 400 || statusCode == 422) {
         return ApiException(
           backendMessage ?? 'Something looks wrong with the info you provided.',
           type: ApiErrorType.badRequest,
           statusCode: statusCode,
           data: data,
           error: error.error,
         );
       }

       if (statusCode == 401) {
         return ApiException(
           backendMessage ?? 'You are not authorized to perform this action.',
           type: ApiErrorType.unauthorized,
           statusCode: statusCode,
           data: data,
           error: error.error,
         );
       }

       if (statusCode == 403) {
         return ApiException(
           backendMessage ?? 'It looks like you don\'t have access to this feature.',
           type: ApiErrorType.forbidden,
           statusCode: statusCode,
           data: data,
           error: error.error,
         );
       }

       if (statusCode == 404) {
          return ApiException(
            backendMessage ?? 'The requested resource was not found.',
            type: ApiErrorType.notFound,
            statusCode: statusCode,
            data: data,
            error: error.error,
          );
       }

       if (statusCode == 429) {
          return ApiException(
            'Please take a short break and try again in a moment.',
            type: ApiErrorType.rateLimited,
            statusCode: statusCode,
            data: data,
            error: error.error,
          );
       }

       if (statusCode != null && statusCode >= 500) {
         return ApiException(
           'The server is having trouble. Please try again later.',
           type: ApiErrorType.serverError,
           statusCode: statusCode,
           data: data,
           error: error.error,
         );
       }

       return ApiException(
         backendMessage ?? 'Oops! Something went wrong. Please try again.',
         type: ApiErrorType.unknown,
         statusCode: statusCode,
         data: data,
         error: error.error,
       );
    }

    return ApiException(
      'Oops! Something went wrong on our end. Please try again in a moment.',
      type: ApiErrorType.unknown,
      error: error.error,
    );
  }

  static String? _extractApiMessage(dynamic responseData) {
    if (responseData == null) return null;
    if (responseData is String && responseData.trim().isNotEmpty) {
      return responseData.trim();
    }
    if (responseData is! Map) return null;

    final map = responseData.cast<dynamic, dynamic>();

    final detail = map['detail']?.toString().trim();
    if (detail != null && detail.isNotEmpty) return detail;

    final message = map['message']?.toString().trim();
    if (message != null && message.isNotEmpty) return message;

    final error = map['error']?.toString().trim();
    if (error != null && error.isNotEmpty) return error;

    final nonFieldErrors = map['non_field_errors'];
    if (nonFieldErrors is List && nonFieldErrors.isNotEmpty) {
      final first = nonFieldErrors.first?.toString().trim();
      if (first != null && first.isNotEmpty) return first;
    }

    for (final entry in map.entries) {
      final value = entry.value;
      if (value is List && value.isNotEmpty) {
        final first = value.first?.toString().trim();
        if (first != null && first.isNotEmpty) return first;
      }
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }

    return null;
  }

  @override
  String toString() => 'ApiException: $message (Type: $type, Status: $statusCode)';
}
