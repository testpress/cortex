import 'dart:developer' as dev;

class QuizReviewResultDto {
  final String questionId;
  final List<String> selectedAnswers;
  final List<String> correctAnswers;
  final bool? result;
  final String? review;
  final String? explanationHtml;

  const QuizReviewResultDto({
    required this.questionId,
    required this.selectedAnswers,
    required this.correctAnswers,
    this.result,
    this.review,
    this.explanationHtml,
  });

  factory QuizReviewResultDto.fromJson(Map<String, dynamic> json) {
    List<String> parseStringList(dynamic value) {
      if (value is List) {
        return value.map((e) {
          if (e is Map) {
            return (e['id'] ?? e['answer_id'] ?? e['answerId'] ?? e['question_id'] ?? '').toString();
          }
          return e.toString();
        }).where((e) => e.isNotEmpty).toList();
      }
      return const <String>[];
    }

    List<String> parseCorrectAnswers(Map<String, dynamic> source) {
      final direct = parseStringList(
        source['correct_answers'] ??
            source['correctAnswers'] ??
            source['correct_answers_ids'] ??
            source['correctAnswersIds'],
      );
      if (direct.isNotEmpty) return direct;

      final nestedQuestion = source['question'];
      if (nestedQuestion is Map<String, dynamic>) {
        final nested = nestedQuestion['answers'];
        if (nested is List) {
          return nested
              .whereType<Map>()
              .where((answer) {
                final raw = answer['is_correct'] ?? answer['isCorrect'] ?? answer['correct'];
                if (raw is bool) return raw;
                if (raw == null) return false;
                final text = raw.toString().toLowerCase();
                return text == 'true' || text == '1';
              })
              .map((answer) => (answer['id'] ?? answer['answer_id'] ?? answer['answerId']).toString())
              .where((id) => id.isNotEmpty && id != 'null')
              .toList();
        }
      }

      final answers = source['answers'];
      if (answers is List) {
        return answers
            .whereType<Map>()
            .where((answer) {
              final raw = answer['is_correct'] ?? answer['isCorrect'] ?? answer['correct'];
              if (raw is bool) return raw;
              if (raw == null) return false;
              final text = raw.toString().toLowerCase();
              return text == 'true' || text == '1';
            })
            .map((answer) => (answer['id'] ?? answer['answer_id'] ?? answer['answerId']).toString())
            .where((id) => id.isNotEmpty && id != 'null')
            .toList();
      }

      return const <String>[];
    }

    bool? parseBool(dynamic value) {
      if (value is bool) return value;
      if (value == null) return null;
      final text = value.toString().toLowerCase();
      if (text == 'true' || text == '1' || text == 'correct') return true;
      if (text == 'false' || text == '0' || text == 'incorrect') return false;
      return null;
    }

    final parsed = QuizReviewResultDto(
      questionId: json['question_id']?.toString() ?? json['questionId']?.toString() ?? '',
      selectedAnswers: parseStringList(json['selected_answers'] ?? json['selectedAnswers']),
      correctAnswers: parseCorrectAnswers(json),
      result: parseBool(json['result'] ?? json['is_correct'] ?? json['correct'] ?? json['isCorrect']),
      review: json['review']?.toString(),
      explanationHtml: (json['explanation_html'] ?? json['explanationHtml'] ?? json['explanation'])?.toString(),
    );

    dev.log(
      'QuizReviewResultDto.fromJson parsed: '
      'questionId=${parsed.questionId}, '
      'selectedAnswers=${parsed.selectedAnswers}, '
      'correctAnswers=${parsed.correctAnswers}, '
      'result=${parsed.result}, '
      'review=${parsed.review}, '
      'hasExplanation=${parsed.explanationHtml != null && parsed.explanationHtml!.isNotEmpty}',
      name: 'QuizReviewResultDto',
    );

    return parsed;
  }
}
