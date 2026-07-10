import '../../data/models/chapter_dto.dart';
import '../../data/models/course_curriculum_dto.dart';
import '../../data/models/lesson_dto.dart';

/// Specialist class for parsing complex curriculum and lesson responses
/// from various Testpress API versions (V2.5, V3, etc.).
class CurriculumParser {
  /// Parses the full hierarchy (chapters and lessons) from a course contents response.
  /// This provides the authoritative "blueprint" for the projection layer.
  static CourseCurriculumDto parseFullCurriculum(
    dynamic data, {
    String? chapterId,
  }) {
    var lessons = mapLessons(data, chapterId: chapterId);
    final List<ChapterDto> chapters = [];

    if (data is Map) {
      final results = data['results'] ?? data;
      if (results is Map) {
        // Filter lessons to only those with actual attempts if this is an attempts sync payload
        if (results.containsKey('content_attempts')) {
          final attempts = results['content_attempts'] as List?;
          final Map<String, bool> completedAttempts = {};
          if (attempts != null) {
            for (var a in attempts) {
              if (a is Map) {
                final contentId = a['chapter_content_id']?.toString();
                if (contentId != null) {
                  final attemptData =
                      a['assessment'] as Map? ?? a['attempt'] as Map? ?? a;
                  final stateVal = attemptData['state'];
                  final isCompleted =
                      stateVal?.toString() == '1' ||
                      stateVal?.toString().toLowerCase() == 'completed';
                  if (isCompleted) {
                    completedAttempts[contentId] = true;
                  }
                }
              }
            }
          }

          lessons = lessons.map((l) {
            final isCompleted = completedAttempts[l.id] ?? false;
            return l.copyWith(
              hasAttempts: isCompleted,
              progressStatus: isCompleted
                  ? LessonProgressStatus.completed
                  : LessonProgressStatus.notStarted,
            );
          }).toList();
        }

        final chaptersListRaw = results['chapters'];
        final chaptersList = chaptersListRaw as List<dynamic>?;

        if (chaptersList != null) {
          for (var c in chaptersList) {
            if (c is Map<String, dynamic>) {
              chapters.add(ChapterDto.fromJson(c));
            }
          }
        }
      }
    }

    return CourseCurriculumDto(lessons: lessons, chapters: chapters);
  }

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
      list =
          (results['contents'] ??
                  results['chapter_contents'] ??
                  results['results'])
              as List<dynamic>?;

      // Extract chapter metadata if available to enrich lessons
      final chaptersList = results['chapters'] as List<dynamic>?;
      if (chaptersList != null) {
        for (var c in chaptersList) {
          final id = c['id']?.toString();
          final name = c['name'] as String?;
          if (id != null && name != null) chapterNames[id] = name;
        }
      }

      // Merge side-loaded entities for V3 API
      final sideLoadedMappings = {
        'attachments': ('attachment_id', 'attachment'),
        'videos': ('video_id', 'video'),
        'exams': ('exam_id', 'exam'),
        'live_streams': ('live_stream_id', 'live_stream'),
        'video_conferences': ('video_conference_id', 'video_conference'),
        'text_contents': ('html_content_id', 'html_content'),
      };

      for (final entry in sideLoadedMappings.entries) {
        final listKey = entry.key;
        final idKey = entry.value.$1;
        final objectKey = entry.value.$2;

        final itemList = results[listKey] as List<dynamic>?;
        if (itemList != null && list != null) {
          final itemById = {
            for (var item in itemList)
              if (item is Map) item['id']?.toString(): item,
          };
          list = list.map((content) {
            if (content is Map<String, dynamic>) {
              final itemId = content[idKey]?.toString();
              if (itemId != null && itemById.containsKey(itemId)) {
                return Map<String, dynamic>.from(content)
                  ..[objectKey] = itemById[itemId];
              }
            }
            return content;
          }).toList();
        }
      }
    } else if (results is List) {
      list = results;
    }

    // Default to the outer results if the inner detection failed
    list ??=
        (data['results'] ?? data['contents'] ?? data['chapter_contents'])
            as List<dynamic>?;

    return list
            ?.map((e) {
              final json = e as Map<String, dynamic>;

              // Filter out curriculum items that are actually chapters
              final type =
                  (json['content_type'] ?? json['type'] ?? json['kind'])
                      ?.toString()
                      .toLowerCase();
              if (type == 'chapter') return null;
              final dto = LessonDto.fromJson(json);

              // Enrich with chapter title if we found it in the metadata
              if (dto.chapterTitle == null || dto.chapterTitle!.isEmpty) {
                final name =
                    chapterNames[dto.chapterId] ??
                    chapterNames[json['chapter']?.toString() ?? ''];
                if (name != null) return dto.copyWith(chapterTitle: name);
              }

              // Enforce specific chapter ID if provided
              if (chapterId != null &&
                  (dto.chapterId.isEmpty || dto.chapterId == '0')) {
                return dto.copyWith(chapterId: chapterId);
              }

              return dto;
            })
            .whereType<LessonDto>()
            .toList() ??
        [];
  }
}
