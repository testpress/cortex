import 'package:core/data/data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuestionDto', () {
    test('derives correct option ids from answer metadata when explicit ids are absent', () {
      final question = QuestionDto.fromJson({
        'id': 'q-1',
        'question_html': 'Pick the correct option',
        'type': 'R',
        'answers': [
          {'id': '101', 'text_html': 'Wrong', 'is_correct': false},
          {'id': '102', 'text_html': 'Correct', 'is_correct': true},
        ],
      });

      expect(question.correctOptionIds, ['102']);
      expect(question.options.firstWhere((option) => option.id == '102').isCorrect, true);
    });
  });

  group('AnswerDto', () {
    test('preserves selected option ids for review while serializing numeric ids for the API', () {
      final answer = AnswerDto(
        questionId: 'q-1',
        selectedOptions: ['opt-a', '102'],
      );

      expect(answer.selectedOptions, ['opt-a', '102']);
      expect(answer.selectedAnswers, [102]);
      expect(answer.toJson()['selected_answers'], [102]);
    });

    test('allows quiz review submissions to override the review flag', () {
      final answer = AnswerDto(
        questionId: 'q-1',
        selectedOptions: ['102'],
      );

      expect(answer.toJson(review: true)['review'], true);
      expect(answer.toJson(review: false)['review'], false);
    });
  });

  group('QuizReviewResultDto', () {
    test('parses standard quiz review format correctly', () {
      final review = QuizReviewResultDto.fromJson({
        'question_id': '659389',
        'selected_answers': ['2426143'],
        'correct_answers': ['2426143'],
        'result': true,
      });

      expect(review.questionId, '659389');
      expect(review.selectedAnswers, ['2426143']);
      expect(review.correctAnswers, ['2426143']);
      expect(review.result, true);
    });

    test('parses attempt question response format with nested fields and correct_option_ids', () {
      final review = QuizReviewResultDto.fromJson({
        'id': '1021279043',
        'selected_answers': ['2426143'],
        'correct_option_ids': ['2426143'],
        'question': {
          'id': '659389',
          'question_html': 'Let A be a point...',
        },
      });

      expect(review.questionId, '659389');
      expect(review.selectedAnswers, ['2426143']);
      expect(review.correctAnswers, ['2426143']);
      expect(review.result, true); // derived since result was missing but answers match
    });

    test('parses nested options with is_correct flag to identify correct answers', () {
      final review = QuizReviewResultDto.fromJson({
        'id': '1021279043',
        'selected_answers': ['2426143'],
        'question': {
          'id': '659389',
          'options': [
            {'id': '2426143', 'text': 'Option A', 'is_correct': true},
            {'id': '2426144', 'text': 'Option B', 'is_correct': false},
          ],
        },
      });

      expect(review.questionId, '659389');
      expect(review.selectedAnswers, ['2426143']);
      expect(review.correctAnswers, ['2426143']);
      expect(review.result, true);
    });
  });
}
