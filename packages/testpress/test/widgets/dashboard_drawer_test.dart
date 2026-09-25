// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/courses.dart';
import 'package:testpress/widgets/dashboard_drawer.dart';
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

void main() {
  setUpAll(() {
    WebViewPlatform.instance = _FakeWebViewPlatform();
  });

  group('DashboardDrawer Privacy Policy Action', () {
    testWidgets(
      'tapping Privacy Policy closes drawer and navigates to PrivacyPolicyScreen',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
            isHomeDrawerOpenProvider.overrideWith((ref) => true),
            instituteSettingsProvider.overrideWith(
              (ref) => const InstituteSettings(
                domainUrl: 'https://academy.testpress.in',
                timezone: 'UTC',
                dashboardEnabled: true,
                leaderboardEnabled: false,
                leaderboardLabel: null,
                disableStudentAnalytics: false,
                allowedLoginMethods: [LoginMethod.formLogin],
                allowSignup: false,
                enableUserPhoto: false,
                allowProfileEdit: false,
                loginIdLabel: 'Username',
                loginPasswordLabel: 'Password',
                disableForgotPassword: true,
                enableParallelLoginRestriction: false,
                maxParallelLogins: 0,
                googleLoginEnabled: false,
                coursesEnabled: true,
                coursesLabel: 'Courses',
                contentsLabel: 'Contents',
                isVideoDownloadEnabled: false,
                activityFeedEnabled: false,
                enableCustomTest: false,
                postsEnabled: false,
                postsLabel: null,
                bookmarksEnabled: false,
                bookmarksLabel: null,
                forumEnabled: false,
                forumLabel: null,
                helpdeskEnabled: false,
                allowScreenshotInApp: false,
                storeEnabled: false,
                storeLabel: 'Store',
                currentPaymentApp: '',
                learnlensEnabled: false,
                disableStudentReport: false,
                qotdEnabled: false,
              ),
            ),
          ],
        );

        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: DesignProvider(
              config: DesignConfig.defaults(),
              child: LocalizationProvider(
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
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        builder(context),
                              ),
                      home: const DashboardDrawer(),
                    );
                  },
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Find the Privacy Policy item
        final privacyFinder = find.text('Privacy Policy');
        expect(privacyFinder, findsOneWidget);

        await tester.tap(privacyFinder);
        await tester.pumpAndSettle();

        // Verify drawer is closed
        expect(container.read(isHomeDrawerOpenProvider), isFalse);

        // Verify PrivacyPolicyScreen was pushed
        expect(find.byType(PrivacyPolicyScreen), findsOneWidget);
      },
    );
  });
}
