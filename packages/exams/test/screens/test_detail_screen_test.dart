import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:exams/screens/test_detail_screen.dart';
import 'package:exams/repositories/exam_repository.dart';
import 'package:exams/providers/exam_providers.dart';
import 'package:exams/widgets/test_detail/nav_button.dart';
import 'package:exams/widgets/test_detail/submit_confirmation_dialog.dart';

class FakeExamRepository implements ExamRepository {
  @override
  final Stream<ExamAttemptState> stateStream;
  @override
  final ExamAttemptState state;

  FakeExamRepository(this.state) : stateStream = Stream.value(state);

  @override
  Stream<ExamAttemptState> watchState() => stateStream;

  @override
  void reset() {}

  @override
  Future<List<AttemptDto>> getAttempts(String attemptsUrl) async => [];

  @override
  Future<void> startStandaloneExam(
    ExamDto exam, {
    bool isQuizMode = false,
    bool isPartial = false,
    bool isCustomTest = false,
  }) async {}

  @override
  Future<void> startCourseLinkedExam(
    ExamDto exam,
    String contentAttemptsUrl, {
    bool isQuizMode = false,
    bool isPartial = false,
    bool isCustomTest = false,
  }) async {}

  @override
  Future<void> startCustomExam(
    AttemptDto attempt, {
    bool isCustomTest = true,
    bool isQuizMode = false,
  }) async {}

  @override
  Future<void> stopCountdown() async {}

  @override
  void stopHeartbeat() {}

  @override
  Future<void> switchSection(int index) async {}

  @override
  Future<void> submitAnswer(String questionId, AnswerDto answer) async {}

  @override
  void updateLocalAnswer(String questionId, AnswerDto answer) {}

  @override
  Future<void> checkQuizAnswer(String questionId, AnswerDto answer) async {}

  @override
  void updateShortText(String questionId, String text) {}

  @override
  void updateEssayText(String questionId, String text) {}

  @override
  void markQuestionAsChecked(String questionId) {}

  @override
  Future<void> endExam() async {}

  @override
  Future<void> pauseExam() async {}

  @override
  Future<List<ReviewItemDto>> getReviewItems(String reviewUrl) async => [];

  @override
  Future<List<SubjectAnalyticsDto>> getSubjectAnalytics(
    String analyticsUrl,
  ) async => [];

  @override
  Future<void> reportQuestion({
    required String questionId,
    required int type,
    String? description,
    int? examId,
  }) async {}
}

