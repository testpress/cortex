import 'package:core/core.dart';
import 'package:exams/exams.dart';
import 'package:exams/models/assessment_model.dart';
import 'package:exams/providers/assessment_controller.dart';
import 'package:exams/widgets/assessment_detail/assessment_header.dart';
import 'package:exams/widgets/assessment_detail/assessment_option_card.dart';
import 'package:exams/widgets/test_detail/pause_confirmation_dialog.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class _FakePlatformWebViewController extends PlatformWebViewController {
  _FakePlatformWebViewController(super.params) : super.implementation();

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {}

  @override
  Future<void> setBackgroundColor(Color color) async {}

  @override
  Future<void> addJavaScriptChannel(
    JavaScriptChannelParams javaScriptChannelParams,
  ) async {}

  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {}

  @override
  Future<void> loadHtmlString(String html, {String? baseUrl}) async {}

  @override
  Future<void> runJavaScript(String javaScript) async {}
}

class _FakePlatformWebViewWidget extends PlatformWebViewWidget {
  _FakePlatformWebViewWidget(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _FakePlatformNavigationDelegate extends PlatformNavigationDelegate {
  _FakePlatformNavigationDelegate(super.params) : super.implementation();

  @override
  Future<void> setOnPageFinished(
    void Function(String url) onPageFinished,
  ) async {}
}

class _FakeWebViewPlatform extends WebViewPlatform {
  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) {
    return _FakePlatformWebViewController(params);
  }

  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) {
    return _FakePlatformNavigationDelegate(params);
  }

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) {
    return _FakePlatformWebViewWidget(params);
  }
}

