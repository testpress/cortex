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

    test('allows main-frame navigation for baseUrl without external launch',
        () {
      bool launchCalled = false;

      const request = NavigationRequest(
        url: LessonWebView.defaultBaseUrl,
        isMainFrame: true,
      );

      final decision = LessonWebView.handleNavigationRequest(
        request: request,
        initialUrl: LessonWebView.defaultBaseUrl,
        urlLauncher: (uri,
            {LaunchMode mode = LaunchMode.platformDefault}) async {
          launchCalled = true;
          return true;
        },
      );

      expect(decision, NavigationDecision.navigate);
      expect(launchCalled, isFalse);
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

    test(
        'prevents outbound main-frame navigation to YouTube without calling launchUrl',
        () {
      bool launchCalled = false;

      final youtubeUrls = [
        'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        'https://m.youtube.com/watch?v=dQw4w9WgXcQ',
        'https://youtube.com/channel/UC12345',
        'https://youtu.be/dQw4w9WgXcQ',
        'https://www.youtube-nocookie.com/watch?v=dQw4w9WgXcQ',
      ];

      for (final url in youtubeUrls) {
        final request = NavigationRequest(
          url: url,
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

        expect(decision, NavigationDecision.prevent,
            reason: 'Expected $url to be blocked from navigating out');
        expect(launchCalled, isFalse,
            reason: 'Expected launchUrl NOT to be called for $url');
      }
    });

    test(
        'prevents outbound sharing of YouTube links (WhatsApp, Facebook, Reddit, Twitter) without calling launchUrl',
        () {
      bool launchCalled = false;

      final shareUrls = [
        'https://api.whatsapp.com/send?text=https%3A%2F%2Fyoutu.be%2F-18akWrJY9A%3Fsi%3Dx9cgEaK4Sswq9V8y',
        'https://www.facebook.com/dialog/share?app_id=87741124305&href=https%3A%2F%2Fyoutube.com%2Fwatch%3Fv%3D123',
        'https://www.reddit.com/submit?url=https%3A%2F%2Fyoutu.be%2F123&title=Check+this',
        'https://twitter.com/intent/tweet?url=https%3A%2F%2Fyoutu.be%2F123',
        'https://x.com/intent/post?url=https%3A%2F%2Fyoutu.be%2F123',
      ];

      for (final url in shareUrls) {
        final request = NavigationRequest(
          url: url,
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

        expect(decision, NavigationDecision.prevent,
            reason: 'Expected share link $url to be blocked');
        expect(launchCalled, isFalse,
            reason: 'Expected launchUrl NOT to be called for share link $url');
      }
    });

    test('continues delegating non-YouTube external links to launchUrl', () {
      Uri? launchedUri;
      LaunchMode? launchedMode;

      final testLinks = [
        'https://meet.google.com/abc-defg-hij',
        'https://zoom.us/j/123456789',
        'https://drive.google.com/file/d/123',
        'https://techcrunch.com/news/youtube.com-updates',
        'https://wikipedia.org/wiki/Streaming?source=youtube.com',
        'https://example.com/learn?ref=youtu.be',
      ];

      for (final link in testLinks) {
        final request = NavigationRequest(
          url: link,
          isMainFrame: true,
        );

        final decision = LessonWebView.handleNavigationRequest(
          request: request,
          urlLauncher: (uri,
              {LaunchMode mode = LaunchMode.platformDefault}) async {
            launchedUri = uri;
            launchedMode = mode;
            return true;
          },
        );

        expect(decision, NavigationDecision.prevent);
        expect(launchedUri, Uri.parse(link));
        expect(launchedMode, LaunchMode.inAppBrowserView);
      }
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

    test('catches launch errors without unhandled exceptions', () async {
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
      // Allow unawaited async exception handling to complete cleanly
      await Future<void>.delayed(Duration.zero);
    });

    test('handles launchUrl returning false gracefully', () async {
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
    });
  });

  group('LessonWebView.sanitizeIframeEmbeds', () {
    test('injects rel=0 into plain YouTube embed iframe', () {
      const input =
          '<iframe src="https://www.youtube.com/embed/dQw4w9WgXcQ" allowfullscreen></iframe>';
      final sanitized = LessonWebView.sanitizeIframeEmbeds(input);
      expect(
        sanitized,
        '<iframe src="https://www.youtube.com/embed/dQw4w9WgXcQ?rel=0" allowfullscreen></iframe>',
      );
    });

    test('injects rel=0 into YouTube embed iframe with single quotes', () {
      const input =
          "<iframe src='https://www.youtube.com/embed/dQw4w9WgXcQ' allowfullscreen></iframe>";
      final sanitized = LessonWebView.sanitizeIframeEmbeds(input);
      expect(
        sanitized,
        "<iframe src='https://www.youtube.com/embed/dQw4w9WgXcQ?rel=0' allowfullscreen></iframe>",
      );
    });

    test('preserves existing query parameters and handles &amp; entity', () {
      const input =
          '<iframe width="560" height="315" src="https://www.youtube.com/embed/xyz?start=30&amp;autoplay=1"></iframe>';
      final sanitized = LessonWebView.sanitizeIframeEmbeds(input);
      expect(
        sanitized,
        '<iframe width="560" height="315" src="https://www.youtube.com/embed/xyz?start=30&amp;autoplay=1&amp;rel=0"></iframe>',
      );
    });

    test('is idempotent when rel=0 or rel=1 is already present', () {
      const inputWithRel0 =
          '<iframe src="https://www.youtube.com/embed/xyz?rel=0"></iframe>';
      expect(
        LessonWebView.sanitizeIframeEmbeds(inputWithRel0),
        '<iframe src="https://www.youtube.com/embed/xyz?rel=0"></iframe>',
      );

      const inputWithRel1 =
          '<iframe src="https://www.youtube.com/embed/xyz?rel=1"></iframe>';
      expect(
        LessonWebView.sanitizeIframeEmbeds(inputWithRel1),
        '<iframe src="https://www.youtube.com/embed/xyz?rel=0"></iframe>',
      );
    });

    test('leaves non-YouTube iframes untouched', () {
      const input =
          '<iframe src="https://player.vimeo.com/video/12345"></iframe>';
      expect(LessonWebView.sanitizeIframeEmbeds(input), input);
    });

    test('handles multiple iframes with mixed providers', () {
      const input =
          '<div><iframe src="https://www.youtube.com/embed/yt1"></iframe>'
          '<iframe src="https://player.vimeo.com/video/v1"></iframe>'
          '<iframe src="https://www.youtube-nocookie.com/embed/yt2"></iframe></div>';
      final sanitized = LessonWebView.sanitizeIframeEmbeds(input);
      expect(
        sanitized,
        '<div><iframe src="https://www.youtube.com/embed/yt1?rel=0"></iframe>'
        '<iframe src="https://player.vimeo.com/video/v1"></iframe>'
        '<iframe src="https://www.youtube-nocookie.com/embed/yt2?rel=0"></iframe></div>',
      );
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

    test('sanitizes embedded YouTube iframes in htmlContent and description',
        () {
      final colors = DesignColors.light();
      final html = LessonWebView.buildStyledHtml(
        htmlContent:
            '<iframe src="https://www.youtube.com/embed/content1"></iframe>',
        description:
            '<iframe src="https://www.youtube.com/embed/desc1"></iframe>',
        colors: colors,
      );

      expect(
        html,
        contains('src="https://www.youtube.com/embed/content1?rel=0"'),
      );
      expect(
        html,
        contains('src="https://www.youtube.com/embed/desc1?rel=0"'),
      );
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

    testWidgets('loads HTML with rel=0 injected into embedded YouTube iframes',
        (tester) async {
      _FakePlatformWebViewController.lastLoadedHtmlString = null;
      _FakePlatformWebViewController.lastLoadedBaseUrl = null;

      await tester.pumpWidget(
        DesignProvider(
          config: DesignConfig.defaults(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: LessonWebView(
              htmlContent:
                  '<iframe src="https://www.youtube.com/embed/test_lesson_video"></iframe>',
            ),
          ),
        ),
      );
      await tester.pump();

      expect(
        _FakePlatformWebViewController.lastLoadedHtmlString,
        contains('src="https://www.youtube.com/embed/test_lesson_video?rel=0"'),
      );
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
