import 'question_dto.dart';
import 'answer_dto.dart';

class SubjectAnalyticsDto {
  final int id;
  final String name;
  final int totalQuestionCount;
  final int correctAnswerCount;
  final int incorrectAnswerCount;
  final int unansweredCount;
  final double correctPercentage;
  final int? parentId;
  final bool isLeaf;

  const SubjectAnalyticsDto({
    required this.id,
    required this.name,
    required this.totalQuestionCount,
    required this.correctAnswerCount,
    required this.incorrectAnswerCount,
    required this.unansweredCount,
    required this.correctPercentage,
    this.parentId,
    this.isLeaf = true,
  });

  double get incorrectPercentage => totalQuestionCount == 0
      ? 0.0
      : (incorrectAnswerCount / totalQuestionCount * 100);
  double get unansweredPercentage => totalQuestionCount == 0
      ? 0.0
      : (unansweredCount / totalQuestionCount * 100);

  factory SubjectAnalyticsDto.fromJson(Map<String, dynamic> json) {
    final int totalQuestionCount = json['total'] as int? ?? 0;
    final int correctAnswerCount = json['correct'] as int? ?? 0;
    final int incorrectAnswerCount = json['incorrect'] as int? ?? 0;
    // API doesn't always return correct_percentage — derive it when absent
    final double correctPct =
        (json['correct_percentage'] as num?)?.toDouble() ??
        (totalQuestionCount > 0
            ? (correctAnswerCount / totalQuestionCount * 100)
            : 0.0);
    return SubjectAnalyticsDto(
      id: json['id'] as int? ?? 0,
      name: (json['name'] ?? '').toString(),
      totalQuestionCount: totalQuestionCount,
      correctAnswerCount: correctAnswerCount,
      incorrectAnswerCount: incorrectAnswerCount,
      unansweredCount: json['unanswered'] as int? ?? 0,
      correctPercentage: correctPct,
      parentId: json['parent'] as int? ?? json['parent_id'] as int?,
      isLeaf: json['leaf'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'total': totalQuestionCount,
      'correct': correctAnswerCount,
      'incorrect': incorrectAnswerCount,
      'unanswered': unansweredCount,
      'correct_percentage': correctPercentage,
      'parent': parentId,
      'leaf': isLeaf,
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
