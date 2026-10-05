import 'paginated_response_dto.dart';

/// Live class status.
enum LiveClassStatus { completed, live, upcoming, cancelled }

/// Live class DTO — a scheduled or ongoing class session.
class LiveClassDto {
  final String id;
  final String title;
  final String courseName;
  final String start;
  final String? faculty;
  final String? provider;
  final LiveClassStatus status;
  final int? durationMinutes;

  const LiveClassDto({
    required this.id,
    String? title,
    String? topic,
    String? courseName,
    String? subject,
    String? start,
    String? time,
    this.faculty,
    this.provider,
    required this.status,
    this.durationMinutes,
  }) : title = title ?? topic ?? '',
       courseName = courseName ?? subject ?? '',
       start = start ?? time ?? '';

  /// Backward-compatibility aliases
  String get topic => title;
  String get subject => courseName;
  String get time => start;

  /// Parsed start DateTime from ISO 8601 string.
  DateTime? get startDateTime => DateTime.tryParse(start);

  /// Calculated end DateTime based on [startDateTime] and [durationMinutes].
  DateTime? get endDateTime =>
      startDateTime != null && durationMinutes != null && durationMinutes! > 0
      ? startDateTime!.add(Duration(minutes: durationMinutes!))
      : null;

  factory LiveClassDto.fromJson(Map<String, dynamic> json, String courseName) {
    final statusStr = json['status'] as String? ?? 'upcoming';
    final statusVal = switch (statusStr) {
      'live' => LiveClassStatus.live,
      'completed' => LiveClassStatus.completed,
      'cancelled' => LiveClassStatus.cancelled,
      _ => LiveClassStatus.upcoming,
    };

    final startTimeStr = json['start'] as String? ?? '';
    final providerStr = json['provider'] as String?;
    final durationInt = json['duration'] as int? ?? 0;

    return LiveClassDto(
      id: (json['id'] ?? '').toString(),
      title: json['title'] as String? ?? '',
      courseName: courseName,
      start: startTimeStr,
      faculty: json['faculty'] as String?,
      provider: providerStr,
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
