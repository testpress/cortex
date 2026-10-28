import 'package:core/data/services/sentry_service.dart';
import 'package:core/network/network_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeSentryService extends SentryService {
  final List<CapturedError> captured = [];

  @override
  Future<void> captureException(
    dynamic exception, {
    dynamic stackTrace,
    AppErrorLevel? level,
    Map<String, String>? tags,
    Map<String, dynamic>? contexts,
    bool bypassFilter = false,
  }) async {
    if (!bypassFilter && SentryService.shouldIgnoreException(exception)) {
      return;
    }
    captured.add(
      CapturedError(
        exception: exception,
        stackTrace: stackTrace,
        level: level,
        tags: tags,
        contexts: contexts,
      ),
    );
  }
}

class CapturedError {
  final dynamic exception;
  final dynamic stackTrace;
  final AppErrorLevel? level;
  final Map<String, String>? tags;
  final Map<String, dynamic>? contexts;

  CapturedError({
    required this.exception,
    this.stackTrace,
    this.level,
    this.tags,
    this.contexts,
  });
}

void main() {
  group('SentryService.attachNetworkErrorHandler', () {
    late _FakeSentryService sentryService;

    setUp(() {
      sentryService = _FakeSentryService();
      sentryService.attachNetworkErrorHandler();
    });

    tearDown(() {
      onNetworkErrorCapture = null;
    });

    test('ignores ApiException when type is noInternet', () {
      const exception = ApiException(
        'No internet',
        type: ApiErrorType.noInternet,
      );

      onNetworkErrorCapture?.call(exception, StackTrace.empty);

      expect(sentryService.captured, isEmpty);
    });

    test(
      'ignores ApiException with 4xx client errors (400, 401, 403, 404, 422, 429)',
      () {
        const testCases = [
          ApiException(
            'Bad request',
            type: ApiErrorType.badRequest,
            statusCode: 400,
          ),
          ApiException(
            'Unauthorized',
            type: ApiErrorType.unauthorized,
            statusCode: 401,
          ),
          ApiException(
            'Forbidden',
            type: ApiErrorType.forbidden,
            statusCode: 403,
          ),
          ApiException(
            'Not found',
            type: ApiErrorType.notFound,
            statusCode: 404,
          ),
          ApiException(
            'Unprocessable',
            type: ApiErrorType.badRequest,
            statusCode: 422,
          ),
          ApiException(
            'Rate limited',
            type: ApiErrorType.rateLimited,
            statusCode: 429,
          ),
        ];

        for (final exception in testCases) {
          onNetworkErrorCapture?.call(exception, StackTrace.empty);
        }

        expect(sentryService.captured, isEmpty);
      },
    );

    test(
      'ignores ApiException when type is enforceStudentData (302) or any 302 redirect',
      () {
        const enforceException = ApiException(
          'Student profile update is required.',
          type: ApiErrorType.enforceStudentData,
          statusCode: 302,
        );
        const plain302Exception = ApiException(
          'Redirect',
          type: ApiErrorType.unknown,
          statusCode: 302,
        );

        onNetworkErrorCapture?.call(enforceException, StackTrace.empty);
        onNetworkErrorCapture?.call(plain302Exception, StackTrace.empty);

        expect(sentryService.captured, isEmpty);
      },
    );

    test(
      'ignores DioException with status < 500 (302 redirect and 400 error)',
      () {
        final dio302 = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 302,
          ),
        );
        final dio400 = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400,
          ),
        );

        onNetworkErrorCapture?.call(dio302, StackTrace.empty);
        onNetworkErrorCapture?.call(dio400, StackTrace.empty);

        expect(sentryService.captured, isEmpty);
      },
    );

    test(
      'captureException directly ignores 4xx client errors, 302 redirects, and offline errors',
      () async {
        const clientError = ApiException(
          'Not found',
          type: ApiErrorType.notFound,
          statusCode: 404,
        );
        const offlineError = ApiException(
          'Offline',
          type: ApiErrorType.noInternet,
        );
        const enforceError = ApiException(
          'Student profile update is required.',
          type: ApiErrorType.enforceStudentData,
          statusCode: 302,
        );
        const plain302 = ApiException(
          'Redirect',
          type: ApiErrorType.unknown,
          statusCode: 302,
        );

        await sentryService.captureException(clientError);
        await sentryService.captureException(offlineError);
        await sentryService.captureException(enforceError);
        await sentryService.captureException(plain302);

        expect(sentryService.captured, isEmpty);
      },
    );

    test(
      'captures server error ApiException (5xx) with serialized api_details context',
      () {
        const exception = ApiException(
          'Internal Server Error',
          type: ApiErrorType.serverError,
          statusCode: 500,
          data: {'error': 'Database failure'},
          error: 'underlying dio error',
        );

        onNetworkErrorCapture?.call(exception, StackTrace.empty);

        expect(sentryService.captured.length, 1);
        final captured = sentryService.captured.first;
        expect(captured.exception, exception);

        final apiDetails =
            captured.contexts?['api_details'] as Map<String, dynamic>?;
        expect(apiDetails, isNotNull);
        expect(apiDetails?['error_type'], 'serverError');
        expect(apiDetails?['status_code'], 500);
        expect(apiDetails?['underlying_error'], 'underlying dio error');
        expect(apiDetails?['response_data'], '{"error":"Database failure"}');
      },
    );

    test(
      'omits null keys in api_details context when status_code, response_data, or underlying_error are null',
      () {
        const exception = ApiException('Timeout', type: ApiErrorType.timeout);

        onNetworkErrorCapture?.call(exception, StackTrace.empty);

        expect(sentryService.captured.length, 1);
        final captured = sentryService.captured.first;
        final apiDetails =
            captured.contexts?['api_details'] as Map<String, dynamic>?;
        expect(apiDetails, isNotNull);
        expect(apiDetails?['error_type'], 'timeout');
        expect(apiDetails?.containsKey('status_code'), isFalse);
        expect(apiDetails?.containsKey('response_data'), isFalse);
        expect(apiDetails?.containsKey('underlying_error'), isFalse);
      },
    );

    test(
      'safely falls back to toString() when response data is non-JSON-encodable without throwing',
      () {
        final unencodableData = Object();
        final exception = ApiException(
          'Corrupted Image Download',
          type: ApiErrorType.serverError,
          statusCode: 500,
          data: unencodableData,
        );

        expect(
          () => onNetworkErrorCapture?.call(exception, StackTrace.empty),
          returnsNormally,
        );

        expect(sentryService.captured.length, 1);
        final captured = sentryService.captured.first;
        final apiDetails =
            captured.contexts?['api_details'] as Map<String, dynamic>?;
        expect(apiDetails?['response_data'], unencodableData.toString());
      },
    );

    test(
      'captures generic non-ApiException errors directly without context',
      () {
        final error = Exception('Generic error');

        onNetworkErrorCapture?.call(error, StackTrace.empty);

        expect(sentryService.captured.length, 1);
        final captured = sentryService.captured.first;
        expect(captured.exception, error);
        expect(captured.contexts, isNull);
      },
    );
  });
}
