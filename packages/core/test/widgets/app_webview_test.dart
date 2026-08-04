import 'package:flutter_test/flutter_test.dart';
import 'package:core/widgets/app_webview.dart';

void main() {
  group('AppWebView.buildHeaders', () {
    const initialUrl = 'https://example.com/report/';
    const testToken = 'mock_jwt_token';

    test(
      'should return Authorization header when all security checks pass',
      () {
        final headers = AppWebView.buildHeaders(
          requestUri: Uri.parse(initialUrl),
          requestUrl: initialUrl,
          initialUrl: initialUrl,
          token: testToken,
        );

        expect(headers, {'Authorization': 'JWT mock_jwt_token'});
      },
    );

    test('should return empty headers if request scheme is not https', () {
      final headers = AppWebView.buildHeaders(
        requestUri: Uri.parse('http://example.com/report/'),
        requestUrl: 'http://example.com/report/',
        initialUrl: initialUrl,
        token: testToken,
      );

      expect(headers, isEmpty);
    });

    test(
      'should return empty headers if request host does not match initial host',
      () {
        final headers = AppWebView.buildHeaders(
          requestUri: Uri.parse('https://evil.com/report/'),
          requestUrl: 'https://evil.com/report/',
          initialUrl: initialUrl,
          token: testToken,
        );

        expect(headers, isEmpty);
      },
    );

    test(
      'should return empty headers if request URL does not match initial URL',
      () {
        final headers = AppWebView.buildHeaders(
          requestUri: Uri.parse('https://example.com/report/page2'),
          requestUrl: 'https://example.com/report/page2',
          initialUrl: initialUrl,
          token: testToken,
        );

        expect(headers, isEmpty);
      },
    );

    test('should return empty headers if token is null', () {
      final headers = AppWebView.buildHeaders(
        requestUri: Uri.parse(initialUrl),
        requestUrl: initialUrl,
        initialUrl: initialUrl,
        token: null,
      );

      expect(headers, isEmpty);
    });

    test('should return empty headers if token is empty', () {
      final headers = AppWebView.buildHeaders(
        requestUri: Uri.parse(initialUrl),
        requestUrl: initialUrl,
        initialUrl: initialUrl,
        token: '',
      );

      expect(headers, isEmpty);
    });
  });
}
