import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:profile/profile.dart';
import 'package:testpress/screens/student_notes_screen.dart';
import 'package:testpress/providers/student_notes_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
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

  @override
  Future<String> getAuthenticatedSsoUrl({
    required String nextPath,
    String? domainUrl,
    String? apiBaseUrl,
  }) async {
    final path = await getPresignedSsoUrl();
    return buildAuthenticatedSsoUrl(
      ssoPath: path,
      nextPath: nextPath,
      domainUrl: domainUrl,
      apiBaseUrl: apiBaseUrl,
    );
  }
}

class _MockUrlLauncherPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {
  bool launchUrlResult = true;
  bool shouldThrow = false;
  String? launchedUrl;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launchedUrl = url;
    if (shouldThrow) {
      throw Exception('Launch failed');
    }
    return launchUrlResult;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late UrlLauncherPlatform originalUrlLauncher;
  late _MockUrlLauncherPlatform mockUrlLauncher;

  setUpAll(() {
    WebViewPlatform.instance = _FakeWebViewPlatform();
  });

  setUp(() {
    originalUrlLauncher = UrlLauncherPlatform.instance;
    mockUrlLauncher = _MockUrlLauncherPlatform();
    UrlLauncherPlatform.instance = mockUrlLauncher;
  });

  tearDown(() {
    UrlLauncherPlatform.instance = originalUrlLauncher;
  });

  Widget wrap(Widget child, {List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: [
        designModeProvider.overrideWithValue(DesignMode.system),
        ...overrides,
      ],
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
                  child: Overlay(
                    initialEntries: [OverlayEntry(builder: (_) => child)],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  group('studentNotesUrlProvider', () {
    test(
      'constructs SSO URL with presigned token and student notes target',
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
            designModeProvider.overrideWithValue(DesignMode.system),
          ],
        );
        addTearDown(container.dispose);

        final url = await container.read(studentNotesUrlProvider.future);
        expect(url, contains('https://test.testpress.in/sso/test-token/'));
        expect(
          url,
          contains('next=%2Fstudent-diary%2Fmy-notes%2F%3Ftestpress_app%3D1'),
        );
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
            designModeProvider.overrideWithValue(DesignMode.system),
          ],
        );
        addTearDown(container.dispose);

        final url = await container.read(studentNotesUrlProvider.future);
        expect(
          url,
          contains(
            '/sso/test-token/?next=%2Fstudent-diary%2Fmy-notes%2F%3Ftestpress_app%3D1',
          ),
        );
      },
    );

    test('appends theme query parameter when designMode is dark', () async {
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
          designModeProvider.overrideWithValue(DesignMode.dark),
        ],
      );
      addTearDown(container.dispose);