void main() {
  setUpAll(() {
    WebViewPlatform.instance = _FakeWebViewPlatform();
  });

  Widget wrap({required Widget child, List<Override> overrides = const []}) {
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

  group('AssessmentDetailScreen', () {
    testWidgets('renders fallback questions when opened without lesson', (
      WidgetTester tester,
    ) async {
      const mockQuestions = [
        AssessmentQuestion(
          id: 'q_mock',
          text: 'First Law of Thermodynamics',
          type: AssessmentQuestionType.mcq,
          options: [
            AssessmentOption(id: 'o1', text: 'Conservation of Energy'),
            AssessmentOption(id: 'o2', text: 'Conservation of Mass'),
          ],
          correctOptionIds: ['o1'],
        ),
      ];

      final testState = AssessmentState(
        status: ExamAttemptStatus.inProgress,
        title: 'First Law of Thermodynamics',
        questions: mockQuestions,
      );

      await tester.pumpWidget(
        wrap(
          overrides: [
            assessmentControllerProvider(
              const AssessmentParam(assessmentId: '101'),
            ).overrideWith(() => _FakeAssessmentController(testState)),
          ],
          child: AssessmentDetailScreen(assessmentId: '101', onClose: () {}),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AssessmentDetailScreen), findsOneWidget);
      expect(find.text('First Law of Thermodynamics'), findsOneWidget);
    });

    testWidgets('renders live questions from controller', (
      WidgetTester tester,
    ) async {
      const mockQuestions = [
        AssessmentQuestion(
          id: 'q1',
          text: 'What is the capital of France?',
          type: AssessmentQuestionType.mcq,
          options: [
            AssessmentOption(id: 'opt1', text: 'Paris'),
            AssessmentOption(id: 'opt2', text: 'Berlin'),
          ],
          correctOptionIds: ['opt1'],
          explanation: 'Paris is the capital.',
        ),
      ];

      const mockLesson = LessonDto(
        id: '202',
        chapterId: '10',
        title: 'Geography Quiz',
        type: LessonType.assessment,
        duration: '00:10:00',
        progressStatus: LessonProgressStatus.notStarted,
        isLocked: false,
        orderIndex: 1,
        attemptsUrl: 'https://example.com/api/v2.4/exams/geo/start/',
      );

      final customState = AssessmentState(
        status: ExamAttemptStatus.inProgress,
        title: 'Geography Quiz',
        questions: mockQuestions,
      );

      await tester.pumpWidget(
        wrap(
          overrides: [
            assessmentControllerProvider(
              const AssessmentParam(assessmentId: '202', lesson: mockLesson),
            ).overrideWith(() => _FakeAssessmentController(customState)),
          ],
          child: AssessmentDetailScreen(
            assessmentId: '202',
            lesson: mockLesson,
            onClose: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Geography Quiz'), findsOneWidget);
      expect(find.byType(AssessmentOptionCard), findsNWidgets(2));
    });

    testWidgets(
      'shows PauseConfirmationDialog when exit is tapped in progress',
      (WidgetTester tester) async {
        const mockQuestions = [
          AssessmentQuestion(
            id: 'q1',
            text: 'Question 1',
            type: AssessmentQuestionType.mcq,
            options: [
              AssessmentOption(id: 'opt1', text: 'Option A'),
              AssessmentOption(id: 'opt2', text: 'Option B'),
            ],
            correctOptionIds: ['opt1'],
          ),
        ];

        final customState = AssessmentState(
          status: ExamAttemptStatus.inProgress,
          title: 'Thermodynamics Assessment',
          questions: mockQuestions,
        );

        final fakeController = _FakeAssessmentController(customState);

        await tester.pumpWidget(
          wrap(
            overrides: [
              assessmentControllerProvider(
                const AssessmentParam(assessmentId: '303'),
              ).overrideWith(() => fakeController),
            ],
            child: AssessmentDetailScreen(assessmentId: '303', onClose: () {}),
          ),
        );
        await tester.pumpAndSettle();

        // Find exit button in AssessmentHeader and tap it
        final exitFinder = find.descendant(
          of: find.byType(AssessmentHeader),
          matching: find.byIcon(LucideIcons.chevronLeft),
        );
        expect(exitFinder, findsOneWidget);
        await tester.tap(exitFinder);
        await tester.pumpAndSettle();

        // Verify PauseConfirmationDialog is displayed
        expect(find.byType(PauseConfirmationDialog), findsOneWidget);

        // Tap Pause in dialog
        final pauseButtonFinder = find.text('Pause');
        expect(pauseButtonFinder, findsOneWidget);
        await tester.tap(pauseButtonFinder);
        await tester.pumpAndSettle();

        expect(fakeController.pauseExamCalled, isTrue);
      },
    );

    testWidgets('renders hydrated answers and checked feedback on resume', (
      WidgetTester tester,
    ) async {
      const mockQuestions = [
        AssessmentQuestion(
          id: 'q1',
          text: 'What is 2+2?',
          type: AssessmentQuestionType.mcq,
          options: [
            AssessmentOption(id: 'opt1', text: '3'),
            AssessmentOption(id: 'opt2', text: '4'),
          ],
          correctOptionIds: ['opt2'],
          explanation: '2+2 is 4.',
        ),
        AssessmentQuestion(
          id: 'q2',
          text: 'What is 3+3?',
          type: AssessmentQuestionType.mcq,
          options: [
            AssessmentOption(id: 'opt3', text: '5'),
            AssessmentOption(id: 'opt4', text: '6'),
          ],
          correctOptionIds: ['opt4'],
        ),
      ];

      final customState = AssessmentState(
        status: ExamAttemptStatus.inProgress,
        title: 'Math Assessment',
        questions: mockQuestions,
        currentIndex: 1,
        attemptStates: {
          'q1': const AssessmentAttemptState(
            questionId: 'q1',
            selectedOptions: ['opt2'],
            isChecked: true,
          ),
        },
      );

      final fakeController = _FakeAssessmentController(customState);

      await tester.pumpWidget(
        wrap(
          overrides: [
            assessmentControllerProvider(
              const AssessmentParam(assessmentId: '404'),
            ).overrideWith(() => fakeController),
          ],
          child: AssessmentDetailScreen(assessmentId: '404', onClose: () {}),
        ),
      );
      await tester.pumpAndSettle();

      // Current question is index 1 with 2 options
      expect(find.byType(AssessmentOptionCard), findsNWidgets(2));
      expect(find.text('Question 2 of 2'), findsOneWidget);
    });
  });
}

class _FakeAssessmentController extends AssessmentController {
  final AssessmentState _initialState;
  _FakeAssessmentController(this._initialState);

  bool pauseExamCalled = false;
  bool endExamCalled = false;

  @override
  AssessmentState build(AssessmentParam param) {
    return _initialState;
  }

  @override
  Future<void> pauseExam() async {
    pauseExamCalled = true;
  }

  @override
  Future<void> endExam() async {
    endExamCalled = true;
  }

  @override
  Future<void> checkAnswer(String questionId) async {}

  @override
  Future<void> next() async {}

  @override
  void retake() {}

  @override
  void retry() {}

  @override
  void selectOption(String questionId, String optionId) {}

  @override
  void tryAgain(String questionId) {}
}
