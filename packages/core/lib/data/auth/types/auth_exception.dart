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
    String message = "We couldn't connect. Please check your internet and try again.",
  }) =>
      AuthException(message, type: AuthErrorType.network);

  factory AuthException.invalidCredentials({
    String message = 'The username or password you entered is incorrect.',
  }) =>
      AuthException(message, type: AuthErrorType.invalidCredentials, statusCode: 401);

  factory AuthException.unauthorized({
    String message = "It looks like you don't have access to this feature.",
  }) =>
      AuthException(message, type: AuthErrorType.unauthorized, statusCode: 403);

  factory AuthException.validation({
    String message = 'Something looks wrong with the info you provided. Please check and try again.',
    int? statusCode,
  }) =>
      AuthException(
        message,
        type: AuthErrorType.validation,
        statusCode: statusCode,
      );

  factory AuthException.malformedResponse({
    String message = 'We are having trouble communicating with our servers. Please try again later.',
  }) =>
      AuthException(message, type: AuthErrorType.malformedResponse);

  factory AuthException.unknown({
    String message = 'Oops! Something went wrong on our end. Please try again in a moment.',
    int? statusCode,
  }) =>
      AuthException(message, type: AuthErrorType.unknown, statusCode: statusCode);

  factory AuthException.fromDio(DioException error) {
    if (_isNetworkError(error)) {
      return AuthException.network();
    }

    final statusCode = error.response?.statusCode;
    final backendMessage = _extractApiMessage(error.response?.data);

    // Only use backend messages for status 400 (Bad Request)
    if (statusCode == 400) {
      return AuthException.validation(
        message: backendMessage ?? 'Something looks wrong with the info you provided.',
        statusCode: statusCode,
      );
    }

    // Specific handler for Throttling
    if (statusCode == 429) {
      return AuthException.unknown(
        message: 'Please take a short break and try again in a moment.',
        statusCode: statusCode,
      );
    }

    // For all other codes, use the user-friendly factory defaults
    if (statusCode == 401) {
      return AuthException.invalidCredentials();
    }
    if (statusCode == 403) {
      return AuthException.unauthorized();
    }
    if (statusCode == 422) {
      return AuthException.validation(statusCode: statusCode);
    }

    return AuthException.unknown(statusCode: statusCode);
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
