/// Exam DTO — represents a single exam's metadata.
class ExamDto {
  final String id;
  final String title;
  final String duration;
  final int questionCount;
  final bool hasInstructions;
  final String attemptsUrl;

  const ExamDto({
    required this.id,
    required this.title,
    required this.duration,
    required this.questionCount,
    this.hasInstructions = false,
    required this.attemptsUrl,
  });

  factory ExamDto.fromJson(Map<String, dynamic> json) {
    return ExamDto(
      id: (json['id'] ?? '').toString(),
      title: json['title'] as String? ?? '',
      duration: json['duration'] as String? ?? '01:00:00',
      questionCount: json['questions_count'] as int? ?? 0,
      hasInstructions: json['has_instructions'] as bool? ?? false,
      attemptsUrl: json['attempts_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'questions_count': questionCount,
      'has_instructions': hasInstructions,
      'attempts_url': attemptsUrl,
    };
  }
}
