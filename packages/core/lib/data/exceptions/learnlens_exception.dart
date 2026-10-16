import 'api_exception.dart';

/// Normalized exception thrown by LearnLens networking and session management.
///
/// Extends [ApiException] for unified error handling across Cortex while
/// preserving domain-specific quota limits and machine-readable error codes.
class LearnLensException extends ApiException {
  final String? code;
  final int? limit;
  final DateTime? retryAt;
  final Object? originalError;

  const LearnLensException({
    required String message,
    this.code,
    int? statusCode,
    this.limit,
    this.retryAt,
    this.originalError,
    ApiErrorType type = ApiErrorType.unknown,
  }) : super(message, statusCode: statusCode, type: type, error: originalError);

  bool get isCancelled =>
      code == 'cancelled' ||
      (originalError != null &&
          originalError.toString().toLowerCase().contains('cancel'));

  bool get isQuotaOrRateLimit =>
      statusCode == 429 ||
      type == ApiErrorType.rateLimited ||
      retryAt != null ||
      (code != null &&
          (code!.contains('quota') ||
              code!.contains('limit') ||
              code == 'too_many_requests'));

  @override
  String toString() =>
      'LearnLensException(statusCode: $statusCode, code: $code, message: $message)';
}
