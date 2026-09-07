import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/data.dart';
import 'package:testpress/screens/dashboard/qotd/qotd_quiz_controller.dart';

class FakeQotdRepository implements QotdRepository {
  QotdSubmitResponseDto? responseToReturn;
  int? lastSubmittedQuestionId;
  List<int>? lastSubmittedOptionIds;

  @override
  Future<List<QotdDto>> getQuestions() async => [];

  @override
  Future<QotdSummaryDto> getSummary() async => const QotdSummaryDto();

  @override
  Future<QotdSubmitResponseDto> submitAttempt({
    required int questionId,
    required List<int> optionIds,
  }) async {
    lastSubmittedQuestionId = questionId;
    lastSubmittedOptionIds = optionIds;
    return responseToReturn ??
        const QotdSubmitResponseDto(
          isCorrect: true,
          explanation: 'Well done!',
          selectedAnswerIds: [10],
          correctAnswerIds: [10],
        );
  }
}

void main() {
  const sampleQuestions = [
    QotdDto(
      id: 1,
      questionId: 101,
      htmlContent: '<p>Question 1 (Single Correct)</p>',
      type: 'S',
      options: [
        QotdOptionDto(id: 10, htmlContent: 'Option A'),
        QotdOptionDto(id: 11, htmlContent: 'Option B'),
      ],
    ),
    QotdDto(
      id: 2,
      questionId: 102,
      htmlContent: '<p>Question 2 (Multiple Correct)</p>',
      type: 'MCA',
      options: [
        QotdOptionDto(id: 20, htmlContent: 'Option 1'),
        QotdOptionDto(id: 21, htmlContent: 'Option 2'),
        QotdOptionDto(id: 22, htmlContent: 'Option 3'),
      ],
    ),
  ];

  late FakeQotdRepository fakeRepo;
  late ProviderContainer container;

  setUp(() {
    fakeRepo = FakeQotdRepository();
    container = ProviderContainer(
      overrides: [qotdRepositoryProvider.overrideWithValue(fakeRepo)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('QotdQuizController Initialization', () {
    test('initializes with default unattempted state and initialIndex', () {
      final provider = qotdQuizControllerProvider(
        questions: sampleQuestions,
        initialIndex: 1,
      );
      final state = container.read(provider);

      expect(state.currentIndex, 1);
      expect(state.selectedOptionIds, isEmpty);
      expect(state.isSubmittedMap, isEmpty);
      expect(state.submitResponses, isEmpty);
      expect(state.isSubmitting, isFalse);
    });

    test('pre-populates state when questions have past attempts', () {
      final attemptedQuestions = [
        const QotdDto(
          id: 1,
          questionId: 101,
          htmlContent: 'Q1',
          options: [QotdOptionDto(id: 10, htmlContent: 'Opt 10')],
          pastAttempt: QotdSubmitResponseDto(
            isCorrect: true,
            explanation: 'Previously solved',
            selectedAnswerIds: [10],
            correctAnswerIds: [10],
          ),
        ),
      ];

      final provider = qotdQuizControllerProvider(
        questions: attemptedQuestions,
        initialIndex: 0,
      );
      final state = container.read(provider);

      expect(state.isSubmittedMap[0], isTrue);
      expect(state.selectedOptionIds[0], {10});
      expect(state.submitResponses[0]?.explanation, 'Previously solved');
    });
  });

  group('QotdQuizController Option Selection', () {
    test('single-choice mode replaces previous selection', () {
      final provider = qotdQuizControllerProvider(
        questions: sampleQuestions,
        initialIndex: 0,
      );
      final notifier = container.read(provider.notifier);

      notifier.selectOption(0, 10, isMultiple: false);
      expect(container.read(provider).selectedOptionIds[0], {10});

      notifier.selectOption(0, 11, isMultiple: false);
      expect(container.read(provider).selectedOptionIds[0], {11});
    });

    test('multiple-choice mode toggles option selection', () {
      final provider = qotdQuizControllerProvider(
        questions: sampleQuestions,
        initialIndex: 1,
      );
      final notifier = container.read(provider.notifier);

      // Select option 20
      notifier.selectOption(1, 20, isMultiple: true);
      expect(container.read(provider).selectedOptionIds[1], {20});

      // Select option 21
      notifier.selectOption(1, 21, isMultiple: true);
      expect(container.read(provider).selectedOptionIds[1], {20, 21});

      // Unselect option 20
      notifier.selectOption(1, 20, isMultiple: true);
      expect(container.read(provider).selectedOptionIds[1], {21});
    });

    test('prevents selection when question is already submitted', () {
      final provider = qotdQuizControllerProvider(
        questions: sampleQuestions,
        initialIndex: 0,
      );
      final notifier = container.read(provider.notifier);

      notifier.selectOption(0, 10, isMultiple: false);

      // Artificially mark as submitted
      notifier.state = notifier.state.copyWith(isSubmittedMap: {0: true});

      // Try selecting another option
      notifier.selectOption(0, 11, isMultiple: false);
      expect(container.read(provider).selectedOptionIds[0], {10});
    });
  });

  group('QotdQuizController Navigation', () {
    test('setCurrentIndex updates current question index', () {
      final provider = qotdQuizControllerProvider(
        questions: sampleQuestions,
        initialIndex: 0,
      );
      final notifier = container.read(provider.notifier);

      notifier.setCurrentIndex(1);
      expect(container.read(provider).currentIndex, 1);
    });
  });

  group('QotdQuizController Submission', () {
    testWidgets('submits selected options to repository and records response', (
      tester,
    ) async {
      final provider = qotdQuizControllerProvider(
        questions: sampleQuestions,
        initialIndex: 0,
      );
      container.listen(provider, (_, _) {});
      final notifier = container.read(provider.notifier);

      notifier.selectOption(0, 10, isMultiple: false);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Builder(
              builder: (context) {
                return const SizedBox(width: 200, height: 200);
              },
            ),
          ),
        ),
      );

      final initialState = container.read(provider);
      expect(initialState.hasSubmittedNewAnswer, isFalse);

      final element = tester.element(find.byType(SizedBox));
      await notifier.submitCurrentAnswer(element);
      await tester.pumpAndSettle();

      expect(fakeRepo.lastSubmittedQuestionId, 1);
      expect(fakeRepo.lastSubmittedOptionIds, [10]);

      final finalState = container.read(provider);
      expect(finalState.isSubmittedMap[0], isTrue);
      expect(finalState.submitResponses[0]?.isCorrect, isTrue);
      expect(finalState.isSubmitting, isFalse);
      expect(finalState.hasSubmittedNewAnswer, isTrue);
    });
  });
}
