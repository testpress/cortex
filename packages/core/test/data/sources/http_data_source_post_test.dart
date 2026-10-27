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
      'makes request with ?short_link=true when isShortLink is true',
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
        final post = await dataSource.getPost('fseznr', isShortLink: true);

        expect(post.slug, 'physics-formula-sheet');
        expect(post.shortLink, 'fseznr');
        expect(recordedRequests.length, 1);
        expect(recordedRequests.first['queryParameters'], {
          'short_link': 'true',
        });
      },
    );

    test(
      'makes request without query parameters when isShortLink is false',
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
        final post = await dataSource.getPost(
          'physics-formula-sheet',
          isShortLink: false,
        );

        expect(post.slug, 'physics-formula-sheet');
        expect(recordedRequests.length, 1);
        expect(recordedRequests.first['queryParameters'], isEmpty);
      },
    );

    test('throws ApiException on 404 Not Found', () async {
      dio.httpClientAdapter = _MockHttpClientAdapter((options) async {
        recordedRequests.add({
          'path': options.path,
          'queryParameters': options.queryParameters,
        });
        return ResponseBody.fromString('Not Found', 404);
      });

      final dataSource = HttpDataSource(dio: dio);

      expect(
        () => dataSource.getPost('missing-post', isShortLink: false),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'statusCode', 404)
              .having((e) => e.type, 'type', ApiErrorType.notFound),
        ),
      );
      await Future.delayed(const Duration(milliseconds: 50));
      expect(recordedRequests.length, 1);
    });

    test('rethrows non-404 error immediately', () async {
      dio.httpClientAdapter = _MockHttpClientAdapter((options) async {
        recordedRequests.add({
          'path': options.path,
          'queryParameters': options.queryParameters,
        });
        return ResponseBody.fromString('Server Error', 500);
      });

      final dataSource = HttpDataSource(dio: dio);

      expect(
        () => dataSource.getPost('fseznr', isShortLink: true),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 500),
        ),
      );
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
