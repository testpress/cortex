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
  final bool isMarked;
  final String? shortText;
  final String? essayText;
  final String? sectionName;
  final String? sectionId;

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
    this.isMarked = false,
    this.shortText,
    this.essayText,
    this.sectionName,
    this.sectionId,
  });

  QuestionDto copyWith({
    String? id,
    String? text,
    String? type,
    String? subject,
    List<QuestionOptionDto>? options,
    String? answerUrl,
    String? markUrl,
    List<String>? correctOptionIds,
    String? explanation,
    String? directionHtml,
    int? order,
    List<String>? selectedOptionIds,
    bool? isMarked,
    String? shortText,
    String? essayText,
    String? sectionName,
    String? sectionId,
  }) {
    return QuestionDto(
      id: id ?? this.id,
      text: text ?? this.text,
      type: type ?? this.type,
      subject: subject ?? this.subject,
      options: options ?? this.options,
      answerUrl: answerUrl ?? this.answerUrl,
      markUrl: markUrl ?? this.markUrl,
      correctOptionIds: correctOptionIds ?? this.correctOptionIds,
      explanation: explanation ?? this.explanation,
      directionHtml: directionHtml ?? this.directionHtml,
      order: order ?? this.order,
      selectedOptionIds: selectedOptionIds ?? this.selectedOptionIds,
      isMarked: isMarked ?? this.isMarked,
      shortText: shortText ?? this.shortText,
      essayText: essayText ?? this.essayText,
      sectionName: sectionName ?? this.sectionName,
      sectionId: sectionId ?? this.sectionId,
    );
  }

  factory QuestionDto.fromJson(Map<String, dynamic> json) {
    // Handle nested question object in some API versions
    final Map<String, dynamic> data =
        json['question'] as Map<String, dynamic>? ?? json;

    final options =
        (data['options'] as List<dynamic>? ??
                data['answers'] as List<dynamic>? ??
                json['options'] as List<dynamic>? ??
                json['answers'] as List<dynamic>?)
            ?.map((e) => QuestionOptionDto.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const <QuestionOptionDto>[];

    final explicitCorrectIds =
        (data['correct_option_ids'] as List<dynamic>? ??
                json['correct_option_ids'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        const <String>[];

    final derivedCorrectIds = options
        .where((option) => option.isCorrect)
        .map((option) => option.id)
        .toList();

    final expl =
        (data['explanation'] ??
                data['explanation_html'] ??
                json['explanation_html'])
            as String?;

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
        'R' => 'singleSelect',
        'C' => 'multipleSelect',
        'S' => 'shortAnswer',
        'N' => 'numerical',
        'E' => 'essay',
        _ => 'singleSelect',
      },
      subject:
          (data['subject'] ?? data['subject_name'] ?? json['subject_name'])
              as String? ??
          'General',
      options: options,
      answerUrl:
          (json['answer_url'] ??
                  data['answer_url'] ??
                  data['url'] ??
                  json['url'])
              as String? ??
          '',
      markUrl: (data['mark_url'] ?? json['mark_url']) as String?,
      correctOptionIds: explicitCorrectIds.isNotEmpty
          ? explicitCorrectIds
          : derivedCorrectIds,
      explanation: expl,
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
      isMarked:
          (json['is_marked'] as bool?) ?? (data['is_marked'] as bool?) ?? false,
      shortText: (data['short_text'] ?? json['short_text']) as String?,
      essayText: (data['essay_text'] ?? json['essay_text']) as String?,
      sectionName: (json['attempt_section'] is Map)
          ? (json['attempt_section'] as Map)['name']?.toString()
          : (data['attempt_section'] is Map)
          ? (data['attempt_section'] as Map)['name']?.toString()
          : null,
      sectionId:
          (json['section_id'] ??
                  (json['attempt_section'] is Map
                      ? (json['attempt_section'] as Map)['id']
                      : json['attempt_section']) ??
                  data['section_id'] ??
                  (data['attempt_section'] is Map
                      ? (data['attempt_section'] as Map)['id']
                      : data['attempt_section']))
              ?.toString(),
    );
  }

  static List<QuestionDto> parseV3List(Map<String, dynamic> responseData) {
    final results =
        responseData['results'] as Map<String, dynamic>? ?? responseData;
    final userAnswersRaw = results['user_answers'] as List<dynamic>? ?? [];
    final examQuestionsRaw = results['exam_questions'] as List<dynamic>? ?? [];

    final examQuestionsMap = <int, Map<String, dynamic>>{};
    for (final eq in examQuestionsRaw) {
      if (eq is Map<String, dynamic> && eq['id'] != null) {
        examQuestionsMap[eq['id'] as int] = eq;
      }
    }

    final attemptSectionsRaw =
        results['attempt_sections'] as List<dynamic>? ??
        results['sections'] as List<dynamic>? ??
        [];

    final sectionNamesMap = <int, String>{};
    for (final sec in attemptSectionsRaw) {
      if (sec is Map<String, dynamic> && sec['id'] != null) {
        final secName = sec['section_name'] ?? sec['name'];
        if (secName != null) {
          sectionNamesMap[sec['id'] as int] = secName.toString();
        }
      }
    }

    final questions = <QuestionDto>[];
    for (final ua in userAnswersRaw) {
      if (ua is Map<String, dynamic>) {
        final eqId = ua['exam_question_id'] as int?;
        if (eqId != null && examQuestionsMap.containsKey(eqId)) {
          final eq = examQuestionsMap[eqId]!;

          final mergedJson = Map<String, dynamic>.from(eq);
          mergedJson['id'] = ua['id'];
          mergedJson['user_answer'] = ua;

          // user_answers is always authoritative for the current attempt.
          // Unconditionally override exam_questions static data (which may bleed
          // previous attempt answers) with the current attempt's user_answer values.
          // - New exam:  ua['selected_answers'] = []      → clean slate
          // - Resume:    ua['selected_answers'] = [4022]  → restores correctly
          // Note: the API uses 'review' (not 'is_marked') as the mark-for-review flag.
          //   review: null  → not visited
          //   review: false → visited, not marked
          //   review: true  → marked for review
          mergedJson['selected_answers'] = ua['selected_answers'] ?? [];
          mergedJson['is_marked'] = ua['review'] ?? false;
          mergedJson['short_text'] = ua['short_text'];
          mergedJson['essay_text'] = ua['essay_text'];

          final attemptSectionId = ua['attempt_section_id'];
          if (attemptSectionId != null) {
            mergedJson['attempt_section_id'] = attemptSectionId;
            if (sectionNamesMap.containsKey(attemptSectionId)) {
              // Inject as nested object so QuestionDto.fromJson natively picks up id & name
              mergedJson['attempt_section'] = {
                'id': attemptSectionId,
                'name': sectionNamesMap[attemptSectionId],
              };
            }
          }

          questions.add(QuestionDto.fromJson(mergedJson));
        }
      }
    }

    questions.sort((a, b) => a.order.compareTo(b.order));
    return questions;
  }

  static List<QuestionDto> parseOfflineQuestions(
    Map<String, dynamic> responseData,
  ) {
    final results =
        responseData['results'] as Map<String, dynamic>? ?? responseData;
    final questionsRaw = results['questions'] as List<dynamic>? ?? [];
    final examQuestionsRaw = results['exam_questions'] as List<dynamic>? ?? [];
    final sectionsRaw = results['sections'] as List<dynamic>? ?? [];

    final sectionNamesMap = <int, String>{};
    for (final sec in sectionsRaw) {
      if (sec is Map<String, dynamic> && sec['id'] != null) {
        final secName = sec['name'] ?? sec['section_name'];
        if (secName != null) {
          sectionNamesMap[sec['id'] as int] = secName.toString();
        }
      }
    }

    final questionsMap = <int, Map<String, dynamic>>{};
    for (final q in questionsRaw) {
      if (q is Map<String, dynamic> && q['id'] != null) {
        questionsMap[q['id'] as int] = q;
      }
    }

    final parsedQuestions = <QuestionDto>[];
    for (final eq in examQuestionsRaw) {
      if (eq is Map<String, dynamic>) {
        final qId = eq['question_id'] as int?;
        if (qId != null && questionsMap.containsKey(qId)) {
          final q = questionsMap[qId]!;

          final mergedJson = Map<String, dynamic>.from(q);
          mergedJson['id'] = eq['id'];
          mergedJson['order'] = eq['order'];

          final sectionId = eq['section_id'];
          if (sectionId != null) {
            mergedJson['section_id'] = sectionId;
            if (sectionNamesMap.containsKey(sectionId)) {
              mergedJson['attempt_section'] = {
                'id': sectionId,
                'name': sectionNamesMap[sectionId],
              };
            }
          }

          parsedQuestions.add(QuestionDto.fromJson(mergedJson));
        }
      }
    }

    parsedQuestions.sort((a, b) => a.order.compareTo(b.order));
    return parsedQuestions;
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
      'is_marked': isMarked,
      'short_text': shortText,
      'essay_text': essayText,
      'sectionName': sectionName,
      'section_id': sectionId,
    };
  }
}

