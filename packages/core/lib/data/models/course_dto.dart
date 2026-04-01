import 'chapter_dto.dart';

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
  final String totalDuration;
  final int progress; // 0–100
  final int completedLessons;
  final int totalLessons;
  final String? image;
  final List<ChapterDto> chapters;

  const CourseDto({
    required this.id,
    required this.title,
    required this.colorIndex,
    required this.chapterCount,
    required this.totalDuration,
    required this.progress,
    required this.completedLessons,
    required this.totalLessons,
    this.image,
    this.chapters = const [],
  });

  CourseDto copyWith({
    String? id,
    String? title,
    int? colorIndex,
    int? chapterCount,
    String? totalDuration,
    int? progress,
    int? completedLessons,
    int? totalLessons,
    String? image,
    List<ChapterDto>? chapters,
  }) {
    return CourseDto(
      id: id ?? this.id,
      title: title ?? this.title,
      colorIndex: colorIndex ?? this.colorIndex,
      chapterCount: chapterCount ?? this.chapterCount,
      totalDuration: totalDuration ?? this.totalDuration,
      progress: progress ?? this.progress,
      completedLessons: completedLessons ?? this.completedLessons,
      totalLessons: totalLessons ?? this.totalLessons,
      image: image ?? this.image,
      chapters: chapters ?? this.chapters,
    );
  }

  factory CourseDto.fromJson(Map<String, dynamic> json) {
    return CourseDto(
      id: (json['id'] as Object).toString(),
      title: json['title'] as String? ?? 'Untitled Course',
      colorIndex: json['color_index'] as int? ?? 0,
      chapterCount: json['chapters_count'] as int? ?? 0,
      totalDuration: json['total_duration'] as String? ?? '',
      progress: json['progress'] as int? ?? 0,
      completedLessons: json['completed_lessons_count'] as int? ?? 0,
      totalLessons: json['total_lessons_count'] as int? ?? 0,
      image: json['image'] as String?,
      chapters: (json['chapters'] as List<dynamic>?)
              ?.map((e) => ChapterDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'colorIndex': colorIndex,
      'chapterCount': chapterCount,
      'totalDuration': totalDuration,
      'progress': progress,
      'completedLessons': completedLessons,
      'totalLessons': totalLessons,
      'image': image,
      'chapters': chapters.map((e) => e.toJson()).toList(),
    };
  }
}
