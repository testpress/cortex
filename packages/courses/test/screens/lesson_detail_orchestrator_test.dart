import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:courses/screens/lesson_detail_orchestrator.dart';
import 'package:courses/widgets/lesson_detail/ask_doubt_fab.dart';
import 'package:courses/widgets/lesson_detail/lesson_detail_skeleton.dart';
import 'package:courses/widgets/lesson_detail/live_stream_viewer.dart';
import 'package:courses/widgets/lesson_detail/video_conference_viewer.dart';

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
                  child: Overlay(
                    initialEntries: [
                      OverlayEntry(builder: (context) => child),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  group('LessonDetailOrchestrator Expiry', () {
    const expiredLesson = LessonDto(
      id: '101',
      chapterId: 'chapter-1',
      title: 'Expired Video Lesson',
      type: LessonType.video,
      progressStatus: LessonProgressStatus.notStarted,
      duration: '10 min',
      orderIndex: 1,
      hasEnded: true,
      isLocked: false,
      pausedAttemptsCount: 0,
      disableAttemptResume: false,
      allowRetake: false,
      maxRetakes: 0,
      hasAttempts: false,
      isRunning: false,
      isUpcoming: false,
      isDetailFetched: false,
      end: '2023-12-31T23:59:59Z',
      bookmarkId: 99,
    );

    testWidgets('shows expired message and icon instead of skeleton loader',
        (tester) async {
      var nextClicked = false;
      var prevClicked = false;

      await tester.pumpWidget(wrap(
        LessonDetailOrchestrator(
          lesson: expiredLesson,
          onNext: () => nextClicked = true,
          onPrevious: () => prevClicked = true,
        ),
      ));
      await tester.pumpAndSettle();

      // Should NOT render skeleton loader
      expect(find.byType(LessonDetailSkeleton), findsNothing);

      // Should render expiration icon and message
      expect(find.byIcon(LucideIcons.calendarClock), findsOneWidget);
      expect(find.text('Access expired'), findsOneWidget);
      expect(find.textContaining('Access expired on'), findsOneWidget);

      // Should NOT render bookmark or completed action
      expect(find.byIcon(LucideIcons.bookmark), findsNothing);
      expect(find.byIcon(LucideIcons.bookmarkOff), findsNothing);
      expect(find.text('Completed'), findsNothing);
      expect(find.text('Mark as completed'), findsNothing);

      // Should NOT render Ask Doubt FAB
      expect(find.byType(AskDoubtFab), findsNothing);

      // Footer Next / Previous should be rendered and functional
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Previous'), findsOneWidget);

      await tester.tap(find.text('Next'));
      await tester.pump();
      expect(nextClicked, isTrue);

      await tester.tap(find.text('Previous'));
      await tester.pump();
      expect(prevClicked, isTrue);
    });
  });

  group('LessonDetailOrchestrator Error Handling', () {
    const incompleteLesson = LessonDto(
      id: '102',
      chapterId: 'chapter-1',
      title: 'Incomplete Lesson with Error',
      type: LessonType.video,
      progressStatus: LessonProgressStatus.notStarted,
      duration: '10 min',
      orderIndex: 2,
      isLocked: false,
      isDetailFetched: false,
    );

    testWidgets(
        'shows AppErrorView with header and title when error is present',
        (tester) async {
      var retryClicked = false;

      await tester.pumpWidget(wrap(
        LessonDetailOrchestrator(
          lesson: incompleteLesson,
          error: const ApiException(
            'Failed to load lesson',
            type: ApiErrorType.serverError,
          ),
          onRetry: () => retryClicked = true,
        ),
      ));
      await tester.pumpAndSettle();

      // Should render shell title
      expect(find.text('Incomplete Lesson with Error'), findsOneWidget);

      // Should NOT render skeleton loader
      expect(find.byType(LessonDetailSkeleton), findsNothing);

      // Should render AppErrorView with error message
      expect(find.byType(AppErrorView), findsOneWidget);
      expect(find.text('Failed to load lesson'), findsOneWidget);

      // Retry button should be functional
      expect(find.text('Retry'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      await tester.pump();
      expect(retryClicked, isTrue);
    });
  });

  group('LessonDetailOrchestrator Locked Content', () {
    const lockedLesson = LessonDto(
      id: '103',
      chapterId: 'chapter-1',
      title: 'Locked Video Lesson',
      type: LessonType.video,
      progressStatus: LessonProgressStatus.notStarted,
      duration: '10 min',
      orderIndex: 3,
      hasEnded: false,
      isLocked: true,
      pausedAttemptsCount: 0,
      disableAttemptResume: false,
      allowRetake: false,
      maxRetakes: 0,
      hasAttempts: false,
      isRunning: false,
      isUpcoming: false,
      isDetailFetched: false,
      bookmarkId: 99,
    );

    testWidgets('shows locked notice view instead of skeleton or error',
        (tester) async {
      var nextClicked = false;
      var prevClicked = false;

      await tester.pumpWidget(wrap(
        LessonDetailOrchestrator(
          lesson: lockedLesson,
          onNext: () => nextClicked = true,
          onPrevious: () => prevClicked = true,
        ),
      ));
      await tester.pumpAndSettle();

      // Should NOT render skeleton loader
      expect(find.byType(LessonDetailSkeleton), findsNothing);

      // Should render locked icon, title and message
      expect(find.byIcon(LucideIcons.lock), findsOneWidget);
      expect(find.text('Access Denied'), findsOneWidget);
      expect(find.text('Complete previous content to unlock'), findsOneWidget);

      // Should NOT render bookmark or completed action
      expect(find.byIcon(LucideIcons.bookmark), findsNothing);
      expect(find.byIcon(LucideIcons.bookmarkOff), findsNothing);
      expect(find.text('Completed'), findsNothing);
      expect(find.text('Mark as completed'), findsNothing);

      // Should NOT render Ask Doubt FAB
      expect(find.byType(AskDoubtFab), findsNothing);

      // Footer Next / Previous should be rendered and functional
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Previous'), findsOneWidget);

      await tester.tap(find.text('Next'));
      await tester.pump();
      expect(nextClicked, isTrue);

      await tester.tap(find.text('Previous'));
      await tester.pump();
      expect(prevClicked, isTrue);
    });
  });

  group('LessonDetailOrchestrator Scheduled Content', () {
    const scheduledMessage =
        'This content will be unlocked on 25th Sep 2026 03:26 AM.';
    const scheduledVideoLesson = LessonDto(
      id: '104',
      chapterId: 'chapter-1',
      title: 'Scheduled Video Lesson',
      type: LessonType.video,
      progressStatus: LessonProgressStatus.notStarted,
      duration: '10 min',
      orderIndex: 4,
      hasEnded: false,
      isLocked: false,
      isScheduled: true,
      scheduledMessage: scheduledMessage,
      pausedAttemptsCount: 0,
      disableAttemptResume: false,
      allowRetake: false,
      maxRetakes: 0,
      hasAttempts: false,
      isRunning: false,
      isUpcoming: false,
      isDetailFetched: true,
      bookmarkId: 99,
    );

    testWidgets('shows scheduled notice view for scheduled video lesson',
        (tester) async {
      var nextClicked = false;
      var prevClicked = false;

      await tester.pumpWidget(wrap(
        LessonDetailOrchestrator(
          lesson: scheduledVideoLesson,
          onNext: () => nextClicked = true,
          onPrevious: () => prevClicked = true,
        ),
      ));
      await tester.pumpAndSettle();

      // Should NOT render skeleton loader
      expect(find.byType(LessonDetailSkeleton), findsNothing);

      // Should render scheduled clock icon, title, and unlock message
      expect(find.byIcon(LucideIcons.calendarClock), findsOneWidget);
      expect(find.text('This content is scheduled'), findsOneWidget);
      expect(find.text(scheduledMessage), findsOneWidget);

      // Should NOT render bookmark or completed action
      expect(find.byIcon(LucideIcons.bookmark), findsNothing);
      expect(find.byIcon(LucideIcons.bookmarkOff), findsNothing);
      expect(find.text('Completed'), findsNothing);
      expect(find.text('Mark as completed'), findsNothing);

      // Should NOT render Ask Doubt FAB
      expect(find.byType(AskDoubtFab), findsNothing);

      // Footer Next / Previous should be rendered and functional
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Previous'), findsOneWidget);

      await tester.tap(find.text('Next'));
      await tester.pump();
      expect(nextClicked, isTrue);

      await tester.tap(find.text('Previous'));
      await tester.pump();
      expect(prevClicked, isTrue);
    });

    for (final type in [
      LessonType.embedContent,
      LessonType.notes,
      LessonType.attachment,
      LessonType.pdf,
    ]) {
      testWidgets(
          'shows scheduled notice view for scheduled ${type.name} lesson',
          (tester) async {
        final lesson = scheduledVideoLesson.copyWith(type: type);

        await tester.pumpWidget(wrap(
          LessonDetailOrchestrator(
            lesson: lesson,
          ),
        ));
        await tester.pumpAndSettle();

        expect(find.byIcon(LucideIcons.calendarClock), findsOneWidget);
        expect(find.text('This content is scheduled'), findsOneWidget);
        expect(find.text(scheduledMessage), findsOneWidget);
      });
    }

    testWidgets(
        'mounts LiveStreamViewer for scheduled liveStream lesson instead of generic notice',
        (tester) async {
      final lesson = scheduledVideoLesson.copyWith(
        type: LessonType.liveStream,
        contentUrl: 'https://example.com/stream',
      );

      await tester.pumpWidget(wrap(
        LessonDetailOrchestrator(
          lesson: lesson,
        ),
      ));
      await tester.pump();

      expect(find.byType(ContentNoticeView), findsNothing);
      expect(find.byType(LiveStreamViewer), findsOneWidget);
    });

    testWidgets(
        'mounts VideoConferenceViewer for scheduled videoConference lesson instead of generic notice',
        (tester) async {
      final lesson = scheduledVideoLesson.copyWith(
        type: LessonType.videoConference,
      );

      await tester.pumpWidget(wrap(
        LessonDetailOrchestrator(
          lesson: lesson,
        ),
      ));
      await tester.pump();

      expect(find.byType(ContentNoticeView), findsNothing);
      expect(find.byType(VideoConferenceViewer), findsOneWidget);
    });
  });
}
