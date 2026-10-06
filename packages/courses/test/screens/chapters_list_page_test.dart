import 'dart:async';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/courses.dart';
import 'package:courses/widgets/study_content_list.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

void main() {
  setUpAll(() {
    WebViewPlatform.instance = _FakeWebViewPlatform();
  });

  Widget wrap(
    Widget child, {
    List<Override> overrides = const [],
    NavigatorObserver? navigatorObserver,
  }) {
    return ProviderScope(
      overrides: [
        authLocalDataSourceProvider.overrideWithValue(
          _FakeAuthLocalDataSource(),
        ),
        ...overrides,
      ],
      child: DesignProvider(
        config: DesignConfig.defaults(),
        child: LocalizationProvider(
          child: Builder(
            builder: (context) {
              final locale = LocalizationProvider.of(context).locale;
              return WidgetsApp(
                color: const Color(0xFFFFFFFF),
                locale: locale,
                localizationsDelegates: LocalizationProvider.delegates,
                navigatorObservers: [
                  if (navigatorObserver != null) navigatorObserver,
                ],
                pageRouteBuilder: <T>(settings, builder) => AppRoute<T>(
                  page: builder(context),
                  settings: settings,
                ),
                home: child,
              );
            },
          ),
        ),
      ),
    );
  }

  group('ChaptersListPage redirect guards', () {
    testWidgets(
        'redirects to CourseEnrollmentScreen exactly once despite multiple rebuilds',
        (tester) async {
      final navObserver = TestNavigatorObserver();
      final courseController = StreamController<CourseDto?>.broadcast();

      const approvalCourse = CourseDto(
        id: 'course-1',
        title: 'Approval Required Course',
        colorIndex: 1,
        chapterCount: 2,
        totalContents: 5,
        externalContentLink: 'https://example.com/sso/register?course=1',
        externalLinkLabel: 'REQUEST PACKAGE',
      );

      await tester.pumpWidget(
        wrap(
          const ChaptersListPage(courseId: 'course-1'),
          navigatorObserver: navObserver,
          overrides: [
            courseDetailProvider('course-1').overrideWith(
              (ref) => courseController.stream,
            ),
            subChaptersProvider('course-1', null).overrideWith(
              (ref) => Stream.value([]),
            ),
          ],
        ),
      );

      // Initial pump with no data yet
      await tester.pump();
      expect(navObserver.replaceCount, 0);

      // Emit approval course
      courseController.add(approvalCourse);
      await tester
          .pump(); // Triggers ref.listen and schedules postFrameCallback
      await tester.pump(); // Executes postFrameCallback (pushReplacement)

      expect(navObserver.replaceCount, 1);
      expect(find.byType(CourseEnrollmentScreen), findsOneWidget);

      // Emit more updates / trigger multiple rebuilds to simulate provider churn
      courseController.add(approvalCourse);
      await tester.pump();
      await tester.pump();

      courseController.add(approvalCourse);
      await tester.pump();
      await tester.pump();

      // Ensure the redirect was NEVER called more than once
      expect(navObserver.replaceCount, 1);
      expect(find.byType(CourseEnrollmentScreen), findsOneWidget);

      await courseController.close();
    });

    testWidgets(
        'does not redirect for normal courses and renders chapters list',
        (tester) async {
      final navObserver = TestNavigatorObserver();

      const normalCourse = CourseDto(
        id: 'course-2',
        title: 'Normal Accessible Course',
        colorIndex: 1,
        chapterCount: 1,
        totalContents: 2,
        externalContentLink: null,
        externalLinkLabel: null,
      );

      final testChapter = ChapterDto(
        id: 'chap-1',
        courseId: 'course-2',
        title: 'Chapter 1: Getting Started',
        lessonCount: 2,
        assessmentCount: 0,
        orderIndex: 0,
        isLeaf: true,
      );

      await tester.pumpWidget(
        wrap(
          const ChaptersListPage(courseId: 'course-2'),
          navigatorObserver: navObserver,
          overrides: [
            courseDetailProvider('course-2').overrideWith(
              (ref) => Stream.value(normalCourse),
            ),
            subChaptersProvider('course-2', null).overrideWith(
              (ref) => Stream.value([testChapter]),
            ),
          ],
        ),
      );

      await tester.pump();
      await tester.pump();

      expect(navObserver.replaceCount, 0);
      expect(find.byType(CourseEnrollmentScreen), findsNothing);
      expect(find.text('Chapter 1: Getting Started'), findsOneWidget);
    });

    testWidgets(
        'StudyContentList tapping approval course pushes CourseEnrollmentScreen to root navigator',
        (tester) async {
      final navObserver = TestNavigatorObserver();

      const approvalCourse = CourseDto(
        id: 'course-1',
        title: 'Approval Required Course',
        colorIndex: 1,
        chapterCount: 2,
        totalContents: 5,
        externalContentLink: 'https://example.com/sso/register?course=1',
        externalLinkLabel: 'REQUEST PACKAGE',
      );

      await tester.pumpWidget(
        wrap(
          CustomScrollView(
            slivers: [
              StudyContentList(
                enrolledCoursesState: const AsyncValue.data([approvalCourse]),
                isSyncingInitial: false,
                isSyncingMore: false,
                allLessons: const [],
                activeTypeFilters: const {},
                searchQuery: '',
              ),
            ],
          ),
          navigatorObserver: navObserver,
        ),
      );

      await tester.pumpAndSettle();
      expect(navObserver.pushCount, 1); // Initial home route pushed
      expect(find.byType(CourseEnrollmentScreen), findsNothing);

      // Tap the course card
      await tester.tap(find.text('Approval Required Course'));
      await tester.pumpAndSettle();

      expect(navObserver.pushCount,
          2); // CourseEnrollmentScreen pushed to root navigator
      expect(find.byType(CourseEnrollmentScreen), findsOneWidget);

      // Verify navigating back from enrollment screen lands back on StudyContentList
      Navigator.of(
        tester.element(find.byType(CourseEnrollmentScreen)),
        rootNavigator: true,
      ).pop();
      await tester.pumpAndSettle();

      expect(find.byType(CourseEnrollmentScreen), findsNothing);
      expect(find.byType(StudyContentList), findsOneWidget);
      expect(find.text('Approval Required Course'), findsOneWidget);
    });

    testWidgets(
        'redirect replaces ChaptersListPage on root navigator so pop returns to parent screen',
        (tester) async {
      final navObserver = TestNavigatorObserver();

      const approvalCourse = CourseDto(
        id: 'course-1',
        title: 'Approval Required Course',
        colorIndex: 1,
        chapterCount: 2,
        totalContents: 5,
        externalContentLink: 'https://example.com/sso/register?course=1',
        externalLinkLabel: 'REQUEST PACKAGE',
      );

      late BuildContext savedContext;

      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (ctx) {
              savedContext = ctx;
              return const Text('Parent Study Screen');
            },
          ),
          navigatorObserver: navObserver,
          overrides: [
            courseDetailProvider('course-1').overrideWith(
              (ref) => Stream.value(approvalCourse),
            ),
            subChaptersProvider('course-1', null).overrideWith(
              (ref) => Stream.value([]),
            ),
          ],
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Parent Study Screen'), findsOneWidget);

      // Push ChaptersListPage on the root navigator (mimicking route navigation)
      Navigator.of(savedContext, rootNavigator: true).push(
        AppRoute(page: const ChaptersListPage(courseId: 'course-1')),
      );

      // Pump to trigger build, postFrameCallback, and pushReplacement
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      // Verify CourseEnrollmentScreen replaced ChaptersListPage
      expect(find.byType(CourseEnrollmentScreen), findsOneWidget);
      expect(find.byType(ChaptersListPage), findsNothing);

      // Now pop from CourseEnrollmentScreen
      Navigator.of(
        tester.element(find.byType(CourseEnrollmentScreen)),
        rootNavigator: true,
      ).pop();
      await tester.pumpAndSettle();

      // Verify we land directly back on the Parent Study Screen (NOT on ChaptersListPage)
      expect(find.byType(CourseEnrollmentScreen), findsNothing);
      expect(find.byType(ChaptersListPage), findsNothing);
      expect(find.text('Parent Study Screen'), findsOneWidget);
    });
  });
}

class TestNavigatorObserver extends NavigatorObserver {
  int replaceCount = 0;
  int pushCount = 0;

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    replaceCount++;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    pushCount++;
  }
}

class _FakePlatformWebViewController extends PlatformWebViewController {
  _FakePlatformWebViewController(super.params) : super.implementation();

  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {}

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {}

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

class _FakeAuthLocalDataSource extends Fake implements AuthLocalDataSource {
  @override
  Future<String?> getToken() async => 'mock_token';
}
