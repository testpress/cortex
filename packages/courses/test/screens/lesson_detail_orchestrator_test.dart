import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:courses/screens/lesson_detail_orchestrator.dart';
import 'package:courses/widgets/lesson_detail/ask_doubt_fab.dart';
import 'package:courses/widgets/lesson_detail/lesson_detail_skeleton.dart';

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

    testWidgets('expired notes lesson does not show mark as completed',
        (tester) async {
      const expiredNotes = LessonDto(
        id: '102',
        chapterId: 'chapter-1',
        title: 'Expired Notes',
        type: LessonType.notes,
        progressStatus: LessonProgressStatus.notStarted,
        duration: '5 min',
        orderIndex: 2,
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
      );

      await tester.pumpWidget(wrap(
        const LessonDetailOrchestrator(
          lesson: expiredNotes,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Mark as completed'), findsNothing);
      expect(find.text('Completed'), findsNothing);
      expect(find.byType(AskDoubtFab), findsNothing);
      expect(find.text('Access expired'), findsOneWidget);
    });

    testWidgets('locked lesson shows locked message, lock icon, and no FAB',
        (tester) async {
      var nextClicked = false;
      var prevClicked = false;

      const lockedVideo = LessonDto(
        id: '103',
        chapterId: 'chapter-1',
        title: 'Locked Video Lesson',
        type: LessonType.video,
        progressStatus: LessonProgressStatus.notStarted,
        duration: '20 min',
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
        bookmarkId: 42,
      );

      await tester.pumpWidget(wrap(
        LessonDetailOrchestrator(
          lesson: lockedVideo,
          onNext: () => nextClicked = true,
          onPrevious: () => prevClicked = true,
        ),
      ));
      await tester.pumpAndSettle();

      // Should NOT render skeleton loader
      expect(find.byType(LessonDetailSkeleton), findsNothing);

      // Should render lock icon and message
      expect(find.byIcon(LucideIcons.lock), findsOneWidget);
      expect(find.text('This content is Locked'), findsOneWidget);
      expect(
        find.text(
          'To access the contents of this page, ensure you have successfully completed the previous content.',
        ),
        findsOneWidget,
      );

      // Should NOT render bookmark, complete, or FAB
      expect(find.byIcon(LucideIcons.bookmark), findsNothing);
      expect(find.byIcon(LucideIcons.bookmarkOff), findsNothing);
      expect(find.text('Completed'), findsNothing);
      expect(find.text('Mark as completed'), findsNothing);
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
}
