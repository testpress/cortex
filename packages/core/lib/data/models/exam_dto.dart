/// Exam DTO — represents a single exam's metadata.
class ExamDto {
  final String id;
  final String? slug;
  final String title;
  final String duration;
  final int questionCount;
  final bool hasInstructions;
  final String attemptsUrl;
  final String? state;
  final String? markPerQuestion;
  final String? negativeMarks;
  final int pausedAttemptsCount;
  final bool disableAttemptResume;
  final bool allowRetake;
  final int maxRetakes;

  const ExamDto({
    required this.id,
    this.slug,
    required this.title,
    required this.duration,
    required this.questionCount,
    this.hasInstructions = false,
    required this.attemptsUrl,
    this.state,
    this.markPerQuestion,
    this.negativeMarks,
    this.pausedAttemptsCount = 0,
    this.disableAttemptResume = false,
    this.allowRetake = true,
    this.maxRetakes = -1,
  });

  factory ExamDto.fromJson(Map<String, dynamic> json) {
    return ExamDto(
      id: (json['id'] ?? '').toString(),
      slug: json['slug'] as String?,
      title: json['title'] as String? ?? '',
      duration: json['duration'] as String? ?? '01:00:00',
      questionCount:
          (json['questions_count'] ?? json['number_of_questions']) as int? ?? 0,
      hasInstructions: json['has_instructions'] as bool? ?? false,
      attemptsUrl: json['attempts_url'] as String? ?? '',
      state: json['state'] as String?,
      markPerQuestion: json['mark_per_question'] as String?,
      negativeMarks: json['negative_marks'] as String?,
      pausedAttemptsCount: json['paused_attempts_count'] as int? ?? 0,
      disableAttemptResume: json['disable_attempt_resume'] as bool? ?? false,
      allowRetake: json['allow_retake'] as bool? ?? true,
      maxRetakes: json['max_retakes'] as int? ?? -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'title': title,
      'duration': duration,
      'questions_count': questionCount,
      'has_instructions': hasInstructions,
      'attempts_url': attemptsUrl,
      'state': state,
      'mark_per_question': markPerQuestion,
      'negative_marks': negativeMarks,
      'paused_attempts_count': pausedAttemptsCount,
      'disable_attempt_resume': disableAttemptResume,
      'allow_retake': allowRetake,
      'max_retakes': maxRetakes,
    };
  }
}
