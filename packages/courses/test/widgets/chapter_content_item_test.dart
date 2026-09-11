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

    testWidgets('shows lock icon and blocks tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrap(ChapterContentItem(
        lesson: expiredLesson,
        onTap: () => tapped = true,
      )));
      await tester.pumpAndSettle();

      expect(find.byIcon(LucideIcons.lock), findsOneWidget);

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
  });
}
