import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:webview_flutter/webview_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

void main() {
  group('AppIframeView.normalizeUrl', () {
    test('normalizes protocol-relative URL', () {
      expect(
        AppIframeView.normalizeUrl('//www.youtube.com/embed/123'),
        'https://www.youtube.com/embed/123',
      );
    });

    test('normalizes bare host URL', () {
      expect(
        AppIframeView.normalizeUrl('www.youtube.com/embed/123'),
        'https://www.youtube.com/embed/123',
      );
    });

    test('preserves existing https URL', () {
      expect(
        AppIframeView.normalizeUrl('https://player.vimeo.com/video/456'),
        'https://player.vimeo.com/video/456',
      );
    });

    test('preserves existing http URL', () {
      expect(
        AppIframeView.normalizeUrl('http://example.com/embed'),
        'http://example.com/embed',
      );
    });

    test('rejects non-http(s) schemes like javascript: and data:', () {
      expect(AppIframeView.normalizeUrl('javascript:alert(1)'), '');
      expect(AppIframeView.normalizeUrl('data:text/html,evil'), '');
      expect(AppIframeView.normalizeUrl('vbscript:msgbox'), '');
      expect(AppIframeView.normalizeUrl(''), '');
    });
  });

  group('AppIframeView.isSupportedUrl', () {
    test('accepts valid YouTube embed URLs', () {
      expect(
        AppIframeView.isSupportedUrl(
          'https://www.youtube.com/embed/dQw4w9WgXcQ',
        ),
        isTrue,
      );
      expect(
        AppIframeView.isSupportedUrl('https://youtube.com/embed/dQw4w9WgXcQ'),
        isTrue,
      );
      expect(
        AppIframeView.isSupportedUrl(
          'https://www.youtube-nocookie.com/embed/dQw4w9WgXcQ',
        ),
        isTrue,
      );
      expect(
        AppIframeView.isSupportedUrl('//www.youtube.com/embed/dQw4w9WgXcQ'),
        isTrue,
      );
    });

    test('rejects non-YouTube or non-embed URLs', () {
      expect(
        AppIframeView.isSupportedUrl('https://www.youtube.com/watch?v=123'),
        isFalse,
      );
      expect(
        AppIframeView.isSupportedUrl('https://vimeo.com/video/123'),
        isFalse,
      );
      expect(
        AppIframeView.isSupportedUrl('https://youtube.evil.com/embed/123'),
        isFalse,
      );
      expect(AppIframeView.isSupportedUrl(''), isFalse);
      expect(AppIframeView.isSupportedUrl('javascript:alert(1)'), isFalse);
    });
  });

  group('AppIframeView Widget', () {
    setUpAll(() {
      WebViewPlatform.instance = _FakeWebViewPlatform();
    });

    Widget wrap(Widget child) {
      return LocalizationProvider(
        child: Builder(
          builder: (context) {
            final locale = LocalizationProvider.of(context).locale;
            return WidgetsApp(
              color: const Color(0xFF000000),
              locale: locale,
              localizationsDelegates: LocalizationProvider.delegates,
              pageRouteBuilder:
                  <T>(RouteSettings settings, WidgetBuilder builder) =>
                      PageRouteBuilder<T>(
                        settings: settings,
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            builder(context),
                      ),
              home: DesignProvider(
                config: DesignConfig.defaults(),
                child: child,
              ),
            );
          },
        ),
      );
    }

    testWidgets('renders AspectRatio of 16/9 by default', (tester) async {
      await tester.pumpWidget(
        wrap(const AppIframeView(src: 'https://www.youtube.com/embed/test')),
      );

      final aspectRatioFinder = find.byType(AspectRatio);
      expect(aspectRatioFinder, findsOneWidget);
      final aspectRatioWidget = tester.widget<AspectRatio>(aspectRatioFinder);
      expect(aspectRatioWidget.aspectRatio, 16 / 9);
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('respects custom aspect ratio', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppIframeView(
            src: 'https://www.youtube.com/embed/test',
            aspectRatio: 4 / 3,
          ),
        ),
      );

      final aspectRatioFinder = find.byType(AspectRatio);
      expect(aspectRatioFinder, findsOneWidget);
      final aspectRatioWidget = tester.widget<AspectRatio>(aspectRatioFinder);
      expect(aspectRatioWidget.aspectRatio, 4 / 3);
    });

    testWidgets('renders AspectRatio and ClipRRect container directly', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const AppIframeView(src: 'https://www.youtube.com/embed/test')),
      );

      expect(find.byType(AspectRatio), findsOneWidget);
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('configures WebViewWidget with eager gesture recognizers', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const AppIframeView(src: 'https://www.youtube.com/embed/test')),
      );

      final webViewFinder = find.byType(WebViewWidget);
      expect(webViewFinder, findsOneWidget);
      final webViewWidget = tester.widget<WebViewWidget>(webViewFinder);
      expect(webViewWidget.gestureRecognizers, isNotEmpty);
      expect(
        webViewWidget.gestureRecognizers.any(
          (factory) => factory.type == OneSequenceGestureRecognizer,
        ),
        isTrue,
      );
    });

    testWidgets(
      'shows loading indicator while loading and hides it on page finished',
      (tester) async {
        await tester.pumpWidget(
          wrap(const AppIframeView(src: 'https://www.youtube.com/embed/test')),
        );

        expect(find.byType(AppLoadingIndicator), findsOneWidget);

        _lastNavigationDelegate?.onPageFinishedCallback?.call(
          'https://www.youtube.com/embed/test',
        );
        await tester.pump();

        expect(find.byType(AppLoadingIndicator), findsNothing);
      },
    );

    testWidgets(
      'resets and shows loading indicator when src changes via didUpdateWidget',
      (tester) async {
        await tester.pumpWidget(
          wrap(const AppIframeView(src: 'https://www.youtube.com/embed/test1')),
        );

        expect(find.byType(AppLoadingIndicator), findsOneWidget);

        _lastNavigationDelegate?.onPageFinishedCallback?.call(
          'https://www.youtube.com/embed/test1',
        );
        await tester.pump();
        expect(find.byType(AppLoadingIndicator), findsNothing);

        await tester.pumpWidget(
          wrap(const AppIframeView(src: 'https://www.youtube.com/embed/test2')),
        );
        expect(find.byType(AppLoadingIndicator), findsOneWidget);

        _lastNavigationDelegate?.onPageFinishedCallback?.call(
          'https://www.youtube.com/embed/test2',
        );
        await tester.pump();
        expect(find.byType(AppLoadingIndicator), findsNothing);
      },
    );

    testWidgets(
      'dismisses loading indicator when src updates to empty string via didUpdateWidget',
      (tester) async {
        await tester.pumpWidget(
          wrap(const AppIframeView(src: 'https://www.youtube.com/embed/test1')),
        );
        expect(find.byType(AppLoadingIndicator), findsOneWidget);

        await tester.pumpWidget(wrap(const AppIframeView(src: '')));
        await tester.pump();
        expect(find.byType(AppLoadingIndicator), findsNothing);
      },
    );

    testWidgets('navigation delegate blocks intent:// schemes', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppIframeView(
            src: 'https://www.youtube.com/embed/test',
            baseUrl: 'https://www.testpress.in',
          ),
        ),
      );

      expect(_lastNavigationDelegate?.navigationRequestCallback, isNotNull);
      final callback = _lastNavigationDelegate!.navigationRequestCallback!;

      final intentDecision = await callback(
        const NavigationRequest(
          url: 'intent://m.youtube.com/watch?v=123',
          isMainFrame: true,
        ),
      );
      expect(intentDecision, NavigationDecision.prevent);

      final watchDecision = await callback(
        const NavigationRequest(
          url: 'https://www.youtube.com/watch?v=123',
          isMainFrame: true,
        ),
      );
      expect(watchDecision, NavigationDecision.prevent);

      final embedDecision = await callback(
        const NavigationRequest(
          url: 'https://www.youtube.com/embed/test',
          isMainFrame: true,
        ),
      );
      expect(embedDecision, NavigationDecision.navigate);

      final baseDecision = await callback(
        const NavigationRequest(
          url: 'https://www.testpress.in',
          isMainFrame: true,
        ),
      );
      expect(baseDecision, NavigationDecision.navigate);

      // Verify prefix spoofing is blocked: uri.host comparison prevents .evil.com bypass
      final evilHostDecision = await callback(
        const NavigationRequest(
          url: 'https://www.testpress.in.evil.com/phish',
          isMainFrame: true,
        ),
      );
      expect(evilHostDecision, NavigationDecision.prevent);
    });

    testWidgets(
      'defaults to null baseUrl when unspecified and blocks non-youtube navigation',
      (tester) async {
        await tester.pumpWidget(
          wrap(const AppIframeView(src: 'https://www.youtube.com/embed/test')),
        );

        expect(_lastWebViewController?.lastLoadedBaseUrl, isNull);
        final callback = _lastNavigationDelegate!.navigationRequestCallback!;

        final testpressDecision = await callback(
          const NavigationRequest(
            url: 'https://www.testpress.in',
            isMainFrame: true,
          ),
        );
        expect(testpressDecision, NavigationDecision.prevent);
      },
    );

    testWidgets('supports configurable baseUrl and enforces its origin', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const AppIframeView(
            src: 'https://www.youtube.com/embed/test',
            baseUrl: 'https://learn.myinstitute.com',
          ),
        ),
      );

      expect(
        _lastWebViewController?.lastLoadedBaseUrl,
        'https://learn.myinstitute.com',
      );
      final callback = _lastNavigationDelegate!.navigationRequestCallback!;

      final allowedTenantDecision = await callback(
        const NavigationRequest(
          url: 'https://learn.myinstitute.com/page',
          isMainFrame: true,
        ),
      );
      expect(allowedTenantDecision, NavigationDecision.navigate);

      // Other subdomains of the tenant domain should be blocked by exact host match
      final otherSubdomainDecision = await callback(
        const NavigationRequest(
          url: 'https://user-generated.myinstitute.com/page',
          isMainFrame: true,
        ),
      );
      expect(otherSubdomainDecision, NavigationDecision.prevent);

      // Default testpress host should not be allowed when custom baseUrl is provided
      final testpressDecision = await callback(
        const NavigationRequest(
          url: 'https://www.testpress.in',
          isMainFrame: true,
        ),
      );
      expect(testpressDecision, NavigationDecision.prevent);
    });

    testWidgets('rejects arbitrary third-party hosts with /embed/ or /video/', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const AppIframeView(src: 'https://www.youtube.com/embed/test')),
      );

      final callback = _lastNavigationDelegate!.navigationRequestCallback!;

      // Arbitrary host with /video/ path should be blocked
      final evilVideoDecision = await callback(
        const NavigationRequest(
          url: 'https://evil.com/video/phish',
          isMainFrame: true,
        ),
      );
      expect(evilVideoDecision, NavigationDecision.prevent);

      // Arbitrary host with /embed/ path should be blocked
      final evilEmbedDecision = await callback(
        const NavigationRequest(
          url: 'https://malicious.org/embed/x',
          isMainFrame: true,
        ),
      );
      expect(evilEmbedDecision, NavigationDecision.prevent);
    });

    testWidgets('rejects non-YouTube providers like Vimeo', (tester) async {
      await tester.pumpWidget(
        wrap(const AppIframeView(src: 'https://player.vimeo.com/video/12345')),
      );

      final callback = _lastNavigationDelegate!.navigationRequestCallback!;

      final vimeoDecision = await callback(
        const NavigationRequest(
          url: 'https://player.vimeo.com/video/12345',
          isMainFrame: true,
        ),
      );
      expect(vimeoDecision, NavigationDecision.prevent);
    });

    testWidgets('escapes HTML attribute delimiter characters in iframe src', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const AppIframeView(
            src: 'https://www.youtube.com/embed/test?a=1&b=2',
          ),
        ),
      );

      final loadedHtml = _lastWebViewController?.lastLoadedHtml ?? '';
      expect(
        loadedHtml,
        contains('src="https://www.youtube.com/embed/test?a=1&amp;b=2"'),
      );
      expect(loadedHtml, isNot(contains('&b=2"')));
    });
  });

  group('AppIframeView Host Spoofing & Security Guardrails', () {
    Widget wrap(Widget child) {
      return LocalizationProvider(
        child: Builder(
          builder: (context) {
            final locale = LocalizationProvider.of(context).locale;
            return WidgetsApp(
              color: const Color(0xFF000000),
              locale: locale,
              localizationsDelegates: LocalizationProvider.delegates,
              pageRouteBuilder:
                  <T>(RouteSettings settings, WidgetBuilder builder) =>
                      PageRouteBuilder<T>(
                        settings: settings,
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            builder(context),
                      ),
              home: DesignProvider(
                config: DesignConfig.defaults(),
                child: child,
              ),
            );
          },
        ),
      );
    }

    testWidgets('rejects domain prefix spoofing like testpress.in.evil.com', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const AppIframeView(src: 'https://www.youtube.com/embed/test')),
      );

      final callback = _lastNavigationDelegate!.navigationRequestCallback!;

      final spoofDecision = await callback(
        const NavigationRequest(
          url: 'https://testpress.in.evil.com/embed/video',
          isMainFrame: true,
        ),
      );
      expect(spoofDecision, NavigationDecision.prevent);

      final spoofWwwDecision = await callback(
        const NavigationRequest(
          url: 'https://www.testpress.in.evil.com/phish',
          isMainFrame: true,
        ),
      );
      expect(spoofWwwDecision, NavigationDecision.prevent);
    });

    testWidgets(
      'rejects arbitrary hosts with embed paths (e.g. evil.com/embed/)',
      (tester) async {
        await tester.pumpWidget(
          wrap(const AppIframeView(src: 'https://www.youtube.com/embed/test')),
        );

        final callback = _lastNavigationDelegate!.navigationRequestCallback!;

        final evilEmbedDecision = await callback(
          const NavigationRequest(
            url: 'https://evil.com/embed/',
            isMainFrame: true,
          ),
        );
        expect(evilEmbedDecision, NavigationDecision.prevent);

        final evilEmbedDeepDecision = await callback(
          const NavigationRequest(
            url: 'https://evil.com/embed/malicious-video-id',
            isMainFrame: true,
          ),
        );
        expect(evilEmbedDeepDecision, NavigationDecision.prevent);

        final evilVideoDecision = await callback(
          const NavigationRequest(
            url: 'https://evil.com/video/attack',
            isMainFrame: true,
          ),
        );
        expect(evilVideoDecision, NavigationDecision.prevent);
      },
    );

    testWidgets(
      'rejects subdomain spoofing on third-party hosts like youtube.evil.com',
      (tester) async {
        await tester.pumpWidget(
          wrap(const AppIframeView(src: 'https://www.youtube.com/embed/test')),
        );

        final callback = _lastNavigationDelegate!.navigationRequestCallback!;

        final youtubeSpoofDecision = await callback(
          const NavigationRequest(
            url: 'https://youtube.evil.com/embed/123',
            isMainFrame: true,
          ),
        );
        expect(youtubeSpoofDecision, NavigationDecision.prevent);

        final youtubePrefixSpoofDecision = await callback(
          const NavigationRequest(
            url: 'https://youtube.com.evil.com/embed/123',
            isMainFrame: true,
          ),
        );
        expect(youtubePrefixSpoofDecision, NavigationDecision.prevent);

        final vimeoSpoofDecision = await callback(
          const NavigationRequest(
            url: 'https://vimeo.evil.com/video/123',
            isMainFrame: true,
          ),
        );
        expect(vimeoSpoofDecision, NavigationDecision.prevent);
      },
    );
  });
}

