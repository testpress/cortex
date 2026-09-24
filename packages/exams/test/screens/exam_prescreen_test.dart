import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:exams/screens/exam_prescreen.dart';

void main() {
  Widget buildAppWith(Widget child) {
    return ProviderScope(
      child: WidgetsApp(
        color: const Color(0xFF000000),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, _) => Directionality(
          textDirection: TextDirection.ltr,
          child: DesignProvider(config: DesignConfig.light(), child: child),
        ),
      ),
    );
  }

  testWidgets('renders ContentNoticeView when lesson is scheduled', (
    WidgetTester tester,
  ) async {
    const scheduledMessage =
        'This content will be unlocked on 25th Sep 2026 03:26 AM.';
    const scheduledLesson = LessonDto(
      id: '247632',
      chapterId: '32208',
      title: 'Scheduled Test',
      type: LessonType.test,
      progressStatus: LessonProgressStatus.notStarted,
      duration: '30 min',
      orderIndex: 1,
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
    );

    await tester.pumpWidget(
      buildAppWith(
        ExamPrescreen(
          testId: '247632',
          lesson: scheduledLesson,
          onClose: () {},
          onStartAttempt:
              (mode, {isOffline = false, isPartial = false}) async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ContentNoticeView), findsOneWidget);
    expect(find.byIcon(LucideIcons.calendarClock), findsOneWidget);
    expect(find.text('This content is scheduled'), findsOneWidget);
    expect(find.text(scheduledMessage), findsOneWidget);
  });
}
