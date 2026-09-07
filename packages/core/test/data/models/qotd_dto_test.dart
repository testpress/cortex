import 'package:core/data/models/qotd_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QotdQuestionType.from', () {
    test('returns singleCorrect for null, empty, or single types', () {
      expect(QotdQuestionType.from(null), QotdQuestionType.singleCorrect);
      expect(QotdQuestionType.from(''), QotdQuestionType.singleCorrect);
      expect(QotdQuestionType.from('   '), QotdQuestionType.singleCorrect);
      expect(QotdQuestionType.from('S'), QotdQuestionType.singleCorrect);
      expect(QotdQuestionType.from('SINGLE'), QotdQuestionType.singleCorrect);
      expect(
        QotdQuestionType.from('SINGLE_CHOICE'),
        QotdQuestionType.singleCorrect,
      );
    });

    test('returns multipleCorrect for multi-choice codes and variations', () {
      expect(QotdQuestionType.from('C'), QotdQuestionType.multipleCorrect);
      expect(QotdQuestionType.from('M'), QotdQuestionType.multipleCorrect);
      expect(QotdQuestionType.from('MCA'), QotdQuestionType.multipleCorrect);
      expect(
        QotdQuestionType.from('MULTIPLE'),
        QotdQuestionType.multipleCorrect,
      );
      expect(
        QotdQuestionType.from('MULTIPLE_TYPE'),
        QotdQuestionType.multipleCorrect,
      );
      expect(
        QotdQuestionType.from('MULTIPLESELECT'),
        QotdQuestionType.multipleCorrect,
      );
      expect(
        QotdQuestionType.from('MULTIPLE_CHOICE'),
        QotdQuestionType.multipleCorrect,
      );
      expect(
        QotdQuestionType.from('Multiple Choice'),
        QotdQuestionType.multipleCorrect,
      );
      expect(
        QotdQuestionType.from('Multiple Correct'),
        QotdQuestionType.multipleCorrect,
      );
    });
  });

  group('QotdDto.fromJson', () {
    test('parses flat JSON payload correctly', () {
      final json = {
        'id': 101,
        'question_id': 202,
        'question_html': '<p>What is the capital of France?</p>',
        'subject': 'Geography',
        'difficulty': 'Easy',
        'type': 'S',
        'options': [
          {'id': 1, 'text_html': '<p>Paris</p>'},
          {'id': 2, 'text_html': '<p>London</p>'},
        ],
      };

      final dto = QotdDto.fromJson(json);

      expect(dto.id, 101);
      expect(dto.questionId, 202);
      expect(dto.htmlContent, '<p>What is the capital of France?</p>');
      expect(dto.subject, 'Geography');
      expect(dto.difficulty, 'Easy');
      expect(dto.type, 'S');
      expect(dto.questionType, QotdQuestionType.singleCorrect);
      expect(dto.options.length, 2);
      expect(dto.options.first.id, 1);
      expect(dto.options.first.htmlContent, '<p>Paris</p>');
      expect(dto.pastAttempt, isNull);
    });

    test('parses nested question JSON structure with key fallbacks', () {
      final json = {
        'daily_question_id': 301,
        'question': {
          'id': 402,
          'text': '<p>Select all prime numbers</p>',
          'subject_name': 'Mathematics',
          'difficulty_level': 'Hard',
          'question_type': 'MCA',
          'answers': [
            {'id': 10, 'content': '2'},
            {'id': 11, 'text': '3'},
            {'id': 12, 'text_html': '4'},
          ],
        },
      };

      final dto = QotdDto.fromJson(json);

      expect(dto.id, 301);
      expect(dto.questionId, 402);
      expect(dto.htmlContent, '<p>Select all prime numbers</p>');
      expect(dto.subject, 'Mathematics');
      expect(dto.difficulty, 'Hard');
      expect(dto.questionType, QotdQuestionType.multipleCorrect);
      expect(dto.options.length, 3);
      expect(dto.options[0].htmlContent, '2');
      expect(dto.options[1].htmlContent, '3');
      expect(dto.options[2].htmlContent, '4');
    });

    test('handles map-based subject and null/empty subject strings', () {
      final mapSubjectJson = {
        'id': 1,
        'text': 'Question text',
        'subject': {'name': 'Physics'},
      };
      expect(QotdDto.fromJson(mapSubjectJson).subject, 'Physics');

      final mapSubjectTitleJson = {
        'id': 1,
        'text': 'Question text',
        'subject': {'title': 'Biology'},
      };
      expect(QotdDto.fromJson(mapSubjectTitleJson).subject, 'Biology');

      final nullSubjectJson = {'id': 1, 'text': 'Question text'};
      expect(QotdDto.fromJson(nullSubjectJson).subject, isNull);

      final whitespaceSubjectJson = {
        'id': 1,
        'text': 'Question text',
        'subject': '   ',
      };
      expect(QotdDto.fromJson(whitespaceSubjectJson).subject, isNull);
    });

    test('parses past attempt when present in root or nested question', () {
      final withRootAttempt = {
        'id': 1,
        'text': 'Sample Question',
        'attempt': {
          'is_correct': true,
          'explanation': 'Because of reason X',
          'selected_answer_ids': [101],
          'correct_answer_ids': [101],
        },
      };

      final dto = QotdDto.fromJson(withRootAttempt);
      expect(dto.pastAttempt, isNotNull);
      expect(dto.pastAttempt!.isCorrect, isTrue);
      expect(dto.pastAttempt!.explanation, 'Because of reason X');
      expect(dto.pastAttempt!.selectedAnswerIds, [101]);
      expect(dto.pastAttempt!.correctAnswerIds, [101]);

      final withNestedAttempt = {
        'id': 1,
        'question': {
          'text': 'Nested Sample',
          'attempt': {
            'is_correct': false,
            'explanation': 'Wrong answer',
            'answer_ids': [102],
            'correct_answer_ids': [101],
          },
        },
      };

      final nestedDto = QotdDto.fromJson(withNestedAttempt);
      expect(nestedDto.pastAttempt, isNotNull);
      expect(nestedDto.pastAttempt!.isCorrect, isFalse);
      expect(nestedDto.pastAttempt!.selectedAnswerIds, [102]);
    });
  });

  group('QotdSubmitResponseDto.fromJson', () {
    test('parses single answer_id integer into selectedAnswerIds list', () {
      final json = {
        'is_correct': false,
        'explanation': 'Test explanation',
        'answer_id': 55,
        'correct_answer_ids': [60],
      };

      final response = QotdSubmitResponseDto.fromJson(json);
      expect(response.isCorrect, isFalse);
      expect(response.explanation, 'Test explanation');
      expect(response.selectedAnswerIds, [55]);
      expect(response.correctAnswerIds, [60]);
    });
  });

  group('QotdSummaryDto.fromJson', () {
    test('parses summary counts correctly', () {
      final json = {
        'total_count': 10,
        'attempted_count': 6,
        'correct_count': 4,
        'incorrect_count': 2,
        'unanswered_count': 4,
        'status': 'in_progress',
      };

      final summary = QotdSummaryDto.fromJson(json);
      expect(summary.totalCount, 10);
      expect(summary.attemptedCount, 6);
      expect(summary.correctCount, 4);
      expect(summary.incorrectCount, 2);
      expect(summary.unansweredCount, 4);
      expect(summary.status, 'in_progress');
    });

    test('defaults to zero when fields are missing', () {
      final summary = QotdSummaryDto.fromJson({});
      expect(summary.totalCount, 0);
      expect(summary.attemptedCount, 0);
      expect(summary.correctCount, 0);
      expect(summary.incorrectCount, 0);
      expect(summary.unansweredCount, 0);
      expect(summary.status, isNull);
    });
  });
}
