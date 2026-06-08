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
  final int? questionsCount;

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
    this.questionsCount,
  });

  factory SectionDto.fromJson(Map<String, dynamic> json) {
    final info = json['info'] as Map<String, dynamic>?;

    return SectionDto(
      id: (json['id'] ?? '').toString(),
      name: (info?['name'] ?? json['name'] ?? '').toString(),
      state: (json['state'] ?? 'Not Started').toString(),
      questionsUrl: (json['questions_url'] ?? '').toString().replaceFirst(
        'v2.3',
        'v2.2.1',
      ),
      startUrl: json['start_url']?.toString().replaceFirst('v2.3', 'v2.2.1'),
      endUrl: json['end_url']?.toString().replaceFirst('v2.3', 'v2.2.1'),
      remainingTime: json['remaining_time']?.toString(),
      duration: (info?['duration'] ?? json['duration'])?.toString(),
      order: info?['order'] != null
          ? int.tryParse(info!['order'].toString()) ?? 0
          : (json['order'] != null
                ? int.tryParse(json['order'].toString()) ?? 0
                : 0),
      instructions: (info?['instructions'] ?? json['instructions'])?.toString(),
      questionsCount: info?['questions_count'] != null
          ? int.tryParse(info!['questions_count'].toString())
          : (json['questions_count'] != null
                ? int.tryParse(json['questions_count'].toString())
                : null),
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
      'questions_count': questionsCount,
    };
  }
}
