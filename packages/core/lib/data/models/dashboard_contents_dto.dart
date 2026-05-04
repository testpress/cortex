import '../db/tables/dashboard_tables.dart';

/// Lightweight DTO for a single item in the dashboard feed.
class DashboardContentDto {
  final String id;
  final String title;
  final String? chapterId;
  final String? chapterTitle;
  final DashboardContentType contentType;
  final DashboardSectionType? sectionType;
  final String? duration;
  final String? coverImage;
  final double? progress;

  const DashboardContentDto({
    required this.id,
    required this.title,
    this.chapterId,
    this.chapterTitle,
    required this.contentType,
    this.sectionType,
    this.duration,
    this.coverImage,
    this.progress,
  });

  factory DashboardContentDto.fromJson(
    Map<String, dynamic> json, {
    Map<String, String>? chapterMap,
    DashboardSectionType? sectionType,
  }) {
    final chapterId = json['chapter_id']?.toString() ?? json['chapter']?.toString();
    return DashboardContentDto(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      chapterId: chapterId,
      chapterTitle: chapterMap?[chapterId],
      contentType: _mapContentType((json['content_type'] ?? json['type'] ?? 'unknown').toString()),
      duration: json['duration'],
      coverImage: json['cover_image'] ?? json['image'],
      progress: (json['progress'] as num?)?.toDouble(),
      sectionType: sectionType,
    );
  }

  static DashboardContentType _mapContentType(String type) {
    final t = type.toLowerCase();
    if (t.contains('video')) return DashboardContentType.video;
    if (t.contains('pdf')) return DashboardContentType.pdf;
    if (t.contains('notes') || t.contains('html')) return DashboardContentType.notes;
    if (t.contains('test') || t.contains('exam')) return DashboardContentType.test;
    if (t.contains('assessment') || t.contains('quiz')) return DashboardContentType.assessment;
    if (t.contains('live')) return DashboardContentType.liveStream;
    if (t.contains('attachment')) return DashboardContentType.attachment;
    if (t.contains('embed')) return DashboardContentType.embedContent;
    
    return DashboardContentType.unknown;
  }
}

/// Container for the dashboard contents list.
class DashboardContentsDto {
  final List<DashboardContentDto> items;

  const DashboardContentsDto({required this.items});

  factory DashboardContentsDto.fromJson(
    Map<String, dynamic> json, {
    required DashboardSectionType sectionType,
  }) {
    final results = json['results'] ?? json;
    
    // 1. Create a map of chapter IDs to names for easy lookup
    final chaptersList = (results['chapters'] ?? []) as List;
    final chapterMap = {
      for (var chapter in chaptersList)
        chapter['id'].toString(): chapter['name']?.toString() ?? ''
    };

    // 2. Map the contents (lessons) and resolve their chapter titles
    final contentsList = (results['chapter_contents'] ?? results['contents'] ?? []) as List;
    final items = contentsList
        .map((e) => DashboardContentDto.fromJson(
              e as Map<String, dynamic>,
              chapterMap: chapterMap,
              sectionType: sectionType,
            ))
        .toList();

    return DashboardContentsDto(items: items);
  }
}
