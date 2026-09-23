import 'package:flutter_test/flutter_test.dart';
import 'package:core/network/network_utils.dart';
import 'package:dio/dio.dart';

void main() {
  setUp(() {
    onNetworkErrorCapture = null;
  });

  tearDown(() {
    onNetworkErrorCapture = null;
  });

  group('performNetworkRequest', () {
    test('returns parsed model on successful response', () async {
      final request = Future.value(
        Response<dynamic>(
          requestOptions: RequestOptions(path: '/test'),
          data: {'name': 'Test User'},
          statusCode: 200,
        ),
      );

      final result = await performNetworkRequest<Map<String, dynamic>>(
        request,
        fromJson: (json) => json as Map<String, dynamic>,
      );

      expect(result['name'], 'Test User');
    });

    test(
      'invokes onNetworkErrorCapture with ApiException when DioException occurs',
      () async {
        Object? capturedError;
        StackTrace? capturedStackTrace;

        onNetworkErrorCapture = (error, stackTrace) {
          capturedError = error;
          capturedStackTrace = stackTrace;
        };

        final request = Future<Response<dynamic>>.error(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.connectionError,
          ),
        );

        await expectLater(
          () =>
              performNetworkRequest<dynamic>(request, fromJson: (json) => json),
          throwsA(
            isA<ApiException>().having(
              (e) => e.type,
              'type',
              ApiErrorType.noInternet,
            ),
          ),
        );

        expect(capturedError, isA<ApiException>());
        final apiException = capturedError as ApiException;
        expect(apiException.type, ApiErrorType.noInternet);
        expect(capturedStackTrace, isNotNull);
      },
    );

    test(
      'invokes onNetworkErrorCapture with ApiException on unexpected error',
      () async {
        Object? capturedError;

        onNetworkErrorCapture = (error, stackTrace) {
          capturedError = error;
        };

        final underlyingError = const FormatException('Corrupted JSON');
        final request = Future<Response<dynamic>>.error(underlyingError);

        await expectLater(
          () =>
              performNetworkRequest<dynamic>(request, fromJson: (json) => json),
          throwsA(
            isA<ApiException>()
                .having((e) => e.type, 'type', ApiErrorType.unknown)
                .having((e) => e.error, 'error', underlyingError),
          ),
        );

        expect(capturedError, isA<ApiException>());
        final apiException = capturedError as ApiException;
        expect(apiException.error, underlyingError);
        expect(apiException.message, contains('Corrupted JSON'));
      },
    );

    test(
      'noInternet ApiException can be filtered out by network error listener',
      () async {
        final capturedErrors = <Object>[];

        onNetworkErrorCapture = (error, stackTrace) {
          if (error is ApiException && error.type == ApiErrorType.noInternet) {
            return;
          }
          capturedErrors.add(error);
        };

        // 1. Connection error (noInternet) -> should be filtered out
        final offlineRequest = Future<Response<dynamic>>.error(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.connectionError,
          ),
        );

        await expectLater(
          () => performNetworkRequest<dynamic>(
            offlineRequest,
            fromJson: (json) => json,
          ),
          throwsA(isA<ApiException>()),
        );

        expect(capturedErrors, isEmpty);

        // 2. Server error (500) -> should be captured
        final serverErrorRequest = Future<Response<dynamic>>.error(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: '/test'),
              statusCode: 500,
            ),
          ),
        );

        await expectLater(
          () => performNetworkRequest<dynamic>(
            serverErrorRequest,
            fromJson: (json) => json,
          ),
          throwsA(isA<ApiException>()),
        );

        expect(capturedErrors.length, 1);
        expect(
          (capturedErrors.first as ApiException).type,
          ApiErrorType.serverError,
        );
      },
    );
  });
}
