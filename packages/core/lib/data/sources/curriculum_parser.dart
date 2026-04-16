import '../../data/models/lesson_dto.dart';

/// Specialist class for parsing complex curriculum and lesson responses 
/// from various Testpress API versions (V2.5, V3, etc.).
class CurriculumParser {
  /// Maps raw API data into a clean list of [LessonDto]s.
  /// Handles metadata enrichment (chapter names) and structure normalization.
  static List<LessonDto> mapLessons(dynamic data, {String? chapterId}) {
    if (data is! Map) {
      if (data is List) {
        return data
            .map((e) => LessonDto.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    }

    final results = data['results'];
    List<dynamic>? list;
    Map<String, String> chapterNames = {};

    if (results is Map) {
      // Handle both V2.5 (chapter_contents) and V3 (contents) structures
      list = (results['contents'] ??
          results['chapter_contents'] ??
          results['results']) as List<dynamic>?;

      // Extract chapter metadata if available to enrich lessons
      final chaptersList = results['chapters'] as List<dynamic>?;
      if (chaptersList != null) {
        for (var c in chaptersList) {
          final id = c['id']?.toString();
          final name = c['name'] as String?;
          if (id != null && name != null) chapterNames[id] = name;
        }
      }
    } else if (results is List) {
      list = results;
    }

    // Default to the outer results if the inner detection failed
    list ??= (data['results'] ?? data['contents'] ?? data['chapter_contents'])
        as List<dynamic>?;

    return list?.map((e) {
      final json = e as Map<String, dynamic>;

      // Filter out curriculum items that are actually chapters
      final type = (json['content_type'] ?? json['type'] ?? json['kind'])
          ?.toString()
          .toLowerCase();
      if (type == 'chapter') return null;

      final dto = LessonDto.fromJson(json);

      // Enrich with chapter title if we found it in the metadata
      if (dto.chapterTitle == null || dto.chapterTitle!.isEmpty) {
        final name = chapterNames[dto.chapterId] ??
            chapterNames[json['chapter']?.toString() ?? ''];
        if (name != null) return dto.copyWith(chapterTitle: name);
      }

      // Enforce specific chapter ID if provided
      if (chapterId != null && (dto.chapterId.isEmpty || dto.chapterId == '0')) {
        return dto.copyWith(chapterId: chapterId);
      }

      return dto;
    }).whereType<LessonDto>().toList() ?? [];
  }
}
