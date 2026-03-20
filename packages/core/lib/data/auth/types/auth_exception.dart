import 'package:dio/dio.dart';

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  factory AuthException.fromDio(DioException error) {
    final data = error.response?.data;
    String? message = _getErrorMessageFromResponse(data);

    if (message == null || message.trim().isEmpty) {
      message = switch (error.type) {
        DioExceptionType.connectionError => 'Please check your internet connection and try again',
        DioExceptionType.connectionTimeout => 'The server is taking too long to respond. Please try again',
        DioExceptionType.sendTimeout => 'Unable to send your request. Please check your connection',
        DioExceptionType.receiveTimeout => 'The server took too long to respond. Please try again later',
        _ => 'Something went wrong. Please try again',
      };
    }

    return AuthException(message);
  }

  static String? _getErrorMessageFromResponse(dynamic data) {
    if (data == null) return null;

    if (data is String && data.trim().isNotEmpty) {
      return data;
    }

    if (data is Map<String, dynamic>) {
      final direct = data['message'] ?? data['error'] ?? data['detail'];
      if (direct is String && direct.trim().isNotEmpty) {
        return direct;
      }

      final errors = data['errors'];
      if (errors is List && errors.isNotEmpty) {
        final first = errors.first;
        if (first is String && first.trim().isNotEmpty) {
          return first;
        }
        if (first is Map<String, dynamic>) {
          final nested = first['message'] ?? first['error'] ?? first['detail'];
          if (nested is String && nested.trim().isNotEmpty) {
            return nested;
          }
        }
      }
    }

    return null;
  }

  @override
  String toString() => 'AuthException($message)';
}
