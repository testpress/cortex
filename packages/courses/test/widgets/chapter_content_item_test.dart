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

  group('ChapterContentItem Expiry', () {
    final expiredLesson = LessonDto(
      id: '1',
      chapterId: '1',
      title: 'Expired Lesson',
      type: LessonType.video,
      progressStatus: LessonProgressStatus.notStarted,
      orderIndex: 1,
      hasEnded: true,
      end: '2023-12-31T23:59:59Z',
      isLocked: false,
      duration: '',
    );

    testWidgets('shows calendarClock icon and blocks tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrap(ChapterContentItem(
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
        'does not render completed badge for in-progress test with hasAttempts=true',
        (tester) async {
      final inProgressTest = LessonDto(
        id: '2',
        chapterId: '1',
        title: 'Midterm Exam',
        type: LessonType.test,
        progressStatus: LessonProgressStatus.inProgress,
        orderIndex: 2,
        hasEnded: false,
        isLocked: false,
        duration: '60 min',
        hasAttempts: true,
      );

      await tester.pumpWidget(wrap(ChapterContentItem(
        lesson: inProgressTest,
        onTap: () {},
      )));
      await tester.pumpAndSettle();

      // Checkmark / completed semantics should NOT be present
      expect(find.byIcon(LucideIcons.check), findsNothing);
    });

    testWidgets(
        'renders completed badge for completed test with progressStatus=completed',
        (tester) async {
      final completedTest = LessonDto(
        id: '3',
        chapterId: '1',
        title: 'Final Exam',
        type: LessonType.test,
        progressStatus: LessonProgressStatus.completed,
        orderIndex: 3,
        hasEnded: false,
        isLocked: false,
        duration: '60 min',
        hasAttempts: true,
      );

      await tester.pumpWidget(wrap(ChapterContentItem(
        lesson: completedTest,
        onTap: () {},
      )));
      await tester.pumpAndSettle();

      // Checkmark icon should be rendered for completed test
      expect(find.byIcon(LucideIcons.check), findsOneWidget);
    });

    testWidgets('shows lock icon and blocks tap for locked lesson',
        (tester) async {
      final lockedLesson = LessonDto(
        id: '4',
        chapterId: '1',
        title: 'Locked Chapter Content',
        type: LessonType.video,
        progressStatus: LessonProgressStatus.completed,
        orderIndex: 4,
        hasEnded: false,
        isLocked: true,
        duration: '10 min',
      );

      var tapped = false;
      await tester.pumpWidget(wrap(ChapterContentItem(
        lesson: lockedLesson,
        onTap: () => tapped = true,
      )));
      await tester.pumpAndSettle();

      expect(find.byIcon(LucideIcons.lock), findsOneWidget);
      // Even if progressStatus is completed, locked lesson must not show checkmark
      expect(find.byIcon(LucideIcons.check), findsNothing);

      await tester.tap(find.byType(AppFocusable));
      await tester.pump(const Duration(seconds: 4));

      expect(tapped, isFalse);
    });

    testWidgets('renders In Progress badge for in-progress unlocked lesson',
        (tester) async {
      final inProgressLesson = LessonDto(
        id: '5',
        chapterId: '1',
        title: 'Shell Script tutorials',
        type: LessonType.video,
        progressStatus: LessonProgressStatus.inProgress,
        orderIndex: 5,
        hasEnded: false,
        isLocked: false,
        duration: '5m 17s',
      );

      await tester.pumpWidget(wrap(ChapterContentItem(
        lesson: inProgressLesson,
        onTap: () {},
      )));
      await tester.pumpAndSettle();

      expect(find.text('In Progress'), findsOneWidget);
    });
  });
}
