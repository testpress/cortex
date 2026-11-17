import 'dart:convert';
import 'package:core/data/exceptions/api_exception.dart';
import 'package:core/data/sources/http_data_source.dart';
import 'package:core/network/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HttpDataSource.getLiveClassDetail', () {
    late Dio dio;
    late List<Map<String, dynamic>> recordedRequests;

    setUp(() {
      recordedRequests = [];
      dio = Dio(BaseOptions(baseUrl: 'https://testpress.example'));
    });

    final validLessonJson = jsonEncode({
      'id': 96,
      'title': '1-on-1 Mentorship',
      'provider': 'zoom',
      'meeting_id': '123456789',
      'status': 'upcoming',
    });

    test('routes directly to contents endpoint by default', () async {
      dio.httpClientAdapter = _MockHttpClientAdapter((options) async {
        recordedRequests.add({'path': options.path});
        if (options.path == ApiEndpoints.liveClassDetail('96')) {
          return ResponseBody.fromString(
            validLessonJson,
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        }
        return ResponseBody.fromString('Not Found', 404);
      });

      final dataSource = HttpDataSource(dio: dio);
      final lesson = await dataSource.getLiveClassDetail('96');

      expect(lesson.title, '1-on-1 Mentorship');
      expect(recordedRequests.length, 1);
      expect(
        recordedRequests.first['path'],
        ApiEndpoints.liveClassDetail('96'),
      );
    });

    test(
      'routes directly to learning-sessions endpoint when session_type is one_on_one in cache',
      () async {
        final listResponseJson = jsonEncode({
          'count': 1,
          'next': null,
          'previous': null,
          'results': {
            'courses': [],
            'live_classes': [
              {
                'id': 96,
                'title': '1-on-1 Mentorship',
                'session_type': 'one_on_one',
                'status': 'upcoming',
              },
            ],
          },
        });

        dio.httpClientAdapter = _MockHttpClientAdapter((options) async {
          recordedRequests.add({'path': options.path});
          if (options.path == ApiEndpoints.liveClasses) {
            return ResponseBody.fromString(
              listResponseJson,
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }
          if (options.path ==
              ApiEndpoints.liveClassLearningSessionDetail('96')) {
            return ResponseBody.fromString(
              validLessonJson,
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }
          return ResponseBody.fromString('Not Found', 404);
        });

        final dataSource = HttpDataSource(dio: dio);

        // Fetch live classes list to populate session type cache
        await dataSource.getLiveClasses();

        // Fetch detail
        final lesson = await dataSource.getLiveClassDetail('96');

        expect(lesson.title, '1-on-1 Mentorship');
        expect(recordedRequests.length, 2);
        expect(recordedRequests.first['path'], ApiEndpoints.liveClasses);
        expect(
          recordedRequests.last['path'],
          ApiEndpoints.liveClassLearningSessionDetail('96'),
        );
      },
    );

    test(
      'falls back to learning-sessions endpoint on 404 from contents endpoint',
      () async {
        dio.httpClientAdapter = _MockHttpClientAdapter((options) async {
          recordedRequests.add({'path': options.path});
          if (options.path == ApiEndpoints.liveClassDetail('96')) {
            return ResponseBody.fromString(
              jsonEncode({'detail': 'Not found.'}),
              404,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }
          if (options.path ==
              ApiEndpoints.liveClassLearningSessionDetail('96')) {
            return ResponseBody.fromString(
              validLessonJson,
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }
          return ResponseBody.fromString('Not Found', 404);
        });

        final dataSource = HttpDataSource(dio: dio);
        final lesson = await dataSource.getLiveClassDetail('96');

        expect(lesson.title, '1-on-1 Mentorship');
        expect(recordedRequests.length, 2);
        expect(recordedRequests[0]['path'], ApiEndpoints.liveClassDetail('96'));
        expect(
          recordedRequests[1]['path'],
          ApiEndpoints.liveClassLearningSessionDetail('96'),
        );

        // Subsequent call should use cached one_on_one directly without hitting contents endpoint
        recordedRequests.clear();
        await dataSource.getLiveClassDetail('96');
        expect(recordedRequests.length, 1);
        expect(
          recordedRequests.first['path'],
          ApiEndpoints.liveClassLearningSessionDetail('96'),
        );
      },
    );

    test('rethrows 404 if fallback to learning-sessions also fails', () async {
      dio.httpClientAdapter = _MockHttpClientAdapter((options) async {
        recordedRequests.add({'path': options.path});
        return ResponseBody.fromString(
          jsonEncode({'detail': 'Not found.'}),
          404,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final dataSource = HttpDataSource(dio: dio);

      expect(
        () => dataSource.getLiveClassDetail('999'),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 404),
        ),
      );
    });
  });
}

class _MockHttpClientAdapter implements HttpClientAdapter {
  final Future<ResponseBody> Function(RequestOptions options) handler;

  _MockHttpClientAdapter(this.handler);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}
