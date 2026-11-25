import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/exceptions/api_exception.dart';
import 'package:dio/dio.dart';

void main() {
  group('ApiException', () {
    test('extractApiMessage extracts string from flat structure', () {
      final message = ApiException.extractApiMessage('Error occurred');
      expect(message, 'Error occurred');
    });

    test('extractApiMessage extracts from map', () {
      final message = ApiException.extractApiMessage({
        'message': 'Invalid token',
      });
      expect(message, 'Invalid token');
    });

    test('extractApiMessage extracts from nested detail map', () {
      final message = ApiException.extractApiMessage({
        'detail': {'message': 'Not found'},
      });
      expect(message, 'Not found');
    });

    test('extractApiMessage extracts from list of strings', () {
      final message = ApiException.extractApiMessage(['Error 1', 'Error 2']);
      expect(message, 'Error 1\nError 2');
    });

    test(
      'extractApiMessage extracts from python stringified list in detail',
      () {
        final message = ApiException.extractApiMessage({
          'detail': "['Invalid discount code']",
        });
        expect(message, 'Invalid discount code');
      },
    );

    test('fromDioException maps connectionError to noInternet', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionError,
      );
      final apiException = ApiException.fromDioException(dioException);
      expect(apiException.type, ApiErrorType.noInternet);
    });

    test('fromDioException maps 401 response to unauthorized', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 401,
          data: {'message': 'Token expired'},
        ),
      );
      final apiException = ApiException.fromDioException(dioException);
      expect(apiException.type, ApiErrorType.unauthorized);
      expect(apiException.message, 'Token expired');
    });

    test('isTechnicalErrorMessage detects Dio and HTTP debug text', () {
      expect(
        ApiException.isTechnicalErrorMessage(
          'Response has a status code of 401 at https://developer.mozilla.org/status',
        ),
        isTrue,
      );
      expect(
        ApiException.isTechnicalErrorMessage(
          'The request returned an invalid status code of 400.',
        ),
        isTrue,
      );
      expect(
        ApiException.isTechnicalErrorMessage(
          'RequestOptions.validateStatus error',
        ),
        isTrue,
      );
      expect(
        ApiException.isTechnicalErrorMessage('DioException [bad response]'),
        isTrue,
      );
      expect(
        ApiException.isTechnicalErrorMessage(
          'The status code of this attempt is closed',
        ),
        isFalse,
      );
      expect(ApiException.isTechnicalErrorMessage('Session expired.'), isFalse);
      expect(ApiException.isTechnicalErrorMessage(null), isFalse);
      expect(ApiException.isTechnicalErrorMessage('   '), isFalse);
    });

    test('sanitizeErrorMessage strips technical or empty messages', () {
      expect(
        ApiException.sanitizeErrorMessage(
          'DioException [bad response]: status code',
        ),
        isNull,
      );
      expect(ApiException.sanitizeErrorMessage(null), isNull);
      expect(ApiException.sanitizeErrorMessage('   '), isNull);
      expect(
        ApiException.sanitizeErrorMessage('  Session expired.  '),
        'Session expired.',
      );
    });
  });
}
