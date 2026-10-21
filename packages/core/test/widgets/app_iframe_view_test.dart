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
  });

  group('AppIframeView Widget', () {
    setUpAll(() {
      WebViewPlatform.instance = _FakeWebViewPlatform();
    });

    Widget wrap(Widget child) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: DesignProvider(config: DesignConfig.defaults(), child: child),
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
    });
  });
}

_FakePlatformNavigationDelegate? _lastNavigationDelegate;

class _FakePlatformWebViewController extends PlatformWebViewController {
  _FakePlatformWebViewController(super.params) : super.implementation();

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {}

  @override
  Future<void> setBackgroundColor(Color color) async {}

  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {}

  @override
  Future<void> loadHtmlString(String html, {String? baseUrl}) async {}
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
    return _FakePlatformWebViewController(params);
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
