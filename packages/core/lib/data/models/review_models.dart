import 'question_dto.dart';
import 'answer_dto.dart';

class SubjectAnalyticsDto {
  final int id;
  final String name;
  final int total;
  final int correct;
  final int incorrect;
  final int unanswered;
  final double correctPercentage;
  final int? parent;
  final bool leaf;

  const SubjectAnalyticsDto({
    required this.id,
    required this.name,
    required this.total,
    required this.correct,
    required this.incorrect,
    required this.unanswered,
    required this.correctPercentage,
    this.parent,
    this.leaf = true,
  });

  double get incorrectPercentage =>
      total == 0 ? 0.0 : (incorrect / total * 100);
  double get unansweredPercentage =>
      total == 0 ? 0.0 : (unanswered / total * 100);

  factory SubjectAnalyticsDto.fromJson(Map<String, dynamic> json) {
    final int total = json['total'] as int? ?? 0;
    final int correct = json['correct'] as int? ?? 0;
    final int incorrect = json['incorrect'] as int? ?? 0;
    // API doesn't always return correct_percentage — derive it when absent
    final double correctPct =
        (json['correct_percentage'] as num?)?.toDouble() ??
        (total > 0 ? (correct / total * 100) : 0.0);
    return SubjectAnalyticsDto(
      id: json['id'] as int? ?? 0,
      name: (json['name'] ?? '').toString(),
      total: total,
      correct: correct,
      incorrect: incorrect,
      unanswered: json['unanswered'] as int? ?? 0,
      correctPercentage: correctPct,
      parent: json['parent'] as int?,
      leaf: json['leaf'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'total': total,
      'correct': correct,
      'incorrect': incorrect,
      'unanswered': unanswered,
      'correct_percentage': correctPercentage,
      'parent': parent,
      'leaf': leaf,
    };
  }
}

class ReviewAnswerDto {
  final int id;
  final String textHtml;
  final bool isCorrect;

  const ReviewAnswerDto({
    required this.id,
    required this.textHtml,
    required this.isCorrect,
  });

  factory ReviewAnswerDto.fromJson(Map<String, dynamic> json) {
    return ReviewAnswerDto(
      id: json['id'] as int? ?? 0,
      textHtml: (json['text_html'] ?? json['text'] ?? '').toString(),
      isCorrect: json['is_correct'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'text_html': textHtml, 'is_correct': isCorrect};
  }
}

class ReviewQuestionDto {
  final int id;
  final String questionHtml;
  final String? direction;
  final String? explanationHtml;
  final String type;
  final String? subject;
  final List<ReviewAnswerDto> answers;

  const ReviewQuestionDto({
    required this.id,
    required this.questionHtml,
    this.direction,
    this.explanationHtml,
    required this.type,
    this.subject,
    required this.answers,
  });

  factory ReviewQuestionDto.fromJson(Map<String, dynamic> json) {
    final answersList = json['answers'] as List<dynamic>? ?? [];
    return ReviewQuestionDto(
      id: json['id'] as int? ?? 0,
      questionHtml: (json['question_html'] ?? '').toString(),
      direction: json['direction']?.toString(),
      explanationHtml: (json['explanation_html'] ?? json['explanation'] ?? '')
          .toString(),
      type: (json['type'] ?? 'R').toString(),
      subject: json['subject']?.toString(),
      answers: answersList
          .map((a) => ReviewAnswerDto.fromJson(a as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_html': questionHtml,
      'direction': direction,
      'explanation_html': explanationHtml,
      'type': type,
      'subject': subject,
      'answers': answers.map((a) => a.toJson()).toList(),
    };
  }
}

class ReviewItemDto {
  final String id;
  final int index;
  final List<int> selectedAnswers;
  final String? result;
  final String? marks;
  final String? duration;
  final int? bookmarkId;
  final int? correctPercentage;
  final String? shortText;
  final ReviewQuestionDto question;

  const ReviewItemDto({
    required this.id,
    required this.index,
    required this.selectedAnswers,
    this.result,
    this.marks,
    this.duration,
    this.bookmarkId,
    this.correctPercentage,
    this.shortText,
    required this.question,
  });

  factory ReviewItemDto.fromJson(Map<String, dynamic> json) {
    final selectedList = json['selected_answers'] as List<dynamic>? ?? [];
    return ReviewItemDto(
      id: (json['id'] ?? '').toString(),
      index: (json['order'] ?? json['index']) as int? ?? 0,
      selectedAnswers: selectedList
          .map((s) => int.parse(s.toString()))
          .toList(),
      result: json['result']?.toString(),
      marks: json['marks']?.toString(),
      duration: json['duration']?.toString(),
      bookmarkId: json['bookmark_id'] as int?,
      correctPercentage: json['correct_percentage'] as int?,
      shortText: json['short_text']?.toString(),
      question: ReviewQuestionDto.fromJson(
        json['question'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'index': index,
      'selected_answers': selectedAnswers,
      'result': result,
      'marks': marks,
      'duration': duration,
      'bookmark_id': bookmarkId,
      'correct_percentage': correctPercentage,
      'short_text': shortText,
      'question': question.toJson(),
    };
  }

  QuestionDto toQuestionDto() {
    return QuestionDto(
      id: question.id.toString(),
      text: question.questionHtml,
      directionHtml: question.direction,
      type: question.type == 'C' ? 'multipleSelect' : 'singleSelect',
      explanation: question.explanationHtml,
      options: question.answers
          .map(
            (ans) =>
                QuestionOptionDto(id: ans.id.toString(), text: ans.textHtml),
          )
          .toList(),
      correctOptionIds: question.answers
          .where((ans) => ans.isCorrect)
          .map((ans) => ans.id.toString())
          .toList(),
      subject: question.subject ?? 'General',
      answerUrl: '',
      order: index,
    );
  }

  AnswerDto toAnswerDto() {
    return AnswerDto(
      questionId: question.id.toString(),
      selectedOptions: selectedAnswers,
      result: result,
    );
  }
}
