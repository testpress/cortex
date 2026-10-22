import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/widgets/lesson_detail/video_conference_viewer.dart';
import 'package:courses/widgets/lesson_detail/zoom_web_view.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
  });
}
