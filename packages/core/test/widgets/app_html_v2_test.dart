import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

void main() {
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
            home: DesignProvider(config: DesignConfig.defaults(), child: child),
          );
        },
      ),
    );
  }

  group('AppHtmlV2 Iframe Embed Support', () {
    testWidgets(
      'intercepts <iframe> and renders AppIframeView with 16:9 default',
      (tester) async {
        const html = '''
        <div>
          <p>Product introduction</p>
          <iframe src="https://www.youtube.com/embed/NlDHY1ckxf4" frameborder="0"></iframe>
        </div>
      ''';

        await tester.pumpWidget(wrap(const AppHtmlV2(data: html)));
        await tester.pump();

        final iframeFinder = find.byType(AppIframeView);
        expect(iframeFinder, findsOneWidget);

        final iframeWidget = tester.widget<AppIframeView>(iframeFinder);
        expect(iframeWidget.src, 'https://www.youtube.com/embed/NlDHY1ckxf4');
        expect(iframeWidget.aspectRatio, 16 / 9);
      },
    );

    testWidgets(
      'calculates custom aspect ratio from width and height attributes',
      (tester) async {
        const html = '''
        <iframe src="https://www.youtube.com/embed/12345" width="400" height="300"></iframe>
      ''';

        await tester.pumpWidget(wrap(const AppHtmlV2(data: html)));
        await tester.pump();

        final iframeFinder = find.byType(AppIframeView);
        expect(iframeFinder, findsOneWidget);

        final iframeWidget = tester.widget<AppIframeView>(iframeFinder);
        expect(iframeWidget.aspectRatio, 400 / 300);
      },
    );

    testWidgets('renders iframe from user product description HTML', (
      tester,
    ) async {
      const html = '''
<html><body><p>SMASH PYQs by Shubham Sir anchors Mains prep where it matters most: PYQs—because at least 60% of GS questions link directly or indirectly to them. From Oct 1 to Jan 31, cover all four GS papers with 600+ PYQs, alternate-day live answer writing, and micro-theme–wise “X-Factor” notes plus topper answers. Build structured content, master frameworks, and replicate proven presentations. See real PYQ linkages (GS1/GS2), repeated themes (RPA, Attorney General), and high hit ratios achieved via PYQ-centric strategy. Obtain a single-source workbook for each Microtheme and walk away with ready-made, high-quality answers.<br/>
 </p>
<p> </p>
<div>
<div><span class="embed-responsive embed-responsive-16by9 sm:w-3/4 block aspect-w-16 aspect-h-9 sm:aspect-h-7 sm:aspect-w-10"><iframe frameborder="0" height="310" src="https://www.youtube.com/embed/NlDHY1ckxf4?si=sgsPAMaX2xjOmBUw" width="560"></iframe> </span></div>
</div>
<p> </p>
<p> </p>
<p><strong>The most detailed course on PYQs </strong></p>
</body></html>
''';

      await tester.pumpWidget(
        wrap(SingleChildScrollView(child: AppHtmlV2(data: html))),
      );
      await tester.pump();

      final iframeFinder = find.byType(AppIframeView);
      expect(iframeFinder, findsOneWidget);

      final iframeWidget = tester.widget<AppIframeView>(iframeFinder);
      expect(
        iframeWidget.src,
        'https://www.youtube.com/embed/NlDHY1ckxf4?si=sgsPAMaX2xjOmBUw',
      );
      expect(iframeWidget.aspectRatio, 560 / 310);
    });

    testWidgets('ignores empty src iframe without crashing', (tester) async {
      const html = '''
        <iframe src="" frameborder="0"></iframe>
      ''';

      await tester.pumpWidget(wrap(const AppHtmlV2(data: html)));
      await tester.pump();

      expect(find.byType(AppIframeView), findsNothing);
    });

    group('AppHtmlV2.parseAspectRatio', () {
      test('calculates correct aspect ratio from positive numbers', () {
        expect(AppHtmlV2.parseAspectRatio('640', '360'), 640 / 360);
        expect(AppHtmlV2.parseAspectRatio('560', '315'), 560 / 315);
        expect(AppHtmlV2.parseAspectRatio('400', '300'), 4 / 3);
      });

      test('falls back to 16:9 for percentage dimensions', () {
        expect(AppHtmlV2.parseAspectRatio('100%', '300'), 16 / 9);
        expect(AppHtmlV2.parseAspectRatio('100%', '100%'), 16 / 9);
        expect(AppHtmlV2.parseAspectRatio('500', '100%'), 16 / 9);
      });

      test('falls back to 16:9 for null or empty dimensions', () {
        expect(AppHtmlV2.parseAspectRatio(null, null), 16 / 9);
        expect(AppHtmlV2.parseAspectRatio('640', null), 16 / 9);
        expect(AppHtmlV2.parseAspectRatio(null, '360'), 16 / 9);
        expect(AppHtmlV2.parseAspectRatio('', ''), 16 / 9);
      });

      test('falls back to 16:9 for zero, negative, or invalid dimensions', () {
        expect(AppHtmlV2.parseAspectRatio('0', '360'), 16 / 9);
        expect(AppHtmlV2.parseAspectRatio('640', '0'), 16 / 9);
        expect(AppHtmlV2.parseAspectRatio('-640', '360'), 16 / 9);
        expect(AppHtmlV2.parseAspectRatio('invalid', 'auto'), 16 / 9);
      });

      test('supports custom default ratio', () {
        expect(
          AppHtmlV2.parseAspectRatio(null, null, defaultRatio: 4 / 3),
          4 / 3,
        );
      });
    });
  });
}

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
