import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/widgets/lesson_detail/video_conference_viewer.dart';
import 'package:courses/widgets/lesson_detail/zoom_web_view.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'dart:async';
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
  Future<void> enableZoom(bool enabled) async {}

  @override
  Future<void> setBackgroundColor(Color color) async {}

  @override
  bool supportsSetScrollBarsEnabled() => false;

  @override
  Future<void> addJavaScriptChannel(
    JavaScriptChannelParams javaScriptChannelParams,
  ) async {}

  @override
  Future<void> setOnPlatformPermissionRequest(
    void Function(PlatformWebViewPermissionRequest request)
        onPlatformPermissionRequest,
  ) async {}

  @override
  Future<void> runJavaScript(String javaScript) async {}

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
  Future<void> setOnPageStarted(
      void Function(String url) onPageStarted) async {}

  @override
  Future<void> setOnPageFinished(
    void Function(String url) onPageFinished,
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
                  child: Navigator(
                    onGenerateRoute: (settings) => AppRoute(
                      page: child,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  group('VideoConferenceViewer — Zoom Web View Navigation', () {
    const liveZoomLesson = LessonDto(
      id: 'zoom-1',
      chapterId: 'ch-1',
      title: 'Live Zoom Class',
      type: LessonType.videoConference,
      progressStatus: LessonProgressStatus.notStarted,
      duration: '60 min',
      orderIndex: 1,
      isLocked: false,
      liveStreamProvider: 'zoom',
      streamStatus: 'running',
      conferenceId: '987654321',
      password: 'pass',
    );

    testWidgets('renders Attend Class button for running Zoom meeting',
        (tester) async {
      await tester.pumpWidget(wrap(
        const VideoConferenceViewer(lesson: liveZoomLesson),
      ));
      await tester.pump();

      expect(find.text('Attend Class'), findsOneWidget);
    });

    testWidgets('navigates to ZoomVideoConferenceScreen when attend tapped',
        (tester) async {
      await tester.pumpWidget(wrap(
        const VideoConferenceViewer(lesson: liveZoomLesson),
      ));
      await tester.pump();

      await tester.tap(find.text('Attend Class'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(ZoomVideoConferenceScreen), findsOneWidget);
    });

    testWidgets(
        'shows missing join link if Zoom conferenceId and contentUrl are missing',
        (tester) async {
      const brokenZoomLesson = LessonDto(
        id: 'zoom-2',
        chapterId: 'ch-1',
        title: 'Broken Zoom Class',
        type: LessonType.videoConference,
        progressStatus: LessonProgressStatus.notStarted,
        duration: '60 min',
        orderIndex: 1,
        isLocked: false,
        liveStreamProvider: 'zoom',
        streamStatus: 'running',
        conferenceId: null,
        contentUrl: null,
      );

      await tester.pumpWidget(wrap(
        const VideoConferenceViewer(lesson: brokenZoomLesson),
      ));
      await tester.pump();

      expect(find.text('Attend Class'), findsNothing);
      expect(find.text('Meeting link is missing'), findsOneWidget);
    });

    testWidgets(
        'ZoomVideoConferenceScreen triggers onMeetingExit when back is tapped',
        (tester) async {
      bool exited = false;
      await tester.pumpWidget(wrap(
        ZoomVideoConferenceScreen(
          joinUrl: 'https://app.zoom.us/wc/12345/join',
          title: 'Live Class',
          onMeetingExit: () => exited = true,
        ),
      ));
      await tester.pump();

      final backButton = find.byType(LessonDetailShell);
      expect(backButton, findsOneWidget);

      final shell = tester.widget<LessonDetailShell>(backButton);
      shell.onBack?.call();
      expect(exited, isTrue);
    });
  });
}
