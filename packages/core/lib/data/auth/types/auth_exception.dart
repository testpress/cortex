import 'package:dio/dio.dart';

enum AuthErrorType {
  network,
  invalidCredentials,
  unauthorized,
  validation,
  malformedResponse,
  unknown,
}

/// Represents authentication-related errors inside the domain.
class AuthException implements Exception {
  const AuthException(
    this.message, {
    this.type = AuthErrorType.unknown,
    this.statusCode,
  });

  final String message;
  final AuthErrorType type;
  final int? statusCode;

  factory AuthException.network({
    String message = 'Network error. Please check your connection and try again.',
  }) =>
      AuthException(message, type: AuthErrorType.network);

  factory AuthException.invalidCredentials({
    String message = 'Invalid or expired credentials.',
  }) =>
      AuthException(message, type: AuthErrorType.invalidCredentials, statusCode: 401);

  factory AuthException.unauthorized({
    String message = 'You do not have permission to perform this action.',
  }) =>
      AuthException(message, type: AuthErrorType.unauthorized, statusCode: 403);

  factory AuthException.validation({
    String message = 'Request validation failed.',
    int? statusCode,
  }) =>
      AuthException(
        message,
        type: AuthErrorType.validation,
        statusCode: statusCode,
      );

  factory AuthException.malformedResponse({
    String message = 'Malformed response from server.',
  }) =>
      AuthException(message, type: AuthErrorType.malformedResponse);

  factory AuthException.unknown({
    String message = 'An unexpected error occurred. Please try again.',
    int? statusCode,
  }) =>
      AuthException(message, type: AuthErrorType.unknown, statusCode: statusCode);

  factory AuthException.fromDio(DioException error) {
    if (_isNetworkError(error)) {
      return AuthException.network();
    }

    final statusCode = error.response?.statusCode;
    final backendMessage = _extractApiMessage(error.response?.data);
    if (statusCode == 401) {
      return AuthException.invalidCredentials(
        message: backendMessage ?? 'Invalid or expired credentials.',
      );
    }
    if (statusCode == 403) {
      return AuthException.unauthorized(
        message:
            backendMessage ?? 'You do not have permission to perform this action.',
      );
    }
    if (statusCode == 400 || statusCode == 422) {
      return AuthException.validation(
        message:
            backendMessage ??
            'We could not process your request. Please check and try again.',
        statusCode: statusCode,
      );
    }

    return AuthException.unknown(
      message:
          backendMessage ??
          'Something went wrong while contacting the server. Please try again.',
      statusCode: statusCode,
    );
  }

  static bool shouldIgnoreLogoutError(DioException error) {
    final statusCode = error.response?.statusCode;
    return statusCode == 401 ||
        statusCode == 403 ||
        statusCode == 404 ||
        statusCode == 405;
  }

  static bool _isNetworkError(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError;
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
  String toString() => message;
}
