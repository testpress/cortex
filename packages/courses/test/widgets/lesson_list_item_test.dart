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

    testWidgets('shows calendarClock icon and blocks tap', (tester) async {
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

    testWidgets('shows lock icon and blocks tap for locked lesson',
        (tester) async {
      const lockedLesson = LessonDto(
        id: '3',
        chapterId: '1',
        title: 'Locked Lesson',
        type: LessonType.video,
        progressStatus: LessonProgressStatus.notStarted,
        duration: '15 min',
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
      );

      var tapped = false;
      await tester.pumpWidget(wrap(LessonListItem(
        lesson: lockedLesson,
        onTap: () => tapped = true,
      )));
      await tester.pumpAndSettle();

      expect(find.byIcon(LucideIcons.lock), findsOneWidget);

      await tester.tap(find.byType(AppFocusable));
      await tester.pump(const Duration(seconds: 4));

      expect(tapped, isFalse);
    });

    testWidgets(
        'exposes semantic label with title, type, and lock/expired status',
        (tester) async {
      const lockedLesson = LessonDto(
        id: '4',
        chapterId: '1',
        title: 'Algorithms 101',
        type: LessonType.video,
        progressStatus: LessonProgressStatus.notStarted,
        duration: '15 min',
        orderIndex: 4,
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
      );

      await tester.pumpWidget(wrap(LessonListItem(
        lesson: lockedLesson,
        onTap: () {},
      )));
      await tester.pumpAndSettle();

      expect(
        find.bySemanticsLabel('Algorithms 101, Locked'),
        findsOneWidget,
      );
    });
  });
}
