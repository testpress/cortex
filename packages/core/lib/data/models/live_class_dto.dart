import 'paginated_response_dto.dart';

/// Live class status.
enum LiveClassStatus { completed, live, upcoming, cancelled }

/// Live class DTO — a scheduled or ongoing class session.
class LiveClassDto {
  final String id;
  final String subject; // Course name
  final String topic; // Title
  final String time; // Start time ISO 8601 string
  final String faculty; // Provider / Faculty name
  final LiveClassStatus status;
  final int? durationMinutes;

  const LiveClassDto({
    required this.id,
    required this.subject,
    required this.topic,
    required this.time,
    required this.faculty,
    required this.status,
    this.durationMinutes,
  });

  factory LiveClassDto.fromJson(Map<String, dynamic> json, String courseName) {
    final statusStr = json['status'] as String? ?? 'upcoming';
    final statusVal = switch (statusStr) {
      'live' => LiveClassStatus.live,
      'completed' => LiveClassStatus.completed,
      'cancelled' => LiveClassStatus.cancelled,
      _ => LiveClassStatus.upcoming,
    };

    // Store start time as string
    final startTimeStr = json['start'] as String? ?? '';

    // Duration and provider info mapped to faculty column
    final providerStr = json['provider'] as String? ?? '';
    final durationInt = json['duration'] as int? ?? 0;
    final facultyStr = providerStr.isNotEmpty
        ? (durationInt > 0 ? '$providerStr • $durationInt mins' : providerStr)
        : (durationInt > 0 ? '$durationInt mins' : '');

    return LiveClassDto(
      id: (json['id'] ?? '').toString(),
      subject: courseName,
      topic: json['title'] as String? ?? '',
      time: startTimeStr,
      faculty: facultyStr,
      status: statusVal,
      durationMinutes: durationInt > 0 ? durationInt : null,
    );
  }

  static PaginatedResponseDto<LiveClassDto> fromListResponse(
    Map<String, dynamic> json,
  ) {
    final resultsObj = json['results'];

    final courseMap = <int, String>{};
    if (resultsObj is Map<String, dynamic>) {
      final coursesList = resultsObj['courses'] as List<dynamic>? ?? [];
      for (final c in coursesList.whereType<Map<String, dynamic>>()) {
        final id = c['id'] as int?;
        final title = c['title'] as String?;
        if (id != null && title != null) {
          courseMap[id] = title;
        }
      }
    }

    final List<dynamic> rawLiveClasses = (resultsObj is Map<String, dynamic>)
        ? (resultsObj['live_classes'] as List<dynamic>? ?? [])
        : (resultsObj is List ? resultsObj : const <dynamic>[]);

    final items = rawLiveClasses.whereType<Map<String, dynamic>>().map((c) {
      final courseId = c['course_id'] as int?;
      final courseName = courseMap[courseId] ?? 'General';
      return LiveClassDto.fromJson(c, courseName);
    }).toList();

    return PaginatedResponseDto<LiveClassDto>(
      results: items,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      count: json['count'] as int? ?? items.length,
    );
  }
}
