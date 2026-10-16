import 'package:core/data/exceptions/api_exception.dart';
import 'package:core/network/learnlens_network_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LearnLensException', () {
    test('extends ApiException with proper properties', () {
      final now = DateTime.now().toUtc();
      final exception = LearnLensException(
        message: 'Rate limit exceeded',
        code: 'hourly_message_limit',
        statusCode: 429,
        limit: 20,
        retryAt: now,
        type: ApiErrorType.rateLimited,
      );

      expect(exception, isA<ApiException>());
      expect(exception.message, 'Rate limit exceeded');
      expect(exception.code, 'hourly_message_limit');
      expect(exception.statusCode, 429);
      expect(exception.limit, 20);
      expect(exception.retryAt, now);
      expect(exception.type, ApiErrorType.rateLimited);
      expect(exception.isCancelled, isFalse);
      expect(
        exception.toString(),
        contains(
          'LearnLensException(statusCode: 429, code: hourly_message_limit',
        ),
      );
    });

    test('isCancelled is true when code is cancelled', () {
      const exception = LearnLensException(
        message: 'Request cancelled',
        code: 'cancelled',
      );
      expect(exception.isCancelled, isTrue);
    });

    test('isCancelled is true when originalError is a cancel exception', () {
      final dioCancel = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.cancel,
        error: 'User cancelled request',
      );
      final exception = LearnLensException(
        message: 'Cancelled',
        originalError: dioCancel,
      );
      expect(exception.isCancelled, isTrue);
    });

    test(
      'isQuotaOrRateLimit returns true only for quota/rate limit errors',
      () {
        expect(
          const LearnLensException(
            message: 'Too many requests',
            statusCode: 429,
          ).isQuotaOrRateLimit,
          isTrue,
        );
        expect(
          const LearnLensException(
            message: 'Rate limit',
            type: ApiErrorType.rateLimited,
          ).isQuotaOrRateLimit,
          isTrue,
        );
        expect(
          LearnLensException(
            message: 'Quota exceeded',
            retryAt: DateTime.now(),
          ).isQuotaOrRateLimit,
          isTrue,
        );
        expect(
          const LearnLensException(
            message: 'Quota reached',
            code: 'hourly_message_limit',
          ).isQuotaOrRateLimit,
          isTrue,
        );

        // Non-quota errors return false
        expect(
          const LearnLensException(
            message: 'Invalid session token',
            code: 'session_missing_or_expired',
            statusCode: 401,
          ).isQuotaOrRateLimit,
          isFalse,
        );
        expect(
          const LearnLensException(
            message: 'Internal error',
            statusCode: 500,
          ).isQuotaOrRateLimit,
          isFalse,
        );
      },
    );
  });

  group('LearnLensNetworkClient.parseDioException', () {
    test('maps DioExceptionType.cancel to cancelled LearnLensException', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.cancel,
      );

      final exception = LearnLensNetworkClient.parseDioException(dioException);

      expect(exception.code, 'cancelled');
      expect(exception.message, 'Request cancelled');
      expect(exception.isCancelled, isTrue);
    });

    test('maps 429 quota error to rateLimited LearnLensException', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 429,
          data: {
            'detail': {
              'code': 'hourly_message_limit',
              'message': 'Rate limited for the hour',
              'limit': 15,
              'retry_at': '2026-10-12T13:00:00Z',
            },
          },
        ),
      );

      final exception = LearnLensNetworkClient.parseDioException(dioException);

      expect(exception.statusCode, 429);
      expect(exception.code, 'hourly_message_limit');
      expect(exception.message, 'Rate limited for the hour');
      expect(exception.limit, 15);
      expect(exception.retryAt, isNotNull);
      expect(exception.type, ApiErrorType.rateLimited);
    });

    test(
      'maps generic Dio error without detail to fallback LearnLensException',
      () {
        final dioException = DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.badResponse,
          message: 'Internal server error',
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 500,
            data: 'Server crashed',
          ),
        );

        final exception = LearnLensNetworkClient.parseDioException(
          dioException,
        );

        expect(exception.statusCode, 500);
        expect(exception.message, 'Internal server error');
        expect(exception.code, isNull);
      },
    );

    test(
      'maps 401 with Session expired detail to serverError and sanitizes message',
      () {
        final dioException = DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 401,
            data: {'detail': 'Session expired.'},
          ),
        );

        final exception = LearnLensNetworkClient.parseDioException(
          dioException,
        );

        expect(exception.statusCode, 401);
        expect(exception.type, ApiErrorType.unknown);
        expect(
          exception.message,
          'Unable to connect to AI assistant. Please try again.',
        );
      },
    );
  });
}
