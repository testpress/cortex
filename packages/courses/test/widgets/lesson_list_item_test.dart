import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:courses/courses.dart';

void main() {
  Widget wrap(Widget child) {
    return DesignProvider(
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
    );
  }

  group('LessonListItem Expiry', () {
    final expiredLesson = LessonDto(
      id: '1',
      chapterId: '1',
      title: 'Expired Lesson',
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
    );

    testWidgets('shows lock icon and blocks tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrap(LessonListItem(
        lesson: expiredLesson,
        onTap: () => tapped = true,
      )));
      await tester.pumpAndSettle();

      expect(find.byIcon(LucideIcons.calendarClock), findsOneWidget);

      await tester.tap(find.byType(AppFocusable));
      await tester.pump(const Duration(seconds: 4));

      expect(tapped, isFalse);
    });

    testWidgets(
        'does not show completed badge for in-progress test with hasAttempts=true',
        (tester) async {
      final inProgressExam = LessonDto(
        id: '2',
        chapterId: '1',
        title: 'Midterm Exam',
        type: LessonType.test,
        progressStatus: LessonProgressStatus.inProgress,
        duration: '60 min',
        orderIndex: 2,
        hasEnded: false,
        isLocked: false,
        pausedAttemptsCount: 0,
        disableAttemptResume: false,
        allowRetake: false,
        maxRetakes: 0,
        hasAttempts: true,
        isRunning: false,
        isUpcoming: false,
        isDetailFetched: false,
      );

      await tester.pumpWidget(wrap(LessonListItem(
        lesson: inProgressExam,
        onTap: () {},
      )));
      await tester.pumpAndSettle();

      expect(find.byIcon(LucideIcons.check), findsNothing);
    });
  });

  group('LessonListItem Progressive Lock', () {
    final lockedExam = LessonDto(
      id: '20',
      chapterId: '1',
      title: 'Locked Exam',
      type: LessonType.test,
      progressStatus: LessonProgressStatus.notStarted,
      duration: '60 min',
      orderIndex: 2,
      hasEnded: false,
      isLocked: true,
      hasAttempts: false,
    );

    testWidgets('shows LucideIcons.lock and blocks tap with error toast',
        (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrap(LessonListItem(
        lesson: lockedExam,
        onTap: () => tapped = true,
      )));
      await tester.pumpAndSettle();

      expect(find.byIcon(LucideIcons.lock), findsOneWidget);

      await tester.tap(find.byType(AppFocusable));
      await tester.pump();
      expect(find.text('Complete previous content to unlock'), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));

      expect(tapped, isFalse);
    });
  });

  group('LessonListItem Duration', () {
    testWidgets('shows duration when present', (tester) async {
      final lessonWithDuration = LessonDto(
        id: '30',
        chapterId: '1',
        title: 'Video Lesson',
        type: LessonType.video,
        progressStatus: LessonProgressStatus.notStarted,
        duration: '32 min',
        orderIndex: 1,
        hasEnded: false,
        isLocked: false,
        hasAttempts: false,
      );

      await tester.pumpWidget(wrap(LessonListItem(
        lesson: lessonWithDuration,
        onTap: () {},
      )));
      await tester.pumpAndSettle();

      expect(find.text('32 min'), findsOneWidget);
    });

    testWidgets('shows duration and in-progress status badge together',
        (tester) async {
      final inProgressLesson = LessonDto(
        id: '31',
        chapterId: '1',
        title: 'In Progress Video',
        type: LessonType.video,
        progressStatus: LessonProgressStatus.inProgress,
        duration: '45 min',
        orderIndex: 2,
        hasEnded: false,
        isLocked: false,
        hasAttempts: false,
      );

      await tester.pumpWidget(wrap(LessonListItem(
        lesson: inProgressLesson,
        onTap: () {},
      )));
      await tester.pumpAndSettle();

      expect(find.text('45 min'), findsOneWidget);
      expect(find.text('In Progress'), findsOneWidget);
    });

    testWidgets('does not show duration text when duration is empty',
        (tester) async {
      final lessonWithoutDuration = LessonDto(
        id: '32',
        chapterId: '1',
        title: 'PDF Lesson',
        type: LessonType.pdf,
        progressStatus: LessonProgressStatus.notStarted,
        duration: '',
        orderIndex: 3,
        hasEnded: false,
        isLocked: false,
        hasAttempts: false,
      );

      await tester.pumpWidget(wrap(LessonListItem(
        lesson: lessonWithoutDuration,
        onTap: () {},
      )));
      await tester.pumpAndSettle();

      expect(find.text('min'), findsNothing);
      expect(find.textContaining('min'), findsNothing);
    });
  });
}
