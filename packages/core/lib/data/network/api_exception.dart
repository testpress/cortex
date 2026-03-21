import 'dart:io';

import 'package:dio/dio.dart';

/// Central exception for all Testpress API related errors.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;

  ApiException({
    required this.message,
    this.statusCode,
    this.error,
  });

  factory ApiException.fromDioException(DioException dioException) {
    String message;
    int? statusCode = dioException.response?.statusCode;

    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timed out. Please check your internet.';
        break;
      case DioExceptionType.badResponse:
        message = _handleStatusCode(statusCode);
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection.';
        break;
      default:
        message = 'Unexpected error occurred.';
        break;
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      error: dioException.error,
    );
  }

  static String _handleStatusCode(int? statusCode) {
    if (statusCode == null) return 'Something went wrong.';

    switch (statusCode) {
      case HttpStatus.badRequest:
        return 'Bad request.';
      case HttpStatus.unauthorized:
        return 'Unauthorized access.';
      case HttpStatus.forbidden:
        return 'Access forbidden.';
      case HttpStatus.notFound:
        return 'Resource not found.';
      case HttpStatus.internalServerError:
        return 'Internal server error.';
      default:
        return 'Something went wrong (Status: $statusCode).';
    }
  }

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
