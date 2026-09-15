import 'chapter_dto.dart';
import 'paginated_response_dto.dart';

/// Course DTO — plain Dart object transferred from DataSource to Drift and back to UI.
///
/// Field mapping is based on the Testpress `/api/v3/courses/` response contract,
/// which uses snake_case keys. If the API contract changes, update ONLY this file.
class CourseDto {
  final String id;
  final String title;

  /// Index into [DesignSubjectPalette]. The design system resolves this to
  /// a [SubjectColors] via `Design.of(context).subjectPalette.atIndex(colorIndex)`.
  /// Provided by the API; does NOT encode a subject name — works for any tenant.
  final int colorIndex;

  final int chapterCount;
  final int totalContents;
  final double? progress; // 0.0–100.0, null if absent in API response
  final int? completedLessons;
  final String? image;
  final List<String> tags;
  final List<String> allowedDevices;
  final int examsCount;
  final int order;
  final List<ChapterDto> chapters;

  const CourseDto({
    required this.id,
    required this.title,
    required this.colorIndex,
    required this.chapterCount,
    required this.totalContents,
    this.progress,
    this.completedLessons,
    this.tags = const [],
    this.allowedDevices = const [],
    this.examsCount = 0,
    this.order = 0,
    this.image,
    this.isChaptersSynced = false,
    this.chapters = const [],
  });

  final bool isChaptersSynced;

  String get formattedProgress {
    final p = progress ?? 0.0;
    if (!p.isFinite) {
      return '0%';
    }
    if (p % 1 == 0) {
      return '${p.toInt()}%';
    }
    return '${p.toStringAsFixed(2)}%';
  }

  /// Merges this DTO with another (typically locally cached) DTO to preserve
  /// user progress and sync state when refreshing from detail endpoints.
  CourseDto mergeWith(CourseDto? other) {
    if (other == null) return this;
    return copyWith(
      progress: progress ?? other.progress,
      completedLessons: completedLessons ?? other.completedLessons,
      isChaptersSynced: isChaptersSynced || other.isChaptersSynced,
    );
  }

  CourseDto copyWith({
    String? id,
    String? title,
    int? colorIndex,
    int? chapterCount,
    int? totalContents,
    double? progress,
    int? completedLessons,
    String? image,
    List<String>? tags,
    List<String>? allowedDevices,
    int? examsCount,
    int? order,
    bool? isChaptersSynced,
    List<ChapterDto>? chapters,
  }) {
    return CourseDto(
      id: id ?? this.id,
      title: title ?? this.title,
      colorIndex: colorIndex ?? this.colorIndex,
      chapterCount: chapterCount ?? this.chapterCount,
      totalContents: totalContents ?? this.totalContents,
      progress: progress ?? this.progress,
      completedLessons: completedLessons ?? this.completedLessons,
      image: image ?? this.image,
      tags: tags ?? this.tags,
      allowedDevices: allowedDevices ?? this.allowedDevices,
      examsCount: examsCount ?? this.examsCount,
      order: order ?? this.order,
      isChaptersSynced: isChaptersSynced ?? this.isChaptersSynced,
      chapters: chapters ?? this.chapters,
    );
  }

  factory CourseDto.fromJson(Map<String, dynamic> json) {
    final dto = CourseDto(
      id: (json['id'] ?? '').toString(),
      title: json['title'] as String? ?? 'Untitled Course',
      colorIndex: json['color_index'] as int? ?? 0,
      chapterCount: json['chapters_count'] as int? ?? 0,
      totalContents: json['contents_count'] as int? ?? 0,
      progress: (json['progress'] as num?)?.toDouble(),
      completedLessons: json['completed_lessons_count'] as int?,
      image: json['image'] as String?,
      tags: _parseList(json['tags']),
      allowedDevices: _parseList(json['allowed_devices']),
      examsCount: json['exams_count'] as int? ?? 0,
      order: json['order'] as int? ?? 0,
      isChaptersSynced: json['isChaptersSynced'] as bool? ?? false,
      chapters:
          (json['chapters'] as List<dynamic>?)
              ?.map((e) => ChapterDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
    return dto;
  }

  static PaginatedResponseDto<CourseDto> fromListResponse(
    Map<String, dynamic> json,
  ) {
    final response = PaginatedResponseDto<CourseDto>.fromJson(
      json,
      (item) => CourseDto.fromJson(item),
    );

    final credits = response.userCourseCredits;
    if (credits == null || credits.isEmpty) return response;

    final creditsMap = <String, Map<dynamic, dynamic>>{
      for (final credit in credits.whereType<Map>())
        if (credit['course_id'] != null) credit['course_id'].toString(): credit,
    };

    final enrichedResults = response.results.map((dto) {
      final credit = creditsMap[dto.id];
      if (credit == null) {
        return dto.copyWith(
          progress: dto.progress ?? 0.0,
          completedLessons: dto.completedLessons ?? 0,
        );
      }
      return dto.copyWith(
        progress:
            (credit['course_completion_percentage'] as num? ??
                    dto.progress ??
                    0.0)
                .toDouble(),
        completedLessons:
            (credit['total_unique_attempts'] as num? ??
                    dto.completedLessons ??
                    0)
                .toInt(),
      );
    }).toList();

    return PaginatedResponseDto<CourseDto>(
      results: enrichedResults,
      next: response.next,
      previous: response.previous,
      count: response.count,
      userCourseCredits: response.userCourseCredits,
    );
  }

  static List<String> _parseList(dynamic value) {
    if (value == null) return const [];
    if (value is List) return value.map((e) => e.toString()).toList();
    if (value is String) {
      if (value.isEmpty) return const [];
      return value.split(',').map((e) => e.trim()).toList();
    }
    return const [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'colorIndex': colorIndex,
      'chapterCount': chapterCount,
      'totalContents': totalContents,
      'progress': progress,
      'completedLessons': completedLessons,
      'image': image,
      'tags': tags,
      'allowed_devices': allowedDevices,
      'order': order,
      'isChaptersSynced': isChaptersSynced,
      'chapters': chapters.map((e) => e.toJson()).toList(),
    };
  }
}
