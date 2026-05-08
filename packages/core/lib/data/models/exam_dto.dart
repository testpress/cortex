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
  });

  factory ExamDto.fromJson(Map<String, dynamic> json) {
    return ExamDto(
      id: (json['id'] ?? '').toString(),
      slug: json['slug'] as String?,
      title: json['title'] as String? ?? '',
      duration: json['duration'] as String? ?? '01:00:00',
      questionCount: (json['questions_count'] ?? json['number_of_questions']) as int? ?? 0,
      hasInstructions: json['has_instructions'] as bool? ?? false,
      attemptsUrl: json['attempts_url'] as String? ?? '',
      state: json['state'] as String?,
      markPerQuestion: json['mark_per_question'] as String?,
      negativeMarks: json['negative_marks'] as String?,
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
    };
  }
}
