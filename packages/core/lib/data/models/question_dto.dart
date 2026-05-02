/// Question DTO — represents a single exam question.
class QuestionDto {
  final String id;
  final String text;
  final String type; // 'singleSelect' | 'multipleSelect'
  final String subject;
  final List<QuestionOptionDto> options;
  final String answerUrl;
  final String? markUrl;
  final List<String> correctOptionIds;
  final String? explanation;

  const QuestionDto({
    required this.id,
    required this.text,
    required this.type,
    this.subject = 'General',
    required this.options,
    required this.answerUrl,
    this.markUrl,
    this.correctOptionIds = const [],
    this.explanation,
  });

  factory QuestionDto.fromJson(Map<String, dynamic> json) {
    return QuestionDto(
      id: (json['id'] ?? '').toString(),
      text: json['text'] as String? ?? '',
      type: json['type'] as String? ?? 'singleSelect',
      subject: json['subject'] as String? ?? 'General',
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => QuestionOptionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      answerUrl: json['answer_url'] as String? ?? '',
      markUrl: json['mark_url'] as String?,
      correctOptionIds: (json['correct_option_ids'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      explanation: json['explanation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type,
      'subject': subject,
      'options': options.map((e) => e.toJson()).toList(),
      'answer_url': answerUrl,
      'mark_url': markUrl,
      'correct_option_ids': correctOptionIds,
      'explanation': explanation,
    };
  }
}

/// Option for a question.
class QuestionOptionDto {
  final String id;
  final String text;

  const QuestionOptionDto({
    required this.id,
    required this.text,
  });

  factory QuestionOptionDto.fromJson(Map<String, dynamic> json) {
    return QuestionOptionDto(
      id: (json['id'] ?? '').toString(),
      text: json['text'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }
}
