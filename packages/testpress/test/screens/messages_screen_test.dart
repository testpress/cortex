import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:testpress/screens/messages_screen.dart';
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

  group('messagesUrlProvider', () {
    test(
      'constructs SSO URL with presigned token and messages target',
      () async {
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

        final url = await container.read(messagesUrlProvider.future);
        expect(url, contains('https://test.testpress.in/sso/test-token/'));
        expect(url, contains('next=%2Fmessages%2F%3Ftestpress_app%3D1'));
      },
    );

    test(
      'falls back to AppConfig api base url when domainUrl is not set',
      () async {
        final container = ProviderContainer(
          overrides: [
            instituteSettingsProvider.overrideWith((ref) => null),
            userRepositoryProvider.overrideWith(
              (ref) async => FakeUserRepository(ssoPath: '/sso/test-token/'),
            ),
          ],
        );
        addTearDown(container.dispose);

        final url = await container.read(messagesUrlProvider.future);
        expect(
          url,
          contains('/sso/test-token/?next=%2Fmessages%2F%3Ftestpress_app%3D1'),
        );
      },
    );
  });

  group('MessagesScreen', () {
    testWidgets('renders AppLoadingIndicator while resolving SSO URL', (
      tester,
    ) async {
      final completer = Completer<String>();
      final overrides = [
        instituteSettingsProvider.overrideWith((ref) => null),
        messagesUrlProvider.overrideWith((ref) => completer.future),
      ];

      await tester.pumpWidget(
        wrap(const MessagesScreen(), overrides: overrides),
      );
      expect(find.byType(AppLoadingIndicator), findsOneWidget);
    });

    testWidgets('renders AppErrorView when SSO URL fetch fails', (
      tester,
    ) async {
      final overrides = [
        instituteSettingsProvider.overrideWith((ref) => null),
        messagesUrlProvider.overrideWith((ref) {
          return Future<String>.error(Exception('Failed to load'));
        }),
      ];

      await tester.pumpWidget(
        wrap(const MessagesScreen(), overrides: overrides),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppErrorView), findsOneWidget);
    });

    testWidgets('renders AppWebView with resolved URL and default header title', (
      tester,
    ) async {
      const resolvedUrl =
          'https://test.testpress.in/sso/token/?next=%2Fmessages%2F%3Ftestpress_app%3D1';
      final overrides = [
        instituteSettingsProvider.overrideWith((ref) => null),
        messagesUrlProvider.overrideWith((ref) => resolvedUrl),
      ];

      await tester.pumpWidget(
        wrap(const MessagesScreen(), overrides: overrides),
      );
      await tester.pump();

      expect(find.byType(AppWebView), findsOneWidget);
      final webView = tester.widget<AppWebView>(find.byType(AppWebView));
      expect(webView.url, resolvedUrl);
      expect(find.text('Chat with Us'), findsOneWidget);
    });

    testWidgets(
      'uses custom messagesLabel when configured in instituteSettings',
      (tester) async {
        const resolvedUrl =
            'https://test.testpress.in/sso/token/?next=%2Fmessages%2F%3Ftestpress_app%3D1';
        final overrides = [
          instituteSettingsProvider.overrideWith(
            (ref) => InstituteSettings.fromJson(const {
              'messages_enabled': true,
              'messages_label': 'Support Desk',
            }),
          ),
          messagesUrlProvider.overrideWith((ref) => resolvedUrl),
        ];

        await tester.pumpWidget(
          wrap(const MessagesScreen(), overrides: overrides),
        );
        await tester.pump();

        expect(find.text('Support Desk'), findsOneWidget);
      },
    );

    testWidgets(
      'passes onNavigationRequest that delegates external attachments to system',
      (tester) async {
        const resolvedUrl =
            'https://test.testpress.in/sso/token/?next=%2Fmessages%2F%3Ftestpress_app%3D1';
        final overrides = [
          instituteSettingsProvider.overrideWith((ref) => null),
          messagesUrlProvider.overrideWith((ref) => resolvedUrl),
        ];

        await tester.pumpWidget(
          wrap(const MessagesScreen(), overrides: overrides),
        );
        await tester.pump();

        final webView = tester.widget<AppWebView>(find.byType(AppWebView));
        expect(webView.onNavigationRequest, isNotNull);

        final inAppDecision = await webView.onNavigationRequest!(
          const NavigationRequest(
            url: 'https://test.testpress.in/messages/thread/123/',
            isMainFrame: true,
          ),
        );
        expect(inAppDecision, NavigationDecision.navigate);

        final externalDecision = await webView.onNavigationRequest!(
          const NavigationRequest(
            url: 'https://s3.amazonaws.com/testpress/uploads/attachment.pdf',
            isMainFrame: true,
          ),
        );
        expect(externalDecision, NavigationDecision.prevent);
      },
    );
  });

  group('isAllowedMessagesInAppNavigation', () {
    const domainHost = 'test.testpress.in';

    test('returns true for messages application routes on the same host', () {
      expect(
        isAllowedMessagesInAppNavigation(
          Uri.parse('https://test.testpress.in/messages/?testpress_app=1'),
          domainHost,
        ),
        isTrue,
      );
      expect(
        isAllowedMessagesInAppNavigation(
          Uri.parse('https://test.testpress.in/messages/conversations/45/'),
          domainHost,
        ),
        isTrue,
      );
      expect(
        isAllowedMessagesInAppNavigation(
          Uri.parse('https://test.testpress.in/api/v2.5/sso/token/'),
          domainHost,
        ),
        isTrue,
      );
    });

    test('returns false for external cloud storage and attachment URLs', () {
      expect(
        isAllowedMessagesInAppNavigation(
          Uri.parse('https://testpress-data.s3.amazonaws.com/uploads/doc.pdf'),
          domainHost,
        ),
        isFalse,
      );
      expect(
        isAllowedMessagesInAppNavigation(
          Uri.parse('https://cdn.testpress.in/private/messages/file.zip'),
          domainHost,
        ),
        isFalse,
      );
      expect(
        isAllowedMessagesInAppNavigation(
          Uri.parse('https://google.com'),
          domainHost,
        ),
        isFalse,
      );
    });

    test('returns false for media and pdf files even on the same host', () {
      expect(
        isAllowedMessagesInAppNavigation(
          Uri.parse('https://test.testpress.in/media/attachments/report.docx'),
          domainHost,
        ),
        isFalse,
      );
      expect(
        isAllowedMessagesInAppNavigation(
          Uri.parse('https://test.testpress.in/messages/doc.pdf'),
          domainHost,
        ),
        isFalse,
      );
    });

    test('returns false for non-http/https schemes', () {
      expect(
        isAllowedMessagesInAppNavigation(
          Uri.parse('mailto:support@testpress.in'),
          domainHost,
        ),
        isFalse,
      );
      expect(
        isAllowedMessagesInAppNavigation(
          Uri.parse('tel:1234567890'),
          domainHost,
        ),
        isFalse,
      );
    });
  });
}
