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
}
