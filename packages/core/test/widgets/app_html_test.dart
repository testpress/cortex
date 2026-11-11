import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

void main() {
  setUpAll(() {
    WebViewPlatform.instance = _FakeWebViewPlatform();
  });

  setUp(() {
    _FakePlatformWebViewController.lastLoadedHtml = null;
  });

  Widget wrap(Widget child, {bool isDark = false}) {
    final config = isDark ? DesignConfig.dark() : DesignConfig.defaults();
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
            home: DesignProvider(config: config, child: child),
          );
        },
      ),
    );
  }

  group('AppHtml HTML Generation', () {
    test(
      'includes invertEquationImages invocation in cleanAll for dark mode',
      () {
        final html = AppHtml.buildHtmlDocument(
          content: '<p>Question</p>',
          bgCss: '#121212',
          txCss: '#ffffff',
          fontSize: 16.0,
          isDark: true,
        );

        expect(html, contains('invertEquationImages();'));
        expect(html, contains('function invertEquationImages()'));
        expect(html, contains('wirisformula'));
        expect(html, contains('codecogs.com'));
        expect(html, contains('/questions/'));
        expect(html, contains('filter = \'invert(1)\''));
      },
    );

    test(
      'omits invertEquationImages invocation in cleanAll for light mode',
      () {
        final html = AppHtml.buildHtmlDocument(
          content: '<p>Question</p>',
          bgCss: '#ffffff',
          txCss: '#000000',
          fontSize: 16.0,
          isDark: false,
        );

        // CleanAll should NOT call invertEquationImages in light mode
        expect(html, isNot(contains('invertEquationImages();')));
      },
    );
  });

  group('AppHtml WebView Controller Integration', () {
    testWidgets('loads HTML with invertEquationImages() in dark mode', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const AppHtml(data: '<p>Question with math</p>'), isDark: true),
      );
      await tester.pump();

      final loadedHtml = _FakePlatformWebViewController.lastLoadedHtml;
      expect(loadedHtml, isNotNull);
      expect(loadedHtml, contains('invertEquationImages();'));
    });

    testWidgets('loads HTML without invertEquationImages() in light mode', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const AppHtml(data: '<p>Question with math</p>'), isDark: false),
      );
      await tester.pump();

      final loadedHtml = _FakePlatformWebViewController.lastLoadedHtml;
      expect(loadedHtml, isNotNull);
      expect(loadedHtml, isNot(contains('invertEquationImages();')));
    });
  });
}

class _FakePlatformWebViewController extends PlatformWebViewController {
  _FakePlatformWebViewController(super.params) : super.implementation();

  static String? lastLoadedHtml;

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {}

  @override
  Future<void> setBackgroundColor(Color color) async {}

  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {}

  @override
  Future<void> addJavaScriptChannel(
    JavaScriptChannelParams javaScriptChannelParams,
  ) async {}

  @override
  Future<void> loadHtmlString(String html, {String? baseUrl}) async {
    lastLoadedHtml = html;
  }
}

class _FakePlatformWebViewWidget extends PlatformWebViewWidget {
  _FakePlatformWebViewWidget(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _FakePlatformNavigationDelegate extends PlatformNavigationDelegate {
  _FakePlatformNavigationDelegate(super.params) : super.implementation();

  @override
  Future<void> setOnNavigationRequest(
    NavigationRequestCallback onNavigationRequest,
  ) async {}

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
    return _FakePlatformNavigationDelegate(params);
  }
}
