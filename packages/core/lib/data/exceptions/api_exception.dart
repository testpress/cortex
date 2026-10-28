import 'dart:convert';
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

  /// 302 Redirect to /settings/force/
  enforceStudentData,

  /// 5xx Server errors
  serverError,

  /// Response parsing / invalid JSON
  malformedResponse,

  /// Fallback
  unknown,
}

class DioDiagnostics {
  final String dioType;
  final String requestUri;
  final String? redirectLocation;
  final String? underlyingErrorType;
  final String? dioMessage;
  final bool followRedirects;
  final int maxRedirects;
  final String responseType;
  final int? connectTimeoutMs;
  final int? sendTimeoutMs;
  final int? receiveTimeoutMs;
  final List<String> requestHeaderNames;
  final List<String> responseHeaderNames;

  const DioDiagnostics({
    required this.dioType,
    required this.requestUri,
    this.redirectLocation,
    this.underlyingErrorType,
    this.dioMessage,
    required this.followRedirects,
    required this.maxRedirects,
    required this.responseType,
    this.connectTimeoutMs,
    this.sendTimeoutMs,
    this.receiveTimeoutMs,
    required this.requestHeaderNames,
    required this.responseHeaderNames,
  });

  factory DioDiagnostics.fromDioException(DioException error) {
    return DioDiagnostics(
      dioType: error.type.name,
      requestUri: _uriWithoutQuery(error.requestOptions.uri),
      redirectLocation: _locationWithoutQuery(
        error.response?.headers.value('location'),
      ),
      underlyingErrorType: error.error?.runtimeType.toString(),
      dioMessage: error.message,
      followRedirects: error.requestOptions.followRedirects,
      maxRedirects: error.requestOptions.maxRedirects,
      responseType: error.requestOptions.responseType.name,
      connectTimeoutMs: error.requestOptions.connectTimeout?.inMilliseconds,
      sendTimeoutMs: error.requestOptions.sendTimeout?.inMilliseconds,
      receiveTimeoutMs: error.requestOptions.receiveTimeout?.inMilliseconds,
      requestHeaderNames: error.requestOptions.headers.keys.toList(),
      responseHeaderNames:
          error.response?.headers.map.keys.toList() ?? const [],
    );
  }

  static String _uriWithoutQuery(Uri uri) {
    return Uri(
      scheme: uri.scheme.isEmpty ? null : uri.scheme,
      host: uri.host.isEmpty ? null : uri.host,
      port: uri.hasPort ? uri.port : null,
      path: uri.path,
    ).toString();
  }

  static String? _locationWithoutQuery(String? location) {
    if (location == null || location.isEmpty) return null;
    final uri = Uri.tryParse(location);
    if (uri == null) return location.split('?').first.split('#').first;
    return _uriWithoutQuery(uri);
  }
}

/// Base class for all API-related exceptions in the application.
class ApiException implements Exception {
  final String message;
  final ApiErrorType type;
  final int? statusCode;
  final dynamic data;
  final dynamic error;
  final DioDiagnostics? dioDiagnostics;

  const ApiException(
    this.message, {
    this.type = ApiErrorType.unknown,
    this.statusCode,
    this.data,
    this.error,
    this.dioDiagnostics,
  });

  /// Whether this exception represents an HTTP 4xx client-side error.
  bool get isClientError =>
      (statusCode != null && statusCode! >= 400 && statusCode! < 500) ||
      type == ApiErrorType.badRequest ||
      type == ApiErrorType.unauthorized ||
      type == ApiErrorType.forbidden ||
      type == ApiErrorType.notFound ||
      type == ApiErrorType.rateLimited;

