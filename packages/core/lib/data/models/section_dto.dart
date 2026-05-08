/// Section DTO — represents an attempt section within an exam.
class SectionDto {
  final String id;
  final String name;
  final String state;
  final String questionsUrl;
  final String? startUrl;
  final String? endUrl;
  final String? remainingTime;
  final String? duration;
  final int order;
  final String? instructions;

  const SectionDto({
    required this.id,
    required this.name,
    required this.state,
    required this.questionsUrl,
    this.startUrl,
    this.endUrl,
    this.remainingTime,
    this.duration,
    required this.order,
    this.instructions,
  });

  factory SectionDto.fromJson(Map<String, dynamic> json) {
    return SectionDto(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      state: (json['state'] ?? 'Not Started').toString(),
      questionsUrl: (json['questions_url'] ?? '').toString(),
      startUrl: json['start_url']?.toString(),
      endUrl: json['end_url']?.toString(),
      remainingTime: json['remaining_time']?.toString(),
      duration: json['duration']?.toString(),
      order: json['order'] != null ? int.tryParse(json['order'].toString()) ?? 0 : 0,
      instructions: json['instructions']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'state': state,
      'questions_url': questionsUrl,
      'start_url': startUrl,
      'end_url': endUrl,
      'remaining_time': remainingTime,
      'duration': duration,
      'order': order,
      'instructions': instructions,
    };
  }
}
