import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/widgets/lesson_detail/mcq/video_mcq_stepper_card.dart';

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
                    OverlayEntry(
                      builder: (context) => SingleChildScrollView(child: child),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  final sampleQuestion = LearnLensQuizQuestionDto(
    id: 'q1',
    text:
        'A gas in a closed container is heated from 27°C to 127°C. What will be the final pressure?',
    options: ['2.67 atm', '4 atm', '3 atm', '2 atm'],
    correctAnswer: '3 atm',
    explanation: 'Gay-Lussac Law explanation.',
  );

  Widget buildSubject({
    int currentIndex = 0,
    int totalQuestions = 5,
    int answeredCount = 0,
    String? selectedOption,
    bool isAnswerChecked = false,
    VoidCallback? onCheckAnswer,
    ValueChanged<String>? onSelectOption,
  }) {
    return wrap(
      VideoMcqStepperCard(
        question: sampleQuestion,
        currentIndex: currentIndex,
        totalQuestions: totalQuestions,
        answeredCount: answeredCount,
        difficulty: 'medium',
        selectedOption: selectedOption,
        isAnswerChecked: isAnswerChecked,
        onCheckAnswer: onCheckAnswer,
        showHint: false,
        onToggleHint: () {},
        onSelectOption: onSelectOption ?? (_) {},
        onPrevious: () {},
        onNext: () {},
      ),
    );
  }

  testWidgets(
      'renders title, question count pill badge, and progress bar with accessibility semantics',
      (tester) async {
    await tester.pumpWidget(buildSubject(
      currentIndex: 0,
      totalQuestions: 5,
      answeredCount: 1,
    ));
    await tester.pumpAndSettle();

    expect(find.text('Practice Test'), findsOneWidget);
    expect(find.text('5 Questions'), findsOneWidget);
    expect(find.text('Question 1 of 5'), findsOneWidget);
    expect(find.text('1 answered'), findsOneWidget);
    expect(find.text(sampleQuestion.text), findsOneWidget);

    final semanticsFinder = find.byWidgetPredicate(
      (w) =>
          w is Semantics &&
          w.properties.label == 'Question 1 of 5' &&
          w.properties.value == '20%',
    );
    expect(semanticsFinder, findsOneWidget);
  });

  testWidgets('hides Check Answer button when no option is selected',
      (tester) async {
    await tester
        .pumpWidget(buildSubject(selectedOption: null, isAnswerChecked: false));
    await tester.pumpAndSettle();

    expect(find.text('Check Answer'), findsNothing);
    expect(find.text('Explanation'), findsNothing);
  });

  testWidgets(
      'shows Check Answer button and hides explanation when option is selected but not checked',
      (tester) async {
    var checkTapped = false;
    await tester.pumpWidget(buildSubject(
      selectedOption: '3 atm',
      isAnswerChecked: false,
      onCheckAnswer: () => checkTapped = true,
    ));
    await tester.pumpAndSettle();

    expect(find.text('Check Answer'), findsOneWidget);
    expect(find.text('Correct!'), findsNothing);

    await tester.tap(find.text('Check Answer'));
    await tester.pumpAndSettle();
    expect(checkTapped, isTrue);
  });

  testWidgets('reveals explanation and hides Check Answer button once checked',
      (tester) async {
    await tester.pumpWidget(buildSubject(
      selectedOption: '3 atm',
      isAnswerChecked: true,
    ));
    await tester.pumpAndSettle();

    expect(find.text('Check Answer'), findsNothing);
    expect(find.text('Correct!'), findsOneWidget);
    expect(find.textContaining('Gay-Lussac'), findsOneWidget);
  });

  testWidgets('disables Previous on first question and triggers Next',
      (tester) async {
    var previousTapped = false;
    var nextTapped = false;

    await tester.pumpWidget(wrap(
      VideoMcqStepperCard(
        question: sampleQuestion,
        currentIndex: 0,
        totalQuestions: 5,
        difficulty: 'medium',
        showHint: false,
        onToggleHint: () {},
        onSelectOption: (_) {},
        onPrevious: () => previousTapped = true,
        onNext: () => nextTapped = true,
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Previous'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    await tester.ensureVisible(find.text('Previous'));
    await tester.tap(find.text('Previous'));
    await tester.pumpAndSettle();
    expect(previousTapped, isFalse);

    await tester.ensureVisible(find.text('Next'));
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(nextTapped, isTrue);
  });

  testWidgets('enables Previous on subsequent questions and triggers callback',
      (tester) async {
    var previousTapped = false;

    await tester.pumpWidget(wrap(
      VideoMcqStepperCard(
        question: sampleQuestion,
        currentIndex: 1,
        totalQuestions: 5,
        difficulty: 'medium',
        showHint: false,
        onToggleHint: () {},
        onSelectOption: (_) {},
        onPrevious: () => previousTapped = true,
        onNext: () {},
      ),
    ));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Previous'));
    await tester.tap(find.text('Previous'));
    await tester.pumpAndSettle();
    expect(previousTapped, isTrue);
  });

  testWidgets('renders View All Questions trigger button and triggers callback',
      (tester) async {
    var paletteTapped = false;

    await tester.pumpWidget(wrap(
      VideoMcqStepperCard(
        question: sampleQuestion,
        currentIndex: 0,
        totalQuestions: 5,
        answeredCount: 2,
        difficulty: 'medium',
        showHint: false,
        onToggleHint: () {},
        onSelectOption: (_) {},
        onPrevious: () {},
        onNext: () {},
        onViewAllQuestions: () => paletteTapped = true,
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('View All Questions (2/5 answered)'), findsOneWidget);

    await tester.ensureVisible(find.text('View All Questions (2/5 answered)'));
    await tester.tap(find.text('View All Questions (2/5 answered)'));
    await tester.pumpAndSettle();
    expect(paletteTapped, isTrue);
  });

  testWidgets(
      'validates Check Answer visibility rules and disabled Previous together across state transitions',
      (tester) async {
    var previousCallCount = 0;
    var nextCallCount = 0;

    await tester.pumpWidget(wrap(
      StatefulBuilder(
        builder: (context, setState) {
          int currentIndex = 0;
          String? selectedOption;
          bool isAnswerChecked = false;

          return StatefulBuilder(
            builder: (context, setInnerState) {
              return VideoMcqStepperCard(
                question: sampleQuestion,
                currentIndex: currentIndex,
                totalQuestions: 5,
                difficulty: 'medium',
                selectedOption: selectedOption,
                isAnswerChecked: isAnswerChecked,
                onSelectOption: (opt) {
                  setInnerState(() {
                    selectedOption = opt;
                  });
                },
                onCheckAnswer: () {
                  setInnerState(() {
                    isAnswerChecked = true;
                  });
                },
                showHint: false,
                onToggleHint: () {},
                onPrevious: () {
                  previousCallCount++;
                  if (currentIndex > 0) {
                    setInnerState(() {
                      currentIndex--;
                      selectedOption = null;
                      isAnswerChecked = false;
                    });
                  }
                },
                onNext: () {
                  nextCallCount++;
                  if (currentIndex < 4) {
                    setInnerState(() {
                      currentIndex++;
                      selectedOption = null;
                      isAnswerChecked = false;
                    });
                  }
                },
              );
            },
          );
        },
      ),
    ));
    await tester.pumpAndSettle();

    // 1. Initial State: No option selected at index 0
    expect(find.text('Check Answer'), findsNothing);
    expect(find.text('Correct!'), findsNothing);

    // Tapping disabled Previous at index 0 does nothing
    await tester.ensureVisible(find.text('Previous'));
    await tester.tap(find.text('Previous'));
    await tester.pumpAndSettle();
    expect(previousCallCount, 0);

    // 2. Select option '3 atm' -> Check Answer appears
    await tester.ensureVisible(find.text('3 atm'));
    await tester.tap(find.text('3 atm'));
    await tester.pumpAndSettle();

    expect(find.text('Check Answer'), findsOneWidget);
    expect(find.text('Correct!'), findsNothing);

    // 3. Tap Check Answer -> Check Answer disappears, explanation appears
    await tester.ensureVisible(find.text('Check Answer'));
    await tester.tap(find.text('Check Answer'));
    await tester.pumpAndSettle();

    expect(find.text('Check Answer'), findsNothing);
    expect(find.text('Correct!'), findsOneWidget);
    expect(find.textContaining('Gay-Lussac'), findsOneWidget);

    // 4. Tap Next -> Moves to index 1, Check Answer is hidden, Previous is enabled
    await tester.ensureVisible(find.text('Next'));
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(nextCallCount, 1);

    expect(find.text('Question 2 of 5'), findsOneWidget);
    expect(find.text('Check Answer'), findsNothing);

    // Previous is now enabled at index 1
    await tester.ensureVisible(find.text('Previous'));
    await tester.tap(find.text('Previous'));
    await tester.pumpAndSettle();
    expect(previousCallCount, 1);
    expect(find.text('Question 1 of 5'), findsOneWidget);
  });
}
