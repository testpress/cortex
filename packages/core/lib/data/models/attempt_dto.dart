/// Attempt DTO — represents an active or completed exam attempt.
class AttemptDto {
  final String id;
  final String? remainingTime;
  final String questionsUrl;
  final String heartbeatUrl;
  final String endUrl;

  const AttemptDto({
    required this.id,
    this.remainingTime,
    required this.questionsUrl,
    required this.heartbeatUrl,
    required this.endUrl,
  });

  factory AttemptDto.fromJson(Map<String, dynamic> json) {
    return AttemptDto(
      id: (json['id'] ?? '').toString(),
      remainingTime: json['remaining_time'] as String?,
      questionsUrl: json['questions_url'] as String? ?? '',
      heartbeatUrl: json['heartbeat_url'] as String? ?? '',
      endUrl: json['end_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'remaining_time': remainingTime,
      'questions_url': questionsUrl,
      'heartbeat_url': heartbeatUrl,
      'end_url': endUrl,
    };
  }
}
