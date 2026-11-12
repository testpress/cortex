import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/sources/http_data_source.dart';

void main() {
  group('HttpDataSource.getCourseChapters', () {
    late Dio dio;
    late List<Map<String, dynamic>> recordedRequests;

    setUp(() {
      recordedRequests = [];
      dio = Dio(BaseOptions(baseUrl: 'https://testpress.example'));
    });

    test(
      'fetches single-level root chapters when all chapters are leaves',
      () async {
        dio.httpClientAdapter = _MockHttpClientAdapter((options) async {
          recordedRequests.add({
            'path': options.path,
            'queryParameters': options.queryParameters,
          });

          if (options.queryParameters['parent_id'] == 'null') {
            final payload = jsonEncode({
              'results': {
                'chapters': [
                  {
                    'id': 101,
                    'name': 'TEST',
                    'course_id': 1,
                    'leaf': true,
                    'order': 1,
                  },
                ],
              },
            });
            return ResponseBody.fromString(
              payload,
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }

          return ResponseBody.fromString('Not Found', 404);
        });

        final dataSource = HttpDataSource(dio: dio);
        final chapters = await dataSource.getCourseChapters('1');

        expect(chapters.length, 1);
        expect(chapters.first.id, '101');
        expect(chapters.first.title, 'TEST');
        expect(chapters.first.isLeaf, true);

        expect(recordedRequests.length, 1);
        expect(recordedRequests.first['queryParameters'], {
          'parent_id': 'null',
        });
      },
    );

    test(
      'recursively fetches child chapters when a chapter is not a leaf',
      () async {
        dio.httpClientAdapter = _MockHttpClientAdapter((options) async {
          recordedRequests.add({
            'path': options.path,
            'queryParameters': options.queryParameters,
          });

          final parentId = options.queryParameters['parent_id'];
          if (parentId == 'null') {
            final payload = jsonEncode({
              'results': {
                'chapters': [
                  {
                    'id': 10,
                    'name': 'Physics',
                    'course_id': 1,
                    'leaf': false,
                    'order': 1,
                  },
                ],
              },
            });
            return ResponseBody.fromString(
              payload,
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          } else if (parentId == '10') {
            final payload = jsonEncode({
              'results': {
                'chapters': [
                  {
                    'id': 1001,
                    'name': 'Waves',
                    'course_id': 1,
                    'parent_id': 10,
                    'leaf': true,
                    'order': 1,
                  },
                ],
              },
            });
            return ResponseBody.fromString(
              payload,
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }

          return ResponseBody.fromString('Not Found', 404);
        });

        final dataSource = HttpDataSource(dio: dio);
        final chapters = await dataSource.getCourseChapters('1');

        expect(chapters.length, 2);
        expect(chapters[0].id, '10');
        expect(chapters[0].title, 'Physics');
        expect(chapters[0].isLeaf, false);

        expect(chapters[1].id, '1001');
        expect(chapters[1].title, 'Waves');
        expect(chapters[1].parentId, '10');
        expect(chapters[1].isLeaf, true);

        expect(recordedRequests.length, 2);
        expect(recordedRequests[0]['queryParameters'], {'parent_id': 'null'});
        expect(recordedRequests[1]['queryParameters'], {'parent_id': '10'});
      },
    );

    test(
      'safeguards against cyclical parent references without infinite looping',
      () async {
        dio.httpClientAdapter = _MockHttpClientAdapter((options) async {
          recordedRequests.add({
            'path': options.path,
            'queryParameters': options.queryParameters,
          });

          final parentId = options.queryParameters['parent_id'];
          if (parentId == 'null') {
            final payload = jsonEncode({
              'results': {
                'chapters': [
                  {
                    'id': 20,
                    'name': 'Loop Chapter A',
                    'course_id': 1,
                    'leaf': false,
                  },
                ],
              },
            });
            return ResponseBody.fromString(
              payload,
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          } else if (parentId == '20') {
            // Returns chapter 20 again (cycle)
            final payload = jsonEncode({
              'results': {
                'chapters': [
                  {
                    'id': 20,
                    'name': 'Loop Chapter A',
                    'course_id': 1,
                    'leaf': false,
                  },
                ],
              },
            });
            return ResponseBody.fromString(
              payload,
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }

          return ResponseBody.fromString('Not Found', 404);
        });

        final dataSource = HttpDataSource(dio: dio);
        final chapters = await dataSource.getCourseChapters('1');

        // Recursion halts gracefully and does not loop infinitely
        expect(chapters.length, 2);
        expect(recordedRequests.length, 2);
      },
    );

    test(
      'fetches sibling non-leaf chapters concurrently and aggregates children',
      () async {
        dio.httpClientAdapter = _MockHttpClientAdapter((options) async {
          recordedRequests.add({
            'path': options.path,
            'queryParameters': options.queryParameters,
          });

          final parentId = options.queryParameters['parent_id'];
          if (parentId == 'null') {
            final payload = jsonEncode({
              'results': {
                'chapters': [
                  {
                    'id': 10,
                    'name': 'Physics',
                    'course_id': 1,
                    'leaf': false,
                    'order': 1,
                  },
                  {
                    'id': 20,
                    'name': 'Chemistry',
                    'course_id': 1,
                    'leaf': false,
                    'order': 2,
                  },
                ],
              },
            });
            return ResponseBody.fromString(
              payload,
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          } else if (parentId == '10') {
            final payload = jsonEncode({
              'results': {
                'chapters': [
                  {
                    'id': 101,
                    'name': 'Mechanics',
                    'course_id': 1,
                    'parent_id': 10,
                    'leaf': true,
                  },
                ],
              },
            });
            return ResponseBody.fromString(
              payload,
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          } else if (parentId == '20') {
            final payload = jsonEncode({
              'results': {
                'chapters': [
                  {
                    'id': 201,
                    'name': 'Organic',
                    'course_id': 1,
                    'parent_id': 20,
                    'leaf': true,
                  },
                ],
              },
            });
            return ResponseBody.fromString(
              payload,
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }

          return ResponseBody.fromString('Not Found', 404);
        });

        final dataSource = HttpDataSource(dio: dio);
        final chapters = await dataSource.getCourseChapters('1');

        expect(chapters.length, 4);
        expect(chapters.map((c) => c.id).toList(), ['10', '20', '101', '201']);
        expect(recordedRequests.length, 3);
        expect(recordedRequests[0]['queryParameters'], {'parent_id': 'null'});
        final siblingParentIds = {
          recordedRequests[1]['queryParameters']?['parent_id'],
          recordedRequests[2]['queryParameters']?['parent_id'],
        };
        expect(siblingParentIds, {'10', '20'});
      },
    );
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