      final url = await container.read(studentNotesUrlProvider.future);
      expect(url, contains('theme%3Ddark'));
    });
  });

  group('StudentNotesScreen', () {
    testWidgets('renders AppLoadingIndicator while resolving SSO URL', (
      tester,
    ) async {
      final completer = Completer<String>();
      final overrides = [
        instituteSettingsProvider.overrideWith((ref) => null),
        studentNotesUrlProvider.overrideWith((ref) => completer.future),
      ];

      await tester.pumpWidget(
        wrap(const StudentNotesScreen(), overrides: overrides),
      );

      expect(find.byType(AppLoadingIndicator), findsOneWidget);
      expect(find.byType(AppWebView), findsNothing);
    });

    testWidgets('renders AppErrorView when SSO URL fetch fails', (
      tester,
    ) async {
      final overrides = [
        instituteSettingsProvider.overrideWith((ref) => null),
        studentNotesUrlProvider.overrideWith((ref) {
          return Future<String>.error(Exception('Failed to load'));
        }),
      ];

      await tester.pumpWidget(
        wrap(const StudentNotesScreen(), overrides: overrides),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppErrorView), findsOneWidget);
      expect(find.byType(AppWebView), findsNothing);
    });

    testWidgets('renders AppWebView with resolved URL and default header title', (
      tester,
    ) async {
      const resolvedUrl =
          'https://test.testpress.in/sso/token/?next=%2Fstudent-diary%2Fmy-notes%2F%3Ftestpress_app%3D1';
      final overrides = [
        instituteSettingsProvider.overrideWith((ref) => null),
        studentNotesUrlProvider.overrideWith((ref) => resolvedUrl),
      ];

      await tester.pumpWidget(
        wrap(const StudentNotesScreen(), overrides: overrides),
      );
      await tester.pump();

      expect(find.byType(AppWebView), findsOneWidget);
      expect(find.byType(AppLoadingIndicator), findsNothing);

      final webView = tester.widget<AppWebView>(find.byType(AppWebView));
      expect(webView.url, resolvedUrl);
      expect(find.text('Notes'), findsOneWidget);
    });

    testWidgets('uses custom studentNotesLabel when provided in settings', (
      tester,
    ) async {
      const resolvedUrl =
          'https://test.testpress.in/sso/token/?next=%2Fstudent-diary%2Fmy-notes%2F%3Ftestpress_app%3D1';
      final overrides = [
        instituteSettingsProvider.overrideWith(
          (ref) => InstituteSettings.fromJson(const {
            'student_notes_enabled': true,
            'student_notes_label': 'My Study Notes',
          }),
        ),
        studentNotesUrlProvider.overrideWith((ref) => resolvedUrl),
      ];

      await tester.pumpWidget(
        wrap(const StudentNotesScreen(), overrides: overrides),
      );
      await tester.pump();

      expect(find.text('My Study Notes'), findsOneWidget);
    });

    testWidgets(
      'passes onNavigationRequest that delegates external attachments to system',
      (tester) async {
        const resolvedUrl =
            'https://test.testpress.in/sso/token/?next=%2Fstudent-diary%2Fmy-notes%2F%3Ftestpress_app%3D1';
        final overrides = [
          instituteSettingsProvider.overrideWith((ref) => null),
          studentNotesUrlProvider.overrideWith((ref) => resolvedUrl),
        ];

        await tester.pumpWidget(
          wrap(const StudentNotesScreen(), overrides: overrides),
        );
        await tester.pump();

        final webView = tester.widget<AppWebView>(find.byType(AppWebView));
        expect(webView.onNavigationRequest, isNotNull);

        final inAppDecision = await webView.onNavigationRequest!(
          const NavigationRequest(
            url: 'https://test.testpress.in/student-diary/folders/123/',
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

        final malformedDecision = await webView.onNavigationRequest!(
          const NavigationRequest(url: 'ht tp://bad uri', isMainFrame: true),
        );
        expect(malformedDecision, NavigationDecision.prevent);

        expect(
          webView.permissions,
          equals(const [Permission.camera, Permission.storage]),
        );
      },
    );

    testWidgets('shows error AppToast when external URL launch fails', (
      tester,
    ) async {
      mockUrlLauncher.launchUrlResult = false;

      const resolvedUrl =
          'https://test.testpress.in/sso/token/?next=%2Fstudent-diary%2Fmy-notes%2F%3Ftestpress_app%3D1';
      final overrides = [
        instituteSettingsProvider.overrideWith((ref) => null),
        studentNotesUrlProvider.overrideWith((ref) => resolvedUrl),
      ];

      await tester.pumpWidget(
        wrap(const StudentNotesScreen(), overrides: overrides),
      );
      await tester.pump();

      final webView = tester.widget<AppWebView>(find.byType(AppWebView));
      expect(webView.onNavigationRequest, isNotNull);

      final externalDecision = await webView.onNavigationRequest!(
        const NavigationRequest(
          url: 'https://s3.amazonaws.com/testpress/uploads/attachment.pdf',
          isMainFrame: true,
        ),
      );
      expect(externalDecision, NavigationDecision.prevent);

      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Could not open the link'), findsOneWidget);

      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets(
      'shows error AppToast when external URL launch throws an exception',
      (tester) async {
        mockUrlLauncher.shouldThrow = true;

        const resolvedUrl =
            'https://test.testpress.in/sso/token/?next=%2Fstudent-diary%2Fmy-notes%2F%3Ftestpress_app%3D1';
        final overrides = [
          instituteSettingsProvider.overrideWith((ref) => null),
          studentNotesUrlProvider.overrideWith((ref) => resolvedUrl),
        ];

        await tester.pumpWidget(
          wrap(const StudentNotesScreen(), overrides: overrides),
        );
        await tester.pump();

        final webView = tester.widget<AppWebView>(find.byType(AppWebView));
        expect(webView.onNavigationRequest, isNotNull);

        final externalDecision = await webView.onNavigationRequest!(
          const NavigationRequest(
            url: 'https://s3.amazonaws.com/testpress/uploads/attachment.pdf',
            isMainFrame: true,
          ),
        );
        expect(externalDecision, NavigationDecision.prevent);

        await tester.pump(const Duration(milliseconds: 100));
        expect(find.text('Could not open the link'), findsOneWidget);

        await tester.pump(const Duration(seconds: 4));
      },
    );

    testWidgets(
      'applies bottom inset padding when keyboard viewInsets are present',
      (tester) async {
        const resolvedUrl =
            'https://test.testpress.in/sso/token/?next=%2Fstudent-diary%2Fmy-notes%2F%3Ftestpress_app%3D1';
        final overrides = [
          instituteSettingsProvider.overrideWith((ref) => null),
          studentNotesUrlProvider.overrideWith((ref) => resolvedUrl),
        ];

        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(
              viewInsets: EdgeInsets.only(bottom: 300),
            ),
            child: wrap(const StudentNotesScreen(), overrides: overrides),
          ),
        );
        await tester.pump();

        final paddingWidget = tester.widget<Padding>(
          find.byWidgetPredicate(
            (w) =>
                w is Padding && w.padding == const EdgeInsets.only(bottom: 300),
          ),
        );
        expect(paddingWidget.padding, const EdgeInsets.only(bottom: 300));
      },
    );
  });

  group('isAllowedStudentNotesInAppNavigation', () {
    const domainHost = 'test.testpress.in';

    test(
      'returns true for student notes application routes on the same host',
      () {
        expect(
          isAllowedStudentNotesInAppNavigation(
            Uri.parse(
              'https://test.testpress.in/student-diary/my-notes/?testpress_app=1',
            ),
            domainHost,
          ),
          isTrue,
        );
        expect(
          isAllowedStudentNotesInAppNavigation(
            Uri.parse('https://test.testpress.in/student-diary/folders/1/'),
            domainHost,
          ),
          isTrue,
        );
        expect(
          isAllowedStudentNotesInAppNavigation(
            Uri.parse('https://test.testpress.in/api/v3/student-notes/notes/'),
            domainHost,
          ),
          isTrue,
        );
      },
    );

    test('returns false for external cloud storage and attachment URLs', () {
      expect(
        isAllowedStudentNotesInAppNavigation(
          Uri.parse('https://testpress-data.s3.amazonaws.com/uploads/doc.pdf'),
          domainHost,
        ),
        isFalse,
      );
      expect(
        isAllowedStudentNotesInAppNavigation(
          Uri.parse('https://google.com'),
          domainHost,
        ),
        isFalse,
      );
    });

    test('returns false for pdf files even on notes route', () {
      expect(
        isAllowedStudentNotesInAppNavigation(
          Uri.parse('https://test.testpress.in/student-diary/doc.pdf'),
          domainHost,
        ),
        isFalse,
      );
    });

    test('returns false for non-student-diary routes on the same host', () {
      expect(
        isAllowedStudentNotesInAppNavigation(
          Uri.parse('https://test.testpress.in/courses/1/'),
          domainHost,
        ),
        isFalse,
      );
    });

    test('returns false for non-http/https schemes', () {
      expect(
        isAllowedStudentNotesInAppNavigation(
          Uri.parse('mailto:support@testpress.in'),
          domainHost,
        ),
        isFalse,
      );
    });
  });
}