/// Option for a question.
class QuestionOptionDto {
  final String id;
  final String text;
  final bool isCorrect;

  const QuestionOptionDto({
    required this.id,
    required this.text,
    this.isCorrect = false,
  });

  QuestionOptionDto copyWith({String? id, String? text, bool? isCorrect}) {
    return QuestionOptionDto(
      id: id ?? this.id,
      text: text ?? this.text,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  factory QuestionOptionDto.fromJson(Map<String, dynamic> json) {
    final rawIsCorrect =
        json['is_correct'] ?? json['correct'] ?? json['isCorrect'];
    final bool isCorrect = rawIsCorrect is bool
        ? rawIsCorrect
        : rawIsCorrect != null &&
              (rawIsCorrect.toString().toLowerCase() == 'true' ||
                  rawIsCorrect.toString() == '1');

    return QuestionOptionDto(
      id: (json['id'] ?? '').toString(),
      text: (json['text'] ?? json['text_html']) as String? ?? '',
      isCorrect: isCorrect,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text, 'is_correct': isCorrect};
  }
}

/// DTO to encapsulate the paginated response for offline exams.
class OfflineQuestionsResponseDto {
  final String? nextUrl;
  final List<QuestionDto> questions;

  const OfflineQuestionsResponseDto({this.nextUrl, required this.questions});

  factory OfflineQuestionsResponseDto.fromJson(Map<String, dynamic> json) {
    final next = json['next'] as String?;
    final parsedQuestions = QuestionDto.parseOfflineQuestions(json);
    return OfflineQuestionsResponseDto(
      nextUrl: next,
      questions: parsedQuestions,
    );
  }
}
