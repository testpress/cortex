import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

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

  group('AppWebView SafeArea', () {
    setUpAll(() {
      WebViewPlatform.instance = _FakeWebViewPlatform();
    });

    Widget wrap(Widget child) {
      return ProviderScope(
        overrides: [
          authLocalDataSourceProvider.overrideWithValue(
            _FakeAuthLocalDataSource(),
          ),
        ],
        child: DesignProvider(
          config: DesignConfig.defaults(),
          child: LocalizationProvider(
            child: Builder(
              builder: (context) {
                final locale = LocalizationProvider.of(context).locale;
                return Localizations(
                  locale: locale,
                  delegates: LocalizationProvider.delegates,
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: child,
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    testWidgets('wraps content in SafeArea by default', (tester) async {
      await tester.pumpWidget(
        wrap(const AppWebView(url: 'https://example.com')),
      );

      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('omits SafeArea when useSafeArea is false', (tester) async {
      await tester.pumpWidget(
        wrap(const AppWebView(url: 'https://example.com', useSafeArea: false)),
      );

      expect(find.byType(SafeArea), findsNothing);
    });

    testWidgets(
      'configures platform-appropriate user agent on initialization',
      (tester) async {
        _FakePlatformWebViewController.lastSetUserAgent = null;

        await tester.pumpWidget(
          wrap(const AppWebView(url: 'https://example.com')),
        );
        await tester.pump();

        expect(
          _FakePlatformWebViewController.lastSetUserAgent,
          contains(
            Platform.isAndroid
                ? 'TestpressAndroidApp/WebView flutter-app'
                : 'TestpressiOSApp/WebView flutter-app',
          ),
        );
      },
    );
  });
}

class _FakePlatformWebViewController extends PlatformWebViewController {
  _FakePlatformWebViewController(super.params) : super.implementation();

  static String? lastSetUserAgent;

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {}

  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {}

  @override
  Future<void> setUserAgent(String? userAgent) async {
    lastSetUserAgent = userAgent;
  }

  @override
  Future<String?> getUserAgent() async => 'MockUserAgent';

  @override
  Future<void> setOnConsoleMessage(
    void Function(JavaScriptConsoleMessage consoleMessage) onConsoleMessage,
  ) async {}

  @override
  Future<void> loadRequest(LoadRequestParams params) async {}

  @override
  Future<void> runJavaScript(String javaScript) async {}
}

class _FakePlatformWebViewWidget extends PlatformWebViewWidget {
  _FakePlatformWebViewWidget(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _FakePlatformNavigationDelegate extends PlatformNavigationDelegate {
  _FakePlatformNavigationDelegate(super.params) : super.implementation();

  @override
  Future<void> setOnProgress(void Function(int progress) onProgress) async {}

  @override
  Future<void> setOnPageStarted(
    void Function(String url) onPageStarted,
  ) async {}

  @override
  Future<void> setOnPageFinished(
    void Function(String url) onPageFinished,
  ) async {}

  @override
  Future<void> setOnWebResourceError(
    void Function(WebResourceError error) onWebResourceError,
  ) async {}

  @override
  Future<void> setOnNavigationRequest(
    FutureOr<NavigationDecision> Function(NavigationRequest request)
    onNavigationRequest,
  ) async {}

  @override
  Future<void> setOnUrlChange(
    void Function(UrlChange change) onUrlChange,
  ) async {}

  @override
  Future<void> setOnHttpAuthRequest(
    void Function(HttpAuthRequest request) onHttpAuthRequest,
  ) async {}

  @override
  Future<void> setOnHttpError(
    void Function(HttpResponseError error) onHttpError,
  ) async {}
}

class _FakeWebViewPlatform extends WebViewPlatform {
  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) {
    return _FakePlatformWebViewController(params);
  }

  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) {
    return _FakePlatformNavigationDelegate(params);
  }

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) {
    return _FakePlatformWebViewWidget(params);
  }
}

class _FakeAuthLocalDataSource extends Fake implements AuthLocalDataSource {
  @override
  Future<String?> getToken() async => 'mock_token';
}