  factory ApiException.fromDioException(DioException error) {
    final diagnostics = DioDiagnostics.fromDioException(error);
    ApiException withDiagnostics(ApiException exception) => ApiException(
      exception.message,
      type: exception.type,
      statusCode: exception.statusCode,
      data: exception.data,
      error: exception.error,
      dioDiagnostics: diagnostics,
    );

    if (error.type == DioExceptionType.connectionError) {
      return withDiagnostics(
        ApiException(
          'We couldn\'t connect. Please check your internet and try again.',
          type: ApiErrorType.noInternet,
          error: error.error,
        ),
      );
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return withDiagnostics(
        ApiException(
          'The request timed out. Please try again.',
          type: ApiErrorType.timeout,
          error: error.error,
        ),
      );
    }

    if (error.type == DioExceptionType.badResponse) {
      final statusCode = error.response?.statusCode;
      final data = error.response?.data;
      final backendMessage = extractApiMessage(data);

      if (statusCode == 302) {
        final location = error.response?.headers.value('location') ?? '';
        if (location.contains('/settings/force/')) {
          return withDiagnostics(
            ApiException(
              'Student profile update is required.',
              type: ApiErrorType.enforceStudentData,
              statusCode: statusCode,
              data: data,
              error: error.error,
            ),
          );
        }
      }

      if (statusCode == 400 || statusCode == 422) {
        return withDiagnostics(
          ApiException(
            backendMessage ??
                'Something looks wrong with the info you provided.',
            type: ApiErrorType.badRequest,
            statusCode: statusCode,
            data: data,
            error: error.error,
          ),
        );
      }

      if (statusCode == 401) {
        return withDiagnostics(
          ApiException(
            // Pass the backend message as-is, or empty string if none.
            // An empty message signals SessionExpiredDialog to show the
            // localized sessionExpiredFallbackMessage in the user's locale.
            backendMessage ?? '',
            type: ApiErrorType.unauthorized,
            statusCode: statusCode,
            data: data,
            error: error.error,
          ),
        );
      }

      if (statusCode == 403) {
        return withDiagnostics(
          ApiException(
            backendMessage ??
                'It looks like you don\'t have access to this feature.',
            type: ApiErrorType.forbidden,
            statusCode: statusCode,
            data: data,
            error: error.error,
          ),
        );
      }

      if (statusCode == 404) {
        return withDiagnostics(
          ApiException(
            'The requested resource was not found.',
            type: ApiErrorType.notFound,
            statusCode: statusCode,
            data: data,
            error: error.error,
          ),
        );
      }

      if (statusCode == 429) {
        return withDiagnostics(
          ApiException(
            'Please take a short break and try again in a moment.',
            type: ApiErrorType.rateLimited,
            statusCode: statusCode,
            data: data,
            error: error.error,
          ),
        );
      }

      if (statusCode != null && statusCode >= 500) {
        return withDiagnostics(
          ApiException(
            'The server is having trouble. Please try again later.',
            type: ApiErrorType.serverError,
            statusCode: statusCode,
            data: data,
            error: error.error,
          ),
        );
      }

      return withDiagnostics(
        ApiException(
          backendMessage ?? 'Oops! Something went wrong. Please try again.',
          type: ApiErrorType.unknown,
          statusCode: statusCode,
          data: data,
          error: error.error,
        ),
      );
    }

    return withDiagnostics(
      ApiException(
        'Oops! Something went wrong on our end. Please try again in a moment.',
        type: ApiErrorType.unknown,
        error: error.error,
      ),
    );
  }

  static String? extractApiMessage(dynamic responseData) {
    if (responseData == null) return null;
    if (responseData is String && responseData.trim().isNotEmpty) {
      final trimmed = responseData.trim();
      // If it's an HTML error page, never extract it as a user-facing error message
      if (trimmed.startsWith('<!') ||
          trimmed.toLowerCase().contains('<html') ||
          trimmed.toLowerCase().contains('<body')) {
        return null;
      }
      if ((trimmed.startsWith('{') && trimmed.endsWith('}')) ||
          (trimmed.startsWith('[') && trimmed.endsWith(']'))) {
        try {
          final decoded = jsonDecode(trimmed);
          final nestedMsg = extractApiMessage(decoded);
          if (nestedMsg != null && nestedMsg.isNotEmpty) {
            return nestedMsg;
          }
        } catch (_) {
          // Handle Python list string representations like "['Invalid discount code']"
          final match = RegExp(
            r"^\[['"
            r'"](.*?)'
            r"['"
            r'"]\]$',
          ).firstMatch(trimmed);
          if (match != null) {
            final inner = match.group(1)?.trim();
            if (inner != null && inner.isNotEmpty) return inner;
          }
        }
      }
      return trimmed;
    }
    if (responseData is List) {
      final messages = <String>[];
      for (final item in responseData) {
        final str = item?.toString().trim();
        if (str != null && str.isNotEmpty) {
          messages.add(str);
        }
      }
      if (messages.isNotEmpty) return messages.join('\n');
      return null;
    }
    if (responseData is! Map) return null;

    final map = responseData.cast<dynamic, dynamic>();

    final detail = map['detail'];
    if (detail is Map) {
      final msg = detail['message']?.toString().trim();
      if (msg != null && msg.isNotEmpty) return msg;
    } else if (detail is String && detail.trim().isNotEmpty) {
      return extractApiMessage(detail) ?? detail.trim();
    }

    final message = map['message']?.toString().trim();
    if (message != null && message.isNotEmpty) return message;

    final error = map['error']?.toString().trim();
    if (error != null && error.isNotEmpty) return error;

    final messages = <String>[];

    final nonFieldErrors = map['non_field_errors'];
    if (nonFieldErrors is List) {
      for (final item in nonFieldErrors) {
        final str = item?.toString().trim();
        if (str != null && str.isNotEmpty) {
          messages.add(str);
        }
      }
    }

    for (final entry in map.entries) {
      if (entry.key == 'non_field_errors') continue;

      final value = entry.value;
      if (value is List) {
        for (final item in value) {
          final str = item?.toString().trim();
          if (str != null && str.isNotEmpty) {
            messages.add(str);
          }
        }
      } else if (value is String && value.trim().isNotEmpty) {
        messages.add(value.trim());
      }
    }

    if (messages.isNotEmpty) {
      return messages.join('\n');
    }

    return null;
  }

  @override
  String toString() => message;
}
