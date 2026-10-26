import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/network/network_utils.dart';
import 'package:core/data/sources/http_data_source.dart';

class _MockHttpClientAdapter implements HttpClientAdapter {
  final Future<ResponseBody> Function(RequestOptions options) handler;

  _MockHttpClientAdapter(this.handler);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('HttpDataSource.getVideoAttemptId', () {
    late Dio dio;
    late List<Map<String, dynamic>> recordedRequests;

    setUp(() {
      recordedRequests = [];
      dio = Dio(BaseOptions(baseUrl: 'https://testpress.example'));
    });

    tearDown(() {
      onNetworkErrorCapture = null;
    });

    test(
      'extracts video attempt ID from attempt["video"]["id"] on GET',
      () async {
        dio.httpClientAdapter = _MockHttpClientAdapter((options) async {
          recordedRequests.add({
            'method': options.method,
            'path': options.path,
          });

          if (options.method == 'GET' &&
              options.path.contains('/api/v2.3/contents/100/attempts/')) {
            return ResponseBody.fromString(
              jsonEncode({
                'results': [
                  {
                    'id': 999,
                    'video': {'id': 1234, 'last_position': '10.5'},
                  },
                ],
              }),
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }
          throw DioException(
            requestOptions: options,
            error: 'Unexpected request: ${options.method} ${options.path}',
          );
        });

        final dataSource = HttpDataSource(dio: dio);
        final result = await dataSource.getVideoAttemptId(100);

        expect(result, 1234);
        expect(recordedRequests.length, 1);
        expect(recordedRequests.first['method'], 'GET');
      },
    );

    test(
      'extracts video attempt ID from attempt["object_id"] as fallback on GET',
      () async {
        dio.httpClientAdapter = _MockHttpClientAdapter((options) async {
          recordedRequests.add({
            'method': options.method,
            'path': options.path,
          });

          if (options.method == 'GET' &&
              options.path.contains('/api/v2.3/contents/100/attempts/')) {
            return ResponseBody.fromString(
              jsonEncode({
                'results': [
                  {'id': 999, 'object_id': 5678},
                ],
              }),
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }
          throw DioException(
            requestOptions: options,
            error: 'Unexpected request: ${options.method} ${options.path}',
          );
        });

        final dataSource = HttpDataSource(dio: dio);
        final result = await dataSource.getVideoAttemptId(100);

        expect(result, 5678);
        expect(recordedRequests.length, 1);
        expect(recordedRequests.first['method'], 'GET');
      },
    );

    test(
      'throws FormatException and does NOT fall through to POST when results is non-empty but parsing fails',
      () async {
        dio.httpClientAdapter = _MockHttpClientAdapter((options) async {
          recordedRequests.add({
            'method': options.method,
            'path': options.path,
          });

          if (options.method == 'GET' &&
              options.path.contains('/api/v2.3/contents/100/attempts/')) {
            return ResponseBody.fromString(
              jsonEncode({
                'results': [
                  // Malformed attempt missing both video.id and object_id
                  {'id': 'not-an-attempt-id', 'video': null},
                ],
              }),
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }
          if (options.method == 'POST') {
            fail('POST should NOT be called when results is non-empty');
          }
          throw DioException(
            requestOptions: options,
            error: 'Unexpected request',
          );
        });

        final dataSource = HttpDataSource(dio: dio);
        await expectLater(
          () => dataSource.getVideoAttemptId(100),
          throwsA(isA<FormatException>()),
        );

        expect(recordedRequests.length, 1);
        expect(recordedRequests.first['method'], 'GET');
      },
    );

    test(
      'throws FormatException when GET response is not a valid results map',
      () async {
        dio.httpClientAdapter = _MockHttpClientAdapter((options) async {
          recordedRequests.add({
            'method': options.method,
            'path': options.path,
          });

          return ResponseBody.fromString(
            jsonEncode(['unexpected', 'list', 'format']),
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });

        final dataSource = HttpDataSource(dio: dio);
        await expectLater(
          () => dataSource.getVideoAttemptId(100),
          throwsA(isA<FormatException>()),
        );
      },
    );

    test(
      'calls POST only when results is empty to initialize initial attempt',
      () async {
        dio.httpClientAdapter = _MockHttpClientAdapter((options) async {
          recordedRequests.add({
            'method': options.method,
            'path': options.path,
          });

          if (options.method == 'GET' &&
              options.path.contains('/api/v2.3/contents/100/attempts/')) {
            return ResponseBody.fromString(
              jsonEncode({'results': []}),
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }

          if (options.method == 'POST' &&
              options.path.contains('/api/v2.3/contents/100/attempts/')) {
            return ResponseBody.fromString(
              jsonEncode({
                'id': 888,
                'video': {'id': 7890},
              }),
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }

          throw DioException(
            requestOptions: options,
            error: 'Unexpected request: ${options.method} ${options.path}',
          );
        });

        final dataSource = HttpDataSource(dio: dio);
        final result = await dataSource.getVideoAttemptId(100);

        expect(result, 7890);
        expect(recordedRequests.length, 2);
        expect(recordedRequests[0]['method'], 'GET');
        expect(recordedRequests[1]['method'], 'POST');
      },
    );

    test(
      'throws ApiException and captures error on POST response if video and object_id are missing',
      () async {
        Object? capturedError;
        onNetworkErrorCapture = (error, stackTrace) {
          capturedError = error;
        };

        dio.httpClientAdapter = _MockHttpClientAdapter((options) async {
          recordedRequests.add({
            'method': options.method,
            'path': options.path,
          });

          if (options.method == 'GET') {
            return ResponseBody.fromString(
              jsonEncode({'results': []}),
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }

          if (options.method == 'POST') {
            return ResponseBody.fromString(
              jsonEncode({
                'id':
                    9999, // ContentAttempt.id, should NOT be treated as user_video ID
              }),
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }

          throw DioException(requestOptions: options);
        });

        final dataSource = HttpDataSource(dio: dio);
        await expectLater(
          () => dataSource.getVideoAttemptId(100),
          throwsA(isA<ApiException>()),
        );

        expect(capturedError, isA<ApiException>());
      },
    );

    test(
      'propagates network exceptions to caller instead of returning null',
      () async {
        dio.httpClientAdapter = _MockHttpClientAdapter((options) async {
          throw DioException(
            requestOptions: options,
            type: DioExceptionType.connectionTimeout,
            error: 'Connection timeout',
          );
        });

        final dataSource = HttpDataSource(dio: dio);
        expect(
          () => dataSource.getVideoAttemptId(100),
          throwsA(isA<ApiException>()),
        );
      },
    );
  });
}
