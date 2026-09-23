import 'package:core/data/services/sentry_service.dart';
import 'package:core/network/network_utils.dart';
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
  }) async {
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

    test('captures ApiException with serialized api_details context', () {
      const exception = ApiException(
        'Bad request',
        type: ApiErrorType.badRequest,
        statusCode: 400,
        data: {'message': 'Invalid credentials'},
        error: 'underlying dio error',
      );

      onNetworkErrorCapture?.call(exception, StackTrace.empty);

      expect(sentryService.captured.length, 1);
      final captured = sentryService.captured.first;
      expect(captured.exception, exception);

      final apiDetails =
          captured.contexts?['api_details'] as Map<String, dynamic>?;
      expect(apiDetails, isNotNull);
      expect(apiDetails?['error_type'], 'badRequest');
      expect(apiDetails?['status_code'], 400);
      expect(apiDetails?['underlying_error'], 'underlying dio error');
      expect(apiDetails?['response_data'], '{"message":"Invalid credentials"}');
    });

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
