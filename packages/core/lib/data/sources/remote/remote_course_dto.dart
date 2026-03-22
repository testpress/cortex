import 'package:core/data/data.dart';

/// API-layer DTO for a single course from the `/api/v3/courses/` endpoint.
///
/// This is the *only* place in the codebase that knows about backend
/// field names and JSON structure. It has one job: parse raw API JSON
/// and produce a clean [CourseDto] domain object via [toDomain].
///
/// Do NOT use this class outside of [HttpDataSource].
class RemoteCourseDto {
  final String id;
  final String title;
  final int colorIndex;
  final int chaptersCount;
  final String totalDuration;
  final int totalContents;
  final int progress;
  final int completedLessonsCount;
  final int totalLessonsCount;
  final String? image;

  const RemoteCourseDto({
    required this.id,
    required this.title,
    required this.colorIndex,
    required this.chaptersCount,
    required this.totalDuration,
    required this.totalContents,
    required this.progress,
    required this.completedLessonsCount,
    required this.totalLessonsCount,
    this.image,
  });

  /// The 'Messy Adapter': Handles Testpress-specific inconsistencies
  /// in the paginated response before letting the core logic see it.
  static PaginatedResponseDto<CourseDto> fromPaginatedJson(
    Map<String, dynamic> json,
  ) {
    // 1. Testpress Quirk: Sometimes 'results' is a Map with a nested 'courses' List.
    // We normalize it here so the generic PaginatedResponseDto stays clean.
    final results = json['results'];
    final normalizedJson = Map<String, dynamic>.from(json);

    if (results is Map<String, dynamic> && results['courses'] is List) {
      normalizedJson['results'] = results['courses'];
    }

    // 2. Pass the normalized (clean) JSON to the generic parser
    return PaginatedResponseDto.fromJson(
      normalizedJson,
      (m) => RemoteCourseDto.fromJson(m).toDomain(),
    );
  }

  /// Parses a raw API course JSON object.
  ///
  /// Expected API response shape:
  /// ```json
  /// {
  ///   "id": 3,
  ///   "title": "Introduction to AI",
  ///   "color_index": 2,
  ///   "chapters_count": 5,
  ///   "total_duration": "12h",
  ///   "progress": 0,
  ///   "completed_lessons_count": 0,
  ///   "total_lessons_count": 22,
  ///   "image": "https://cdn.example.com/img.jpg"
  /// }
  /// ```
  factory RemoteCourseDto.fromJson(Map<String, dynamic> json) {
    return RemoteCourseDto(
      id: (json['id'] as Object).toString(),
      title: json['title'] as String? ?? '',
      colorIndex: json['color_index'] as int? ?? 0,
      chaptersCount: json['chapters_count'] as int? ?? 0,
      totalDuration: json['total_duration'] as String? ?? '',
      totalContents: (json['contents_count'] ??
              json['total_contents'] ??
              json['total_lessons_count']) as int? ??
          0,
      progress: json['progress'] as int? ?? 0,
      completedLessonsCount: json['completed_lessons_count'] as int? ?? 0,
      totalLessonsCount: json['total_lessons_count'] as int? ?? 0,
      image: json['image'] as String?,
    );
  }

  /// Maps this API model to the clean domain [CourseDto].
  CourseDto toDomain() {
    return CourseDto(
      id: id,
      title: title,
      colorIndex: colorIndex,
      chapterCount: chaptersCount,
      totalDuration: totalDuration,
      totalContents: totalContents,
      progress: progress,
      completedLessons: completedLessonsCount,
      totalLessons: totalLessonsCount,
      image: image,
    );
  }
}
