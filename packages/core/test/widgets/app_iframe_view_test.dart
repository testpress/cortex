import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
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

    testWidgets('uses localized semantic label by default', (tester) async {
      await tester.pumpWidget(
        wrap(const AppIframeView(src: 'https://www.youtube.com/embed/test')),
      );

      final semanticsFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label == 'Embedded video player',
      );
      expect(semanticsFinder, findsOneWidget);
    });

    testWidgets('respects custom semantic label', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppIframeView(
            src: 'https://www.youtube.com/embed/test',
            semanticLabel: 'Custom video player',
          ),
        ),
      );

      final semanticsFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label == 'Custom video player',
      );
      expect(semanticsFinder, findsOneWidget);
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

    testWidgets('exposes semantic container with label', (tester) async {
      await tester.pumpWidget(
        wrap(const AppIframeView(src: 'https://www.youtube.com/embed/test')),
      );

      final semanticsFinder = find.byWidgetPredicate(
        (w) =>
            w is Semantics &&
            w.container == true &&
            w.properties.label == 'Embedded video player',
      );
      expect(semanticsFinder, findsOneWidget);
    });

    testWidgets('navigation delegate blocks intent:// schemes', (tester) async {
      await tester.pumpWidget(
        wrap(const AppIframeView(src: 'https://www.youtube.com/embed/test')),
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
  ) async {}

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
