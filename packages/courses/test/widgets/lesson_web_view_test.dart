import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:courses/widgets/lesson_detail/lesson_web_view.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

void main() {
  group('LessonWebView.handleNavigationRequest', () {
    test(
        'allows navigation and server redirects when host matches initialUrl host',
        () {
      const initialUrl =
          'https://teammatesacademy.testpress.in/sso/token?next=/embed/123';

      final testUrls = [
        'https://teammatesacademy.testpress.in/sso/token?next=/embed/123',
        'https://teammatesacademy.testpress.in/embed/123',
        'https://teammatesacademy.testpress.in/embed/123/',
      ];

      for (final url in testUrls) {
        final request = NavigationRequest(
          url: url,
          isMainFrame: true,
        );

        final decision = LessonWebView.handleNavigationRequest(
          request: request,
          initialUrl: initialUrl,
        );

        expect(decision, NavigationDecision.navigate,
            reason: 'Expected $url on same host to be allowed');
      }
    });

    test(
        'prevents navigation and delegates to launchUrl for external http/https URLs',
        () async {
      Uri? launchedUri;
      LaunchMode? launchedMode;

      const request = NavigationRequest(
        url: 'https://meet.google.com/abc-defg-hij',
        isMainFrame: true,
      );

      final decision = LessonWebView.handleNavigationRequest(
        request: request,
        initialUrl: 'https://teammatesacademy.testpress.in/embed/123',
        urlLauncher: (uri,
            {LaunchMode mode = LaunchMode.platformDefault}) async {
          launchedUri = uri;
          launchedMode = mode;
          return true;
        },
      );

      expect(decision, NavigationDecision.prevent);
      expect(launchedUri, Uri.parse('https://meet.google.com/abc-defg-hij'));
      expect(launchedMode, LaunchMode.inAppBrowserView);
    });

    test('prevents navigation for non-http/https schemes without launching',
        () {
      bool launchCalled = false;

      const request = NavigationRequest(
        url: 'intent://some-host#Intent;scheme=something;end',
        isMainFrame: true,
      );

      final decision = LessonWebView.handleNavigationRequest(
        request: request,
        urlLauncher: (uri,
            {LaunchMode mode = LaunchMode.platformDefault}) async {
          launchCalled = true;
          return true;
        },
      );

      expect(decision, NavigationDecision.prevent);
      expect(launchCalled, isFalse);
    });

    test(
        'allows subframe navigation for embedded iframes even when initialUrl host differs',
        () {
      bool launchCalled = false;

      const request = NavigationRequest(
        url: 'https://www.youtube-nocookie.com/embed/dQw4w9WgXcQ',
        isMainFrame: false,
      );

      final decision = LessonWebView.handleNavigationRequest(
        request: request,
        initialUrl: 'https://teammatesacademy.testpress.in/embed/123',
        urlLauncher: (uri,
            {LaunchMode mode = LaunchMode.platformDefault}) async {
          launchCalled = true;
          return true;
        },
      );

      expect(decision, NavigationDecision.navigate);
      expect(launchCalled, isFalse);
    });

    test('allows subframe navigation for embedded http/https iframes', () {
      bool launchCalled = false;

      const request = NavigationRequest(
        url: 'https://www.youtube-nocookie.com/embed/dQw4w9WgXcQ',
        isMainFrame: false,
      );

      final decision = LessonWebView.handleNavigationRequest(
        request: request,
        urlLauncher: (uri,
            {LaunchMode mode = LaunchMode.platformDefault}) async {
          launchCalled = true;
          return true;
        },
      );

      expect(decision, NavigationDecision.navigate);
      expect(launchCalled, isFalse);
    });

    test('prevents subframe navigation for non-http/https schemes', () {
      bool launchCalled = false;

      const request = NavigationRequest(
        url: 'intent://some-host#Intent;scheme=something;end',
        isMainFrame: false,
      );

      final decision = LessonWebView.handleNavigationRequest(
        request: request,
        urlLauncher: (uri,
            {LaunchMode mode = LaunchMode.platformDefault}) async {
          launchCalled = true;
          return true;
        },
      );

      expect(decision, NavigationDecision.prevent);
      expect(launchCalled, isFalse);
    });

    test('prevents navigation for malformed URLs without crashing', () {
      const request = NavigationRequest(
        url: '://invalid-url',
        isMainFrame: true,
      );

      final decision = LessonWebView.handleNavigationRequest(
        request: request,
      );

      expect(decision, NavigationDecision.prevent);
    });

    test('catches launch errors and logs without unhandled exceptions',
        () async {
      final logs = <String>[];
      final originalDebugPrint = debugPrint;
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null) logs.add(message);
      };

      try {
        const request = NavigationRequest(
          url: 'https://meet.google.com/abc-defg-hij',
          isMainFrame: true,
        );

        final decision = LessonWebView.handleNavigationRequest(
          request: request,
          urlLauncher: (uri,
              {LaunchMode mode = LaunchMode.platformDefault}) async {
            throw Exception('Platform activity not found');
          },
        );

        expect(decision, NavigationDecision.prevent);
        // Allow unawaited async exception handling to complete
        await Future<void>.delayed(Duration.zero);
        expect(logs.any((msg) => msg.contains('Error launching external URL')),
            isTrue);
      } finally {
        debugPrint = originalDebugPrint;
      }
    });

    test('logs when launchUrl returns false', () async {
      final logs = <String>[];
      final originalDebugPrint = debugPrint;
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null) logs.add(message);
      };

      try {
        const request = NavigationRequest(
          url: 'https://meet.google.com/abc-defg-hij',
          isMainFrame: true,
        );

        final decision = LessonWebView.handleNavigationRequest(
          request: request,
          urlLauncher: (uri,
              {LaunchMode mode = LaunchMode.platformDefault}) async {
            return false;
          },
        );

        expect(decision, NavigationDecision.prevent);
        await Future<void>.delayed(Duration.zero);
        expect(logs.any((msg) => msg.contains('Failed to launch external URL')),
            isTrue);
      } finally {
        debugPrint = originalDebugPrint;
      }
    });
  });

  group('LessonWebView.buildStyledHtml', () {
    test('injects responsive CSS for table, iframe, and colors', () {
      final colors = DesignColors.light();
      final html = LessonWebView.buildStyledHtml(
        htmlContent: '<table><tr><td>Item</td></tr></table>',
        description: 'Test description',
        colors: colors,
      );

      expect(html, contains('table {'));
      expect(html, contains('max-width: 100% !important;'));
      expect(html, contains('display: block;'));
      expect(html, contains('overflow-x: auto;'));
      expect(html, contains('-webkit-overflow-scrolling: touch;'));
      expect(html, contains('iframe {'));
      expect(html, contains('Test description'));
    });
  });

  group('LessonWebView widget-level tests', () {
    setUpAll(() {
      WebViewPlatform.instance = _FakeWebViewPlatform();
    });

    testWidgets(
        'renders LessonWebView and loads HTML with responsive table CSS',
        (tester) async {
      _FakePlatformWebViewController.lastLoadedHtmlString = null;

      await tester.pumpWidget(
        DesignProvider(
          config: DesignConfig.defaults(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: LessonWebView(
              htmlContent: '<table><tr><td>Data</td></tr></table>',
            ),
          ),
        ),
      );
      await tester.pump();

      final loadedHtml = _FakePlatformWebViewController.lastLoadedHtmlString;
      expect(loadedHtml, isNotNull);
      expect(loadedHtml, contains('table {'));
      expect(loadedHtml, contains('max-width: 100% !important;'));
      expect(loadedHtml, contains('display: block;'));
      expect(loadedHtml, contains('overflow-x: auto;'));
      expect(loadedHtml, contains('-webkit-overflow-scrolling: touch;'));
      expect(loadedHtml, contains('<table><tr><td>Data</td></tr></table>'));
      expect(_FakePlatformWebViewController.lastLoadedBaseUrl,
          'https://www.testpress.in');
    });

    testWidgets(
        'initial HTML load with baseUrl renders in webview without external launch',
        (tester) async {
      _FakePlatformWebViewController.lastLoadedHtmlString = null;
      _FakePlatformWebViewController.lastLoadedBaseUrl = null;

      await tester.pumpWidget(
        DesignProvider(
          config: DesignConfig.defaults(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: LessonWebView(
              htmlContent: '<p>Lesson notes with baseUrl origin</p>',
            ),
          ),
        ),
      );
      await tester.pump();

      expect(_FakePlatformWebViewController.lastLoadedHtmlString,
          contains('<p>Lesson notes with baseUrl origin</p>'));
      expect(_FakePlatformWebViewController.lastLoadedBaseUrl,
          'https://www.testpress.in');
    });
  });
}

class _FakePlatformWebViewController extends PlatformWebViewController {
  _FakePlatformWebViewController(super.params) : super.implementation();

  static String? lastLoadedHtmlString;
  static String? lastLoadedBaseUrl;

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {}

  @override
  Future<void> setBackgroundColor(Color color) async {}

  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {}

  @override
  Future<void> loadHtmlString(String html, {String? baseUrl}) async {
    lastLoadedHtmlString = html;
    lastLoadedBaseUrl = baseUrl;
  }

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
