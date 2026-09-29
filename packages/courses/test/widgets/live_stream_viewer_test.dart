import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:courses/courses.dart';
import 'package:courses/repositories/course_repository.dart';
import 'package:courses/widgets/lesson_detail/live_stream_viewer.dart';
import 'package:courses/widgets/lesson_detail/fermion_lobby_view.dart';
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

class FakeCourseRepository extends Fake implements CourseRepository {
  int refreshLessonCallCount = 0;
  String? lastRefreshedLessonId;

  @override
  Future<LessonDto> refreshLesson(String lessonId) async {
    refreshLessonCallCount++;
    lastRefreshedLessonId = lessonId;
    return LessonDto(
      id: lessonId,
      chapterId: '10',
      title: 'Refreshed Lesson',
      type: LessonType.liveStream,
      progressStatus: LessonProgressStatus.notStarted,
      orderIndex: 0,
      duration: '60 min',
      isLocked: false,
    );
  }
}

void main() {
  setUpAll(() {
    WebViewPlatform.instance = _FakeWebViewPlatform();
  });

  Widget wrap(
    Widget child, {
    List<Override> overrides = const [],
    bool isDark = false,
  }) {
    return ProviderScope(
      overrides: overrides,
      child: DesignProvider(
        config: isDark
            ? DesignConfig.defaults().copyWith(isDark: true)
            : DesignConfig.defaults(),
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

  final testFermionRunningLesson = LessonDto(
    id: '1',
    chapterId: '10',
    title: 'Fermion Live Session',
    type: LessonType.liveStream,
    progressStatus: LessonProgressStatus.notStarted,
    orderIndex: 0,
    duration: '60 min',
    isLocked: false,
    contentUrl: 'https://fermion.embed/1',
    liveStreamProvider: 'Fermion',
    streamStatus: 'running',
    start: '2026-08-10T11:38:00Z',
  );

  final testFermionScheduledLesson = LessonDto(
    id: '2',
    chapterId: '10',
    title: 'Scheduled Fermion Session',
    type: LessonType.liveStream,
    progressStatus: LessonProgressStatus.notStarted,
    orderIndex: 1,
    duration: '60 min',
    isLocked: false,
    liveStreamProvider: 'Fermion',
    streamStatus: 'scheduled',
    isScheduled: true,
    scheduledMessage: 'This content will be unlocked soon.',
  );

  final testTpStreamsRunningLesson = LessonDto(
    id: '3',
    chapterId: '10',
    title: 'TpStreams Session',
    type: LessonType.liveStream,
    progressStatus: LessonProgressStatus.notStarted,
    orderIndex: 2,
    duration: '60 min',
    isLocked: false,
    contentUrl: 'tp-asset-123',
    liveStreamProvider: 'TpStreams',
    streamStatus: 'running',
  );

  final testTpStreamsWithChatLesson = LessonDto(
    id: '4',
    chapterId: '10',
    title: 'TpStreams Session with Live Chat',
    type: LessonType.liveStream,
    progressStatus: LessonProgressStatus.notStarted,
    orderIndex: 3,
    duration: '60 min',
    isLocked: false,
    contentUrl: 'tp-asset-123',
    liveStreamProvider: 'TpStreams',
    streamStatus: 'running',
    chatEmbedUrl: 'https://example.com/live/chat',
  );

  final testYouTubeLiveStreamLesson = LessonDto(
    id: '5',
    chapterId: '10',
    title: 'YouTube Live Session',
    type: LessonType.liveStream,
    progressStatus: LessonProgressStatus.notStarted,
    orderIndex: 4,
    duration: '60 min',
    isLocked: false,
    contentUrl: 'tp-asset-123',
    liveStreamProvider: 'TpStreams',
    streamStatus: 'running',
    chatEmbedUrl: 'https://www.youtube.com/live_chat?v=abc123xyz',
  );

  group('LiveStreamViewer Gating & Routing', () {
    testWidgets('renders FermionLobbyView for running Fermion session',
        (tester) async {
      await tester
          .pumpWidget(wrap(LiveStreamViewer(lesson: testFermionRunningLesson)));
      await tester.pumpAndSettle();

      expect(find.byType(FermionLobbyView), findsOneWidget);
      expect(find.text('Attend Class'), findsOneWidget);
    });

    testWidgets('renders ScheduledMessageView for scheduled Fermion session',
        (tester) async {
      await tester.pumpWidget(
          wrap(LiveStreamViewer(lesson: testFermionScheduledLesson)));
      await tester.pumpAndSettle();

      expect(find.byType(ScheduledMessageView), findsOneWidget);
      expect(find.text('This content will be unlocked soon.'), findsOneWidget);
      expect(find.byType(FermionLobbyView), findsNothing);

      // Unmount widget to cancel periodic polling timer cleanly
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('renders inline player for TpStreams session without chat',
        (tester) async {
      await tester.pumpWidget(
          wrap(LiveStreamViewer(lesson: testTpStreamsRunningLesson)));
      await tester.pumpAndSettle();

      expect(find.byType(FermionLobbyView), findsNothing);
      expect(find.byType(ScheduledMessageView), findsNothing);
      expect(find.byType(AppWebView), findsNothing);
      expect(find.byType(ColoredBox), findsOneWidget);
    });

    testWidgets('renders AppWebView with theme=light in light mode',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          LiveStreamViewer(lesson: testTpStreamsWithChatLesson),
          isDark: false,
        ),
      );
      await tester.pump();

      expect(find.byType(FermionLobbyView), findsNothing);
      expect(find.byType(ScheduledMessageView), findsNothing);
      expect(find.byType(AppWebView), findsOneWidget);
      final webView = tester.widget<AppWebView>(find.byType(AppWebView));
      expect(webView.url, 'https://example.com/live/chat?theme=light');
      expect(webView.showHeader, isFalse);
      expect(webView.useSafeArea, isFalse);
    });

    testWidgets('renders AppWebView with theme=dark in dark mode',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          LiveStreamViewer(lesson: testTpStreamsWithChatLesson),
          isDark: true,
        ),
      );
      await tester.pump();

      expect(find.byType(AppWebView), findsOneWidget);
      final webView = tester.widget<AppWebView>(find.byType(AppWebView));
      expect(webView.url, 'https://example.com/live/chat?theme=dark');
    });

    testWidgets('renders AppWebView with dark_theme=1 for YouTube in dark mode',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          LiveStreamViewer(lesson: testYouTubeLiveStreamLesson),
          isDark: true,
        ),
      );
      await tester.pump();

      expect(find.byType(AppWebView), findsOneWidget);
      final webView = tester.widget<AppWebView>(find.byType(AppWebView));
      expect(
        webView.url,
        'https://www.youtube.com/live_chat?v=abc123xyz&theme=dark&dark_theme=1',
      );
    });

    testWidgets('falls back to raw chatEmbedUrl when URL is malformed',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      const malformedUrl = 'https://example.com:abc/chat';
      final malformedLesson = testTpStreamsRunningLesson.copyWith(
        chatEmbedUrl: malformedUrl,
      );

      await tester.pumpWidget(
        wrap(LiveStreamViewer(lesson: malformedLesson)),
      );
      await tester.pump();

      expect(find.byType(AppWebView), findsOneWidget);
      final webView = tester.widget<AppWebView>(find.byType(AppWebView));
      expect(webView.url, malformedUrl);
    });
  });

  group('LiveStreamViewer Polling', () {
    testWidgets('polls refreshLesson every 5 seconds while scheduled',
        (tester) async {
      final fakeRepo = FakeCourseRepository();
      await tester.pumpWidget(
        wrap(
          LiveStreamViewer(lesson: testFermionScheduledLesson),
          overrides: [
            courseRepositoryProvider.overrideWith((ref) async => fakeRepo),
          ],
        ),
      );
      await tester.pump();

      expect(fakeRepo.refreshLessonCallCount, 0);

      // Advance clock by 5 seconds to trigger first periodic poll
      await tester.pump(const Duration(seconds: 5));
      expect(fakeRepo.refreshLessonCallCount, 1);
      expect(fakeRepo.lastRefreshedLessonId, '2');

      // Advance clock by another 5 seconds to trigger second poll
      await tester.pump(const Duration(seconds: 5));
      expect(fakeRepo.refreshLessonCallCount, 2);

      // Clean up timer by unmounting widget
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('cancels polling timer when isScheduled becomes false',
        (tester) async {
      final fakeRepo = FakeCourseRepository();
      final scheduledViewer =
          LiveStreamViewer(lesson: testFermionScheduledLesson);
      final runningViewer = LiveStreamViewer(lesson: testFermionRunningLesson);

      await tester.pumpWidget(
        wrap(
          scheduledViewer,
          overrides: [
            courseRepositoryProvider.overrideWith((ref) async => fakeRepo),
          ],
        ),
      );
      await tester.pump();

      await tester.pump(const Duration(seconds: 5));
      expect(fakeRepo.refreshLessonCallCount, 1);

      // Update widget with non-scheduled lesson
      await tester.pumpWidget(
        wrap(
          runningViewer,
          overrides: [
            courseRepositoryProvider.overrideWith((ref) async => fakeRepo),
          ],
        ),
      );
      await tester.pump();

      // Advance time by 5 more seconds; no new refresh call should occur
      await tester.pump(const Duration(seconds: 5));
      expect(fakeRepo.refreshLessonCallCount, 1);
    });
  });

  group('FermionLobbyView Metadata and Semantics', () {
    testWidgets('groups duration and start time inside semantic container',
        (tester) async {
      await tester
          .pumpWidget(wrap(FermionLobbyView(lesson: testFermionRunningLesson)));
      await tester.pumpAndSettle();

      // Find by semantics label on the grouped metadata card
      final semanticsFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label != null &&
            widget.properties.label!.contains('Session details:') &&
            widget.properties.label!.contains('Duration: 60 minutes'),
      );

      expect(semanticsFinder, findsOneWidget);
    });

    testWidgets(
        'allows video orientations on attend class and restores device default orientations on pop',
        (tester) async {
      final log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
        log.add(call);
        return null;
      });

      await tester.pumpWidget(
        wrap(
          Navigator(
            onGenerateRoute: (settings) => AppRoute(
              page: FermionLobbyView(lesson: testFermionRunningLesson),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final attendButton = find.text('Attend Class');
      expect(attendButton, findsOneWidget);

      await tester.tap(attendButton);
      await tester.pumpAndSettle();

      expect(
        log.any(
          (c) =>
              c.method == 'SystemChrome.setPreferredOrientations' &&
              (c.arguments as List).contains('DeviceOrientation.landscapeLeft'),
        ),
        isTrue,
      );

      final backButton = find.byType(AppBackButton);
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(
        log.last.method == 'SystemChrome.setPreferredOrientations',
        isTrue,
      );
    });
  });
}