void main() {
  const testId = '45684';

  final List<SectionDto> sections = [
    const SectionDto(
      id: 's1',
      name: 'Reasoning',
      state: 'Completed',
      duration: '0:25:00',
      order: 0,
    ),
    const SectionDto(
      id: 's2',
      name: 'Quantitative',
      state: 'Running',
      duration: '0:20:00',
      order: 1,
    ),
  ];

  final List<QuestionDto> questions = [
    const QuestionDto(
      id: 'q1',
      text: 'Final Question of QA',
      type: 'singleSelect',
      answerUrl: '/answers/1/',
      sectionName: 'Quantitative',
      order: 0,
      subject: 'QA',
      options: [
        QuestionOptionDto(id: 'opt1', text: 'Option A'),
        QuestionOptionDto(id: 'opt2', text: 'Option B'),
      ],
    ),
  ];

  ExamAttemptState buildAttemptState({
    required bool allowPreemptiveSectionEnding,
    int currentSectionIndex = 1,
  }) {
    return ExamAttemptState(
      status: ExamAttemptStatus.inProgress,
      exam: ExamDto(
        id: testId,
        title: 'RRB CLERK PRELIMS',
        duration: '0:45:00',
        questionCount: 1,
        attemptsUrl: '/attempts/',
        allowPreemptiveSectionEnding: allowPreemptiveSectionEnding,
      ),
      attempt: AttemptDto(
        id: 101,
        sections: sections,
        remainingTime: '0:15:00',
        totalQuestions: 1,
      ),
      sections: sections,
      currentSectionIndex: currentSectionIndex,
      questions: questions,
      currentQuestionIndex: 0,
      remainingSeconds: 900,
    );
  }

  Widget createWidgetUnderTest(ExamAttemptState attemptState) {
    return ProviderScope(
      overrides: [
        examRepositoryProvider.overrideWithValue(
          FakeExamRepository(attemptState),
        ),
      ],
      child: WidgetsApp(
        color: const Color(0xFF000000),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, _) => Directionality(
          textDirection: TextDirection.ltr,
          child: DesignProvider(
            config: DesignConfig.light(),
            child: TestDetailScreen(testId: testId, onClose: () {}),
          ),
        ),
      ),
    );
  }

  group('TestDetailScreen section lockdown wiring', () {
    testWidgets(
      'displays disabled Next Section button on intermediate section when allowPreemptiveSectionEnding is false',
      (WidgetTester tester) async {
        final state = buildAttemptState(
          allowPreemptiveSectionEnding: false,
          currentSectionIndex: 0, // First section (Reasoning)
        );

        await tester.pumpWidget(createWidgetUnderTest(state));
        await tester.pumpAndSettle();

        final nextSectionFinder = find.widgetWithText(
          NavButton,
          'Next Section',
        );
        expect(nextSectionFinder, findsOneWidget);

        final nextSectionButton = tester.widget<NavButton>(nextSectionFinder);
        expect(nextSectionButton.onTap, isNull);

        // Does not show Finish button on intermediate section
        expect(find.widgetWithText(NavButton, 'Finish'), findsNothing);
      },
    );

    testWidgets(
      'displays enabled Next Section button on intermediate section when allowPreemptiveSectionEnding is true',
      (WidgetTester tester) async {
        final state = buildAttemptState(
          allowPreemptiveSectionEnding: true,
          currentSectionIndex: 0, // First section (Reasoning)
        );

        await tester.pumpWidget(createWidgetUnderTest(state));
        await tester.pumpAndSettle();

        final nextSectionFinder = find.widgetWithText(
          NavButton,
          'Next Section',
        );
        expect(nextSectionFinder, findsOneWidget);

        final nextSectionButton = tester.widget<NavButton>(nextSectionFinder);
        expect(nextSectionButton.onTap, isNotNull);
      },
    );

    testWidgets(
      'disables Finish button on final section when allowPreemptiveSectionEnding is false',
      (WidgetTester tester) async {
        final state = buildAttemptState(
          allowPreemptiveSectionEnding: false,
          currentSectionIndex: 1, // Final section (Quantitative)
        );

        await tester.pumpWidget(createWidgetUnderTest(state));
        await tester.pumpAndSettle();

        final finishFinder = find.widgetWithText(NavButton, 'Finish');
        expect(finishFinder, findsOneWidget);

        final finishButton = tester.widget<NavButton>(finishFinder);
        expect(finishButton.onTap, isNull);

        // Tap does not open SubmitConfirmationDialog
        await tester.tap(finishFinder);
        await tester.pumpAndSettle();

        expect(find.byType(SubmitConfirmationDialog), findsNothing);
      },
    );

    testWidgets(
      'enables Finish button on final section when allowPreemptiveSectionEnding is true',
      (WidgetTester tester) async {
        final state = buildAttemptState(
          allowPreemptiveSectionEnding: true,
          currentSectionIndex: 1, // Final section (Quantitative)
        );

        await tester.pumpWidget(createWidgetUnderTest(state));
        await tester.pumpAndSettle();

        final finishFinder = find.widgetWithText(NavButton, 'Finish');
        expect(finishFinder, findsOneWidget);

        final finishButton = tester.widget<NavButton>(finishFinder);
        expect(finishButton.onTap, isNotNull);

        // Tap opens SubmitConfirmationDialog
        await tester.tap(finishFinder);
        await tester.pumpAndSettle();

        expect(find.byType(SubmitConfirmationDialog), findsOneWidget);
      },
    );
  });
}