_FakePlatformNavigationDelegate? _lastNavigationDelegate;
_FakePlatformWebViewController? _lastWebViewController;

class _FakePlatformWebViewController extends PlatformWebViewController {
  _FakePlatformWebViewController(super.params) : super.implementation();

  String? lastLoadedBaseUrl;
  String? lastLoadedHtml;

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
    lastLoadedHtml = html;
    lastLoadedBaseUrl = baseUrl;
  }
}

class _FakePlatformWebViewWidget extends PlatformWebViewWidget {
  _FakePlatformWebViewWidget(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _FakePlatformNavigationDelegate extends PlatformNavigationDelegate {
  _FakePlatformNavigationDelegate(super.params) : super.implementation();

  NavigationRequestCallback? navigationRequestCallback;
  void Function(String url)? onPageFinishedCallback;

  @override
  Future<void> setOnNavigationRequest(
    NavigationRequestCallback onNavigationRequest,
  ) async {
    navigationRequestCallback = onNavigationRequest;
  }

  @override
  Future<void> setOnProgress(void Function(int progress) onProgress) async {}

  @override
  Future<void> setOnPageStarted(
    void Function(String url) onPageStarted,
  ) async {}

  @override
  Future<void> setOnPageFinished(
    void Function(String url) onPageFinished,
  ) async {
    onPageFinishedCallback = onPageFinished;
  }

  @override
  Future<void> setOnWebResourceError(
    void Function(WebResourceError error) onWebResourceError,
  ) async {}
}

class _FakeWebViewPlatform extends WebViewPlatform {
  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) {
    final controller = _FakePlatformWebViewController(params);
    _lastWebViewController = controller;
    return controller;
  }

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) {
    return _FakePlatformWebViewWidget(params);
  }

  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) {
    final delegate = _FakePlatformNavigationDelegate(params);
    _lastNavigationDelegate = delegate;
    return delegate;
  }
}
