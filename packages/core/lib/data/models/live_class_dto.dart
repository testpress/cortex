/// Live class status.
enum LiveClassStatus { completed, live, upcoming }

/// Live class DTO — a scheduled or ongoing class session.
class LiveClassDto {
  final String id;
  final String subject;
  final String topic;
  final String time; // e.g. "10:00 AM - 12:00 PM"
  final String faculty;
  final LiveClassStatus status;

  const LiveClassDto({
    required this.id,
    required this.subject,
    required this.topic,
    required this.time,
    required this.faculty,
    required this.status,
  });
}
