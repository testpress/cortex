import 'section_dto.dart';

/// Attempt DTO — represents an active or completed exam attempt.
class AttemptDto {
  final int? id;
  final int? contentAttemptId;
  final int? userExamId;
  final String? date;
  final String? state;
  final String? remainingTime;
  final String? score;
  final int? correctCount;
  final int? incorrectCount;
  final int? totalQuestions;
  final List<SectionDto>? sections;
  final String? reviewUrl;
  final int? accuracy;
  final String? percentile;
  final String? percentage;
  final int? rank;
  final int? maxRank;
  final bool? rankEnabled;
  final String? markPerQuestion;
  final String? negativeMarks;
  final String? timeTaken;
  final int? lastViewedQuestionId;
  final int? attemptType;

  int? get activeId => userExamId ?? id;

  const AttemptDto({
    this.id,
    this.contentAttemptId,
    this.userExamId,
    this.date,
    this.state,
    this.remainingTime,
    this.score,
    this.correctCount,
    this.incorrectCount,
    this.totalQuestions,
    this.sections,
    this.reviewUrl,
    this.accuracy,
    this.percentile,
    this.percentage,
    this.rank,
    this.maxRank,
    this.rankEnabled,
    this.markPerQuestion,
    this.negativeMarks,
    this.timeTaken,
    this.lastViewedQuestionId,
    this.attemptType,
  });

  AttemptDto copyWith({
    int? id,
    int? contentAttemptId,
    int? userExamId,
    String? date,
    String? state,
    String? remainingTime,
    String? score,
    int? correctCount,
    int? incorrectCount,
    int? totalQuestions,
    List<SectionDto>? sections,
    String? reviewUrl,
    int? accuracy,
    String? percentile,
    String? percentage,
    int? rank,
    int? maxRank,
    bool? rankEnabled,
    String? markPerQuestion,
    String? negativeMarks,
    String? timeTaken,
    int? lastViewedQuestionId,
    int? attemptType,
  }) {
    return AttemptDto(
      id: id ?? this.id,
      contentAttemptId: contentAttemptId ?? this.contentAttemptId,
      userExamId: userExamId ?? this.userExamId,
      date: date ?? this.date,
      state: state ?? this.state,
      remainingTime: remainingTime ?? this.remainingTime,
      score: score ?? this.score,
      correctCount: correctCount ?? this.correctCount,
      incorrectCount: incorrectCount ?? this.incorrectCount,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      sections: sections ?? this.sections,
      reviewUrl: reviewUrl ?? this.reviewUrl,
      accuracy: accuracy ?? this.accuracy,
      percentile: percentile ?? this.percentile,
      percentage: percentage ?? this.percentage,
      rank: rank ?? this.rank,
      maxRank: maxRank ?? this.maxRank,
      rankEnabled: rankEnabled ?? this.rankEnabled,
      markPerQuestion: markPerQuestion ?? this.markPerQuestion,
      negativeMarks: negativeMarks ?? this.negativeMarks,
      timeTaken: timeTaken ?? this.timeTaken,
      lastViewedQuestionId: lastViewedQuestionId ?? this.lastViewedQuestionId,
      attemptType: attemptType ?? this.attemptType,
    );
  }

  factory AttemptDto.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data =
        json['assessment'] as Map<String, dynamic>? ??
        json['attempt'] as Map<String, dynamic>? ??
        json;

    final List<dynamic>? sectionsList =
        data['attempt_sections'] as List<dynamic>? ??
        json['attempt_sections'] as List<dynamic>? ??
        data['sections'] as List<dynamic>? ??
        json['sections'] as List<dynamic>?;
    final List<SectionDto>? parsedSections = sectionsList
        ?.map((s) => SectionDto.fromJson(s as Map<String, dynamic>))
        .toList();

