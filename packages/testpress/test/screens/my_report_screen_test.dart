import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:testpress/screens/my_report_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class _FakePlatformWebViewController extends PlatformWebViewController {
  _FakePlatformWebViewController(super.params) : super.implementation();

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {}

  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {}

  @override
  Future<void> setUserAgent(String? userAgent) async {}

  @override
  Future<String?> getUserAgent() async => 'MockUserAgent';

  @override
  Future<void> setOnConsoleMessage(
    void Function(JavaScriptConsoleMessage consoleMessage) onConsoleMessage,
  ) async {}

  @override
  Future<void> loadRequest(LoadRequestParams params) async {}
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

class FakeUserRepository extends Fake implements UserRepository {
  final String ssoPath;
  final bool shouldThrow;

  FakeUserRepository({
    this.ssoPath = '/sso/test-token/',
    this.shouldThrow = false,
  });

  @override
  Future<String> getPresignedSsoUrl() async {
    if (shouldThrow) {
      throw Exception('SSO failure');
    }
    return ssoPath;
  }
}

void main() {
  setUpAll(() {
    WebViewPlatform.instance = _FakeWebViewPlatform();
  });

  Widget wrap(Widget child, {List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: overrides,
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

  group('reportUrlProvider', () {
    test('constructs SSO URL with presigned token and report target', () async {
      final container = ProviderContainer(
        overrides: [
          instituteSettingsProvider.overrideWith(
            (ref) => InstituteSettings.fromJson(const {
              'domain_url': 'https://test.testpress.in',
            }),
          ),
          userRepositoryProvider.overrideWith(
            (ref) async => FakeUserRepository(ssoPath: '/sso/test-token/'),
          ),
        ],
      );
      addTearDown(container.dispose);

      final url = await container.read(reportUrlProvider.future);
      expect(url, contains('https://test.testpress.in/sso/test-token/'));
      expect(url, contains('next=%2Freport%2F'));
    });
  });

  group('MyReportScreen', () {
    testWidgets('renders AppLoadingIndicator while resolving SSO URL', (
      tester,
    ) async {
      final completer = Completer<String>();
      final overrides = [
        instituteSettingsProvider.overrideWith((ref) => null),
        reportUrlProvider.overrideWith((ref) => completer.future),
      ];

      await tester.pumpWidget(
        wrap(const MyReportScreen(), overrides: overrides),
      );
      expect(find.byType(AppLoadingIndicator), findsOneWidget);
    });

    testWidgets('renders AppErrorView when SSO URL fetch fails', (
      tester,
    ) async {
      final overrides = [
        instituteSettingsProvider.overrideWith((ref) => null),
        reportUrlProvider.overrideWith((ref) {
          return Future<String>.error(Exception('Failed to load'));
        }),
      ];

      await tester.pumpWidget(
        wrap(const MyReportScreen(), overrides: overrides),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppErrorView), findsOneWidget);
    });

    testWidgets('renders AppWebView when SSO URL is resolved', (tester) async {
      const resolvedUrl =
          'https://test.testpress.in/sso/token/?next=%2Freport%2F';
      final overrides = [
        instituteSettingsProvider.overrideWith((ref) => null),
        reportUrlProvider.overrideWith((ref) => resolvedUrl),
      ];

      await tester.pumpWidget(
        wrap(const MyReportScreen(), overrides: overrides),
      );
      await tester.pump();

      expect(find.byType(AppWebView), findsOneWidget);
      final webView = tester.widget<AppWebView>(find.byType(AppWebView));
      expect(webView.url, resolvedUrl);
    });
  });
}
