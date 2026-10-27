import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/sources/http_data_source.dart';
import 'package:core/data/exceptions/api_exception.dart';

void main() {
  group('HttpDataSource.getPost', () {
    late Dio dio;
    late List<Map<String, dynamic>> recordedRequests;

    setUp(() {
      recordedRequests = [];
      dio = Dio(BaseOptions(baseUrl: 'https://testpress.example'));
    });

    final validPostJson = jsonEncode({
      'id': 101,
      'slug': 'physics-formula-sheet',
      'title': 'Physics Formula Sheet',
      'short_link': 'fseznr',
      'summary': 'Summary',
      'content_html': '<p>Content</p>',
      'published_date': '2026-10-27T10:00:00Z',
    });

    test(
      'queries ?short_link=true first for short codes and succeeds on first attempt',
      () async {
        dio.httpClientAdapter = _MockHttpClientAdapter((options) async {
          recordedRequests.add({
            'path': options.path,
            'queryParameters': options.queryParameters,
          });

          if (options.queryParameters['short_link'] == 'true') {
            return ResponseBody.fromString(
              validPostJson,
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }
          return ResponseBody.fromString('Not Found', 404);
        });

        final dataSource = HttpDataSource(dio: dio);
        final post = await dataSource.getPost('fseznr');

        expect(post.slug, 'physics-formula-sheet');
        expect(post.shortLink, 'fseznr');
        expect(recordedRequests.length, 1);
        expect(recordedRequests.first['queryParameters'], {
          'short_link': 'true',
        });
      },
    );

    test(
      'queries plain slug first for hyphenated slugs and succeeds on first attempt',
      () async {
        dio.httpClientAdapter = _MockHttpClientAdapter((options) async {
          recordedRequests.add({
            'path': options.path,
            'queryParameters': options.queryParameters,
          });

          if (options.queryParameters.isEmpty) {
            return ResponseBody.fromString(
              validPostJson,
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }
          return ResponseBody.fromString('Not Found', 404);
        });

        final dataSource = HttpDataSource(dio: dio);
        final post = await dataSource.getPost('physics-formula-sheet');

        expect(post.slug, 'physics-formula-sheet');
        expect(recordedRequests.length, 1);
        expect(recordedRequests.first['queryParameters'], isEmpty);
      },
    );

    test('falls back to second attempt when first attempt returns 404', () async {
      dio.httpClientAdapter = _MockHttpClientAdapter((options) async {
        recordedRequests.add({
          'path': options.path,
          'queryParameters': options.queryParameters,
        });

        // 404 on short_link, 200 on plain slug
        if (options.queryParameters['short_link'] == 'true') {
          return ResponseBody.fromString('Not Found', 404);
        }

        return ResponseBody.fromString(
          validPostJson,
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final dataSource = HttpDataSource(dio: dio);
      // 'welcome' has no hyphens and length <= 10, so attempts ?short_link=true first
      final post = await dataSource.getPost('welcome');

      expect(post.slug, 'physics-formula-sheet');
      expect(recordedRequests.length, 2);
      expect(recordedRequests[0]['queryParameters'], {'short_link': 'true'});
      expect(recordedRequests[1]['queryParameters'], isEmpty);
    });

    test('rethrows non-404 error immediately without retrying', () async {
      dio.httpClientAdapter = _MockHttpClientAdapter((options) async {
        recordedRequests.add({
          'path': options.path,
          'queryParameters': options.queryParameters,
        });
        return ResponseBody.fromString('Server Error', 500);
      });

      final dataSource = HttpDataSource(dio: dio);

      expect(
        () => dataSource.getPost('fseznr'),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 500),
        ),
      );
      // Wait for async call to finish
      await Future.delayed(const Duration(milliseconds: 50));
      expect(recordedRequests.length, 1);
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