    return AttemptDto(
      id: int.tryParse((data['id'] ?? json['id']).toString()),
      contentAttemptId: json['id'] != data['id']
          ? int.tryParse(json['id']?.toString() ?? '')
          : null,
      userExamId: int.tryParse(
        (data['userexam_id'] ?? json['userexam_id']).toString(),
      ),
      date:
          (data['date'] ??
                  json['date'] ??
                  data['started_on'] ??
                  json['started_on'] ??
                  data['date_created'] ??
                  json['date_created'])
              ?.toString(),
      state: (data['state'] ?? json['state'])?.toString(),
      remainingTime: (data['remaining_time'] ?? json['remaining_time'])
          ?.toString(),
      score: (data['score'] ?? json['score'])?.toString(),
      correctCount:
          (data['correct_count'] ??
                  json['correct_count'] ??
                  data['correct'] ??
                  json['correct']) !=
              null
          ? int.tryParse(
              (data['correct_count'] ??
                      json['correct_count'] ??
                      data['correct'] ??
                      json['correct'])
                  .toString(),
            )
          : null,
      incorrectCount:
          (data['incorrect_count'] ??
                  json['incorrect_count'] ??
                  data['incorrect'] ??
                  json['incorrect']) !=
              null
          ? int.tryParse(
              (data['incorrect_count'] ??
                      json['incorrect_count'] ??
                      data['incorrect'] ??
                      json['incorrect'])
                  .toString(),
            )
          : null,
      totalQuestions:
          (data['total_questions'] ?? json['total_questions']) != null
          ? int.tryParse(
              (data['total_questions'] ?? json['total_questions']).toString(),
            )
          : null,
      sections: parsedSections,
      reviewUrl: (data['review_url'] ?? json['review_url'])?.toString(),
      accuracy: json['accuracy'] as int? ?? data['accuracy'] as int?,
      percentile: (json['percentile'] ?? data['percentile'])?.toString(),
      percentage: (json['percentage'] ?? data['percentage'])?.toString(),
      rank: int.tryParse((data['rank'] ?? json['rank'])?.toString() ?? ''),
      maxRank: int.tryParse(
        (data['max_rank'] ??
                    json['max_rank'] ??
                    data['maxRank'] ??
                    json['maxRank'])
                ?.toString() ??
            '',
      ),
      rankEnabled:
          json['rank_enabled'] as bool? ?? data['rank_enabled'] as bool?,
      markPerQuestion: (data['mark_per_question'] ?? json['mark_per_question'])
          ?.toString(),
      negativeMarks: (data['negative_marks'] ?? json['negative_marks'])
          ?.toString(),
      timeTaken: (data['time_taken'] ?? json['time_taken'])?.toString(),
      lastViewedQuestionId:
          json['last_viewed_question_id'] as int? ??
          data['last_viewed_question_id'] as int?,
      attemptType: json['attempt_type'] as int? ?? data['attempt_type'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content_attempt_id': contentAttemptId,
      'userexam_id': userExamId,
      'date': date,
      'state': state,
      'remaining_time': remainingTime,
      'score': score,
      'correct_count': correctCount,
      'incorrect_count': incorrectCount,
      'total_questions': totalQuestions,
      'sections': sections?.map((s) => s.toJson()).toList(),
      'review_url': reviewUrl,
      'accuracy': accuracy,
      'percentile': percentile,
      'percentage': percentage,
      'rank': rank,
      'max_rank': maxRank,
      'rank_enabled': rankEnabled,
      'mark_per_question': markPerQuestion,
      'negative_marks': negativeMarks,
      'time_taken': timeTaken,
      'last_viewed_question_id': lastViewedQuestionId,
      'attempt_type': attemptType,
    };
  }

  bool get hasSectionalLock {
    if (sections == null || sections!.length < 2) {
      return false;
    }
    for (final section in sections!) {
      if (section.duration == null ||
          section.duration == '0:00:00' ||
          section.duration == '0') {
        return false;
      }
    }
    return true;
  }

  bool get hasNoSectionalLock => !hasSectionalLock;

  bool get isQuizMode => attemptType == 1;
}
