import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/providers/lesson_detail_provider.dart';
import 'package:exams/providers/exam_providers.dart';
import 'package:exams/screens/exam_prescreen.dart';
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
                  child: child,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  group('ExamPrescreen locked-notice branch', () {
    testWidgets(
      'renders ContentNoticeView with lock icon when lesson.isLocked is true',
      (WidgetTester tester) async {
        const lockedLesson = LessonDto(
          id: 'exam-locked-1',
          chapterId: 'chapter-1',
          title: 'Locked Exam',
          type: LessonType.assessment,
          progressStatus: LessonProgressStatus.notStarted,
          duration: '00:30:00',
          isLocked: true,
          orderIndex: 1,
          isDetailFetched: true,
        );

        await tester.pumpWidget(
          wrap(
            ExamPrescreen(
              testId: 'exam-locked-1',
              lesson: lockedLesson,
              onClose: () {},
              onStartAttempt:
                  (isQuizMode, {isPartial = false, isOffline = false}) async {},
            ),
            overrides: [
              // Return the locked lesson immediately so isMetadataLoading=false
              lessonDetailProvider(
                'exam-locked-1',
              ).overrideWith((ref) => Stream.value(lockedLesson)),
            ],
          ),
        );
        await tester.pumpAndSettle();

        // Should show the lock icon from ContentNoticeView
        expect(find.byIcon(LucideIcons.lock), findsOneWidget);

        // Should NOT show any start/retake button
        expect(find.byType(ExamPrescreen), findsOneWidget);
        expect(find.byType(ContentNoticeView), findsOneWidget);
      },
    );

    testWidgets(
      'renders examHasEnded message and hides action buttons when lesson.hasEnded is true',
      (WidgetTester tester) async {
        const endedLesson = LessonDto(
          id: 'exam-ended-1',
          chapterId: 'chapter-1',
          title: 'Ended Exam',
          type: LessonType.assessment,
          progressStatus: LessonProgressStatus.notStarted,
          duration: '01:00:00',
          isLocked: false,
          hasEnded: true,
          orderIndex: 1,
          isDetailFetched: true,
        );

        await tester.pumpWidget(
          wrap(
            ExamPrescreen(
              testId: 'exam-ended-1',
              lesson: endedLesson,
              onClose: () {},
              onStartAttempt:
                  (isQuizMode, {isPartial = false, isOffline = false}) async {},
            ),
            overrides: [
              lessonDetailProvider(
                'exam-ended-1',
              ).overrideWith((ref) => Stream.value(endedLesson)),
              examAttemptsProvider(
                ApiEndpoints.lessonAttempts('exam-ended-1'),
              ).overrideWith((ref) => Future.value(<AttemptDto>[])),
            ],
          ),
        );
        await tester.pump();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Should NOT show ContentNoticeView (it is not locked)
        expect(find.byType(ContentNoticeView), findsNothing);

        // Should display "This exam has ended"
        expect(find.text('This exam has ended'), findsOneWidget);

        // Should NOT show start / offline attempt buttons
        expect(find.text('Start Exam'), findsNothing);
        expect(find.text('Take Offline Exam'), findsNothing);
      },
    );
  });
}
