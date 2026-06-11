import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:exams/screens/review_answer/widgets/review_question_html_builder.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final l10n = lookupAppLocalizations(const Locale('en'));

  testWidgets('build returns explanationHtml from quizReview when provided', (WidgetTester tester) async {
    final design = DesignConfig.light();
    final question = const QuestionDto(
      id: 'q1',
      text: 'Sample Q',
      type: 'multipleSelect',
      answerUrl: '',
      options: [],
      explanation: 'Fallback Explanation',
    );

    final attemptState = AnswerDto(
      questionId: 'q1',
      selectedOptions: [],
    );

    final quizReview = const QuizReviewResultDto(
      questionId: 'q1',
      selectedAnswers: [],
      correctAnswers: [],
      result: true,
      explanationHtml: 'Server Explanation Html',
    );

    final html = ReviewQuestionHtmlBuilder.build(
      question: question,
      attemptState: attemptState,
      quizReview: quizReview,
      design: design,
      l10n: l10n,
    );

    expect(html, contains('Server Explanation Html'));
    expect(html, isNot(contains('Fallback Explanation')));
  });

  testWidgets('build uses result from quizReview for exact match evaluation', (WidgetTester tester) async {
    final design = DesignConfig.light();
    final question = const QuestionDto(
      id: 'q1',
      text: 'Sample Q',
      type: 'multipleSelect',
      answerUrl: '',
      options: [
        QuestionOptionDto(id: '1', text: 'Option 1', isCorrect: true),
        QuestionOptionDto(id: '2', text: 'Option 2', isCorrect: true),
      ],
    );

    final attemptState = AnswerDto(
      questionId: 'q1',
      selectedOptions: ['1'], // only 1 selected
    );

    final quizReview = const QuizReviewResultDto(
      questionId: 'q1',
      selectedAnswers: ['1'],
      correctAnswers: ['1', '2'],
      result: false, // Server says it's false
    );

    final html = ReviewQuestionHtmlBuilder.build(
      question: question,
      attemptState: attemptState,
      quizReview: quizReview,
      design: design,
      l10n: l10n,
    );

    // It should not render the feedback banner
    expect(html, isNot(contains('class="feedback-banner"')));
    expect(html, contains('Option 1'));
  });

  testWidgets('build prefers exact selected-answer match over false quiz result when correct answers are present', (WidgetTester tester) async {
    final design = DesignConfig.light();
    final question = const QuestionDto(
      id: 'q1',
      text: 'Sample Q',
      type: 'singleSelect',
      answerUrl: '',
      options: [
        QuestionOptionDto(id: '1', text: 'Option 1'),
        QuestionOptionDto(id: '2', text: 'Option 2'),
      ],
    );

    final attemptState = AnswerDto(
      questionId: 'q1',
      selectedOptions: ['2'],
    );

    final quizReview = const QuizReviewResultDto(
      questionId: 'q1',
      selectedAnswers: ['2'],
      correctAnswers: ['2'],
      result: false,
      explanationHtml: 'Quiz explanation',
    );

    final html = ReviewQuestionHtmlBuilder.build(
      question: question,
      attemptState: attemptState,
      quizReview: quizReview,
      design: design,
      l10n: l10n,
    );

    expect(html, isNot(contains('class="feedback-banner"')));
    expect(html, contains('Quiz explanation'));
  });

  testWidgets('build uses correctAnswers from quizReview when result is null', (WidgetTester tester) async {
    final design = DesignConfig.light();
    final question = const QuestionDto(
      id: 'q1',
      text: 'Sample Q',
      type: 'multipleSelect',
      answerUrl: '',
      options: [
        QuestionOptionDto(id: '1', text: 'Option 1'),
        QuestionOptionDto(id: '2', text: 'Option 2'),
      ],
    );

    final attemptState = AnswerDto(
      questionId: 'q1',
      selectedOptions: ['1', '2'],
    );

    final quizReview = const QuizReviewResultDto(
      questionId: 'q1',
      selectedAnswers: ['1', '2'],
      correctAnswers: ['1', '2'],
      result: null,
      explanationHtml: 'Quiz explanation',
    );

    final html = ReviewQuestionHtmlBuilder.build(
      question: question,
      attemptState: attemptState,
      quizReview: quizReview,
      design: design,
      l10n: l10n,
    );

    expect(html, isNot(contains('class="feedback-banner"')));
    expect(html, contains('Quiz explanation'));
  });

  testWidgets('build falls back to exact match evaluation if quizReview not provided', (WidgetTester tester) async {
    final design = DesignConfig.light();
    final question = const QuestionDto(
      id: 'q1',
      text: 'Sample Q',
      type: 'multipleSelect',
      answerUrl: '',
      options: [
        QuestionOptionDto(id: '1', text: 'Option 1', isCorrect: true),
        QuestionOptionDto(id: '2', text: 'Option 2', isCorrect: true),
      ],
    );

    final attemptState = AnswerDto(
      questionId: 'q1',
      selectedOptions: ['1', '2'], // completely matches
    );

    final html = ReviewQuestionHtmlBuilder.build(
      question: question,
      attemptState: attemptState,
      quizReview: null,
      design: design,
      l10n: l10n,
    );

    expect(html, isNot(contains('class="feedback-banner"')));
    expect(html, contains('Option 1'));
  });
}
