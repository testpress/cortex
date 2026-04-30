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
  @Deprecated('Use totalContents instead')
  final String totalDuration;
  final int totalContents;
  final int progress; // 0–100
  final int completedLessons;
  final int totalLessons;
  final String? image;
  final List<String> tags;
  final List<String> allowedDevices;
  final List<int> tagIds;
  final int examsCount;
  final List<ChapterDto> chapters;

  const CourseDto({
    required this.id,
    required this.title,
    required this.colorIndex,
    required this.chapterCount,
    required this.totalDuration,
    required this.totalContents,
    required this.progress,
    required this.completedLessons,
    required this.totalLessons,
    this.tags = const [],
    this.allowedDevices = const [],
    this.tagIds = const [],
    this.examsCount = 0,
    this.image,
    this.isChaptersSynced = false,
    this.chapters = const [],
  });

  final bool isChaptersSynced;

  CourseDto copyWith({
    String? id,
    String? title,
    int? colorIndex,
    int? chapterCount,
    String? totalDuration,
    int? totalContents,
    int? progress,
    int? completedLessons,
    int? totalLessons,
    String? image,
    List<String>? tags,
    List<String>? allowedDevices,
    List<int>? tagIds,
    int? examsCount,
    bool? isChaptersSynced,
    List<ChapterDto>? chapters,
  }) {
    return CourseDto(
      id: id ?? this.id,
      title: title ?? this.title,
      colorIndex: colorIndex ?? this.colorIndex,
      chapterCount: chapterCount ?? this.chapterCount,
      totalDuration: totalDuration ?? this.totalDuration,
      totalContents: totalContents ?? this.totalContents,
      progress: progress ?? this.progress,
      completedLessons: completedLessons ?? this.completedLessons,
      totalLessons: totalLessons ?? this.totalLessons,
      image: image ?? this.image,
      tags: tags ?? this.tags,
      allowedDevices: allowedDevices ?? this.allowedDevices,
      tagIds: tagIds ?? this.tagIds,
      examsCount: examsCount ?? this.examsCount,
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
      totalDuration: json['total_duration'] as String? ?? '',
      totalContents: json['contents_count'] as int? ?? 0,
      progress: json['progress'] as int? ?? 0,
      completedLessons: json['completed_lessons_count'] as int? ?? 0,
      totalLessons: json['contents_count'] as int? ?? 0,
      image: json['image'] as String?,
      tags: _parseList(json['tags']),
      allowedDevices: _parseList(json['allowed_devices']),
      tagIds: (json['tag_ids'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
      examsCount: json['exams_count'] as int? ?? 0,
      isChaptersSynced: json['isChaptersSynced'] as bool? ?? false,
      chapters:
          (json['chapters'] as List<dynamic>?)
              ?.map((e) => ChapterDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
    print('DEBUG_PARSE: Course ${dto.id} ("${dto.title}") tags: ${dto.tags}, tagIds: ${dto.tagIds}, examsCount: ${dto.examsCount}, allowedDevices: ${dto.allowedDevices}');
    return dto;
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
      'totalDuration': totalDuration,
      'totalContents': totalContents,
      'progress': progress,
      'completedLessons': completedLessons,
      'totalLessons': totalLessons,
      'image': image,
      'tags': tags,
      'allowed_devices': allowedDevices,
      'isChaptersSynced': isChaptersSynced,
      'chapters': chapters.map((e) => e.toJson()).toList(),
    };
  }
}
