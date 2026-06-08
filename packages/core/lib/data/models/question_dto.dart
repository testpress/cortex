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
  final String? directionHtml;
  final int order;
  final List<String> selectedOptionIds;
  final String? shortText;
  final String? essayText;
  final String? sectionName;

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
    this.directionHtml,
    this.order = 0,
    this.selectedOptionIds = const [],
    this.shortText,
    this.essayText,
    this.sectionName,
  });

  factory QuestionDto.fromJson(Map<String, dynamic> json) {
    // Handle nested question object in some API versions
    final Map<String, dynamic> data =
        json['question'] as Map<String, dynamic>? ?? json;

    return QuestionDto(
      id: (data['id'] ?? json['id'] ?? '').toString(),
      text:
          (data['text'] ??
                  data['question'] ??
                  data['question_html'] ??
                  json['text_html'])
              as String? ??
          '',
      type: switch ((data['type'] ?? json['type']) as String?) {
        'R' => 'singleSelect', // MCQ, Single Correct (Testpress API)
        'C' => 'multipleSelect', // MCQ, Multiple Correct (Testpress API)
        'S' => 'shortAnswer',
        'N' => 'numerical',
        'E' => 'essay',
        _ => 'singleSelect',
      },
      subject:
          (data['subject'] ?? data['subject_name'] ?? json['subject_name'])
              as String? ??
          'General',
      options:
          (data['options'] as List<dynamic>? ??
                  data['answers'] as List<dynamic>? ??
                  json['options'] as List<dynamic>? ??
                  json['answers'] as List<dynamic>?)
              ?.map(
                (e) => QuestionOptionDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      answerUrl:
          (data['answer_url'] ??
                  json['answer_url'] ??
                  data['url'] ??
                  json['url'])
              as String? ??
          '',
      markUrl: (data['mark_url'] ?? json['mark_url']) as String?,
      correctOptionIds:
          (data['correct_option_ids'] as List<dynamic>? ??
                  json['correct_option_ids'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      explanation:
          (data['explanation'] ??
                  data['explanation_html'] ??
                  json['explanation_html'])
              as String?,
      directionHtml:
          (data['direction'] ??
                  data['direction_html'] ??
                  json['direction'] ??
                  json['direction_html'])
              as String?,
      order:
          int.tryParse(
            (json['order'] ?? json['question_index'] ?? '').toString(),
          ) ??
          0,
      selectedOptionIds:
          (json['selected_options'] as List<dynamic>? ??
                  json['selected_answers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      shortText: (data['short_text'] ?? json['short_text']) as String?,
      essayText: (data['essay_text'] ?? json['essay_text']) as String?,
      sectionName: (json['attempt_section'] is Map)
          ? (json['attempt_section'] as Map)['name']?.toString()
          : (data['attempt_section'] is Map)
          ? (data['attempt_section'] as Map)['name']?.toString()
          : null,
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
      'directionHtml': directionHtml,
      'order': order,
      'selected_options': selectedOptionIds,
      'short_text': shortText,
      'essay_text': essayText,
      'sectionName': sectionName,
    };
  }
}

/// Option for a question.
class QuestionOptionDto {
  final String id;
  final String text;

  const QuestionOptionDto({required this.id, required this.text});

  factory QuestionOptionDto.fromJson(Map<String, dynamic> json) {
    return QuestionOptionDto(
      id: (json['id'] ?? '').toString(),
      text: (json['text'] ?? json['text_html']) as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text};
  }
}
