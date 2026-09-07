/// Normalized question type — resolved once at parse time in [QotdDto.fromJson].
enum QotdQuestionType {
  singleCorrect,
  multipleCorrect;

  static QotdQuestionType from(String? raw) {
    if (raw == null || raw.trim().isEmpty) return singleCorrect;
    final upper = raw.trim().toUpperCase();
    if (upper == 'C' ||
        upper == 'M' ||
        upper == 'MCA' ||
        upper == 'MULTIPLE' ||
        upper == 'MULTIPLE_TYPE' ||
        upper == 'MULTIPLESELECT' ||
        upper == 'MULTIPLE_CHOICE' ||
        upper == 'MULTIPLE CHOICE' ||
        upper == 'MULTIPLE CORRECT' ||
        upper.contains('MULTIPLE')) {
      return multipleCorrect;
    }
    return singleCorrect;
  }
}

class QotdDto {
  final int id;
  final int questionId;
  final String htmlContent;
  final String? subject;
  final String? difficulty;
  final String? type;
  final List<QotdOptionDto> options;
  final QotdSubmitResponseDto? pastAttempt;

  const QotdDto({
    required this.id,
    required this.questionId,
    required this.htmlContent,
    this.subject,
    this.difficulty,
    this.type,
    this.options = const [],
    this.pastAttempt,
  });

  /// Normalized question type — derived from [type] at parse time.
  QotdQuestionType get questionType => QotdQuestionType.from(type);

  factory QotdDto.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data =
        json['question'] as Map<String, dynamic>? ?? json;

    final html =
        data['text'] ??
        data['question_html'] ??
        data['html'] ??
        json['text'] ??
        json['question_html'] ??
        json['html'] ??
        '';
    final optionsRaw =
        (data['options'] ??
                data['answers'] ??
                json['options'] ??
                json['answers'] ??
                [])
            as List<dynamic>;

    final dynamic subjectValue =
        data['subject'] ??
        data['subject_name'] ??
        json['subject_name'] ??
        json['subject'];
    final rawSubject =
        (subjectValue is Map
                ? (subjectValue['name'] ?? subjectValue['title'])
                : subjectValue)
            ?.toString();

    final rawDifficulty =
        (data['difficulty'] ??
                data['difficulty_level'] ??
                json['difficulty_level'] ??
                json['difficulty'])
            as String?;

    final rawType =
        (data['type'] ??
                data['question_type'] ??
                json['question_type'] ??
                json['type'])
            as String?;

    return QotdDto(
      id:
          json['daily_question_id'] as int? ??
          json['id'] as int? ??
          data['id'] as int? ??
          0,
      questionId:
          json['question_id'] as int? ??
          data['question_id'] as int? ??
          data['id'] as int? ??
          0,
      htmlContent: html.toString(),
      subject: (rawSubject != null && rawSubject.trim().isNotEmpty)
          ? rawSubject.trim()
          : null,

      difficulty: rawDifficulty,
      type: rawType,
      options: optionsRaw
          .map((e) => QotdOptionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      pastAttempt: json['attempt'] != null
          ? QotdSubmitResponseDto.fromJson(
              json['attempt'] as Map<String, dynamic>,
            )
          : (data['attempt'] != null
                ? QotdSubmitResponseDto.fromJson(
                    data['attempt'] as Map<String, dynamic>,
                  )
                : null),
    );
  }
}

class QotdOptionDto {
  final int id;
  final String htmlContent;

  const QotdOptionDto({required this.id, required this.htmlContent});

  factory QotdOptionDto.fromJson(Map<String, dynamic> json) {
    final html = json['text_html'] ?? json['text'] ?? json['content'] ?? '';
    return QotdOptionDto(
      id: json['id'] as int? ?? 0,
      htmlContent: html.toString(),
    );
  }
}

class QotdSubmitResponseDto {
  final bool isCorrect;
  final String explanation;
  final List<int> selectedAnswerIds;
  final List<int> correctAnswerIds;
  final Map<String, dynamic>? rawData;

  const QotdSubmitResponseDto({
    required this.isCorrect,
    required this.explanation,
    this.selectedAnswerIds = const [],
    this.correctAnswerIds = const [],
    this.rawData,
  });

  factory QotdSubmitResponseDto.fromJson(Map<String, dynamic> json) {
    final selectedRaw = json['selected_answer_ids'] ?? json['answer_ids'];
    final correctRaw = json['correct_answer_ids'];

    return QotdSubmitResponseDto(
      isCorrect: json['is_correct'] as bool? ?? false,
      explanation: json['explanation']?.toString() ?? '',
      selectedAnswerIds: selectedRaw is List
          ? selectedRaw.map((e) => e as int).toList()
          : (json['answer_id'] != null ? [json['answer_id'] as int] : []),
      correctAnswerIds: correctRaw is List
          ? correctRaw.map((e) => e as int).toList()
          : [],
      rawData: json,
    );
  }
}

class QotdSummaryDto {
  final int totalCount;
  final int attemptedCount;
  final int correctCount;
  final int incorrectCount;
  final int unansweredCount;
  final String? status;

  const QotdSummaryDto({
    this.totalCount = 0,
    this.attemptedCount = 0,
    this.correctCount = 0,
    this.incorrectCount = 0,
    this.unansweredCount = 0,
    this.status,
  });

  factory QotdSummaryDto.fromJson(Map<String, dynamic> json) {
    return QotdSummaryDto(
      totalCount: json['total_count'] as int? ?? 0,
      attemptedCount: json['attempted_count'] as int? ?? 0,
      correctCount: json['correct_count'] as int? ?? 0,
      incorrectCount: json['incorrect_count'] as int? ?? 0,
      unansweredCount: json['unanswered_count'] as int? ?? 0,
      status: json['status'] as String?,
    );
  }
}
