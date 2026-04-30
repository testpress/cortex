import '../../data/models/chapter_dto.dart';
import '../../data/models/course_curriculum_dto.dart';
import '../../data/models/lesson_dto.dart';

/// Specialist class for parsing complex curriculum and lesson responses 
/// from various Testpress API versions (V2.5, V3, etc.).
class CurriculumParser {
  /// Parses the full hierarchy (chapters and lessons) from a course contents response.
  /// This provides the authoritative "blueprint" for the projection layer.
  static CourseCurriculumDto parseFullCurriculum(dynamic data, {String? chapterId}) {
    final lessons = mapLessons(data, chapterId: chapterId);
    final List<ChapterDto> chapters = [];

    if (data is Map) {
      final results = data['results'] ?? data;
      final chaptersListRaw = (results is Map) ? results['chapters'] : data['chapters'];
      final chaptersList = chaptersListRaw as List<dynamic>?;

      if (chaptersList != null) {
        for (var c in chaptersList) {
          if (c is Map<String, dynamic>) {
            chapters.add(ChapterDto.fromJson(c));
          }
        }
      }
    }

    return CourseCurriculumDto(
      lessons: lessons,
      chapters: chapters,
    );
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
      final dto = parseLesson(json);

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

  static LessonType parseType(dynamic value) {
    final s = value?.toString().toLowerCase() ?? '';
    if (s.contains('video') || s.contains('live') || s.contains('conference')) return LessonType.video;
    if (s.contains('pdf') || s.contains('notes') || s.contains('attachment')) return LessonType.pdf;
    if (s.contains('exam') || s.contains('test')) return LessonType.test;
    if (s.contains('quiz') || s.contains('assessment')) return LessonType.assessment;
    return LessonType.video;
  }

  static LessonProgressStatus parseStatus(dynamic value) {
    final s = value?.toString().toLowerCase();
    if (s == 'completed' || s == '1') return LessonProgressStatus.completed;
    if (s == 'in_progress' || s == 'started' || s == '0') return LessonProgressStatus.inProgress;
    return LessonProgressStatus.notStarted;
  }

  static LessonDto parseLesson(Map<String, dynamic> json) {
    String? getString(String key) => json[key]?.toString();

    final chapterId = () {
      final val = json['chapter_id'] ?? json['chapter'] ?? json['chapterId'];
      if (val is Map) return val['id']?.toString() ?? '';
      return val?.toString() ?? '';
    }();

    return LessonDto(
      id: getString('id') ?? '',
      chapterId: chapterId,
      title: json['title'] as String? ?? json['name'] as String? ?? '',
      type: parseType(json['content_type'] ?? json['type'] ?? json['kind']),
      duration: json['duration'] as String? ?? '',
      progressStatus: parseStatus(json['state'] ?? json['progressStatus']),
      isLocked: !(json['active'] as bool? ?? json['isLocked'] == false),
      orderIndex: (json['order'] as num?)?.toInt() ?? (json['orderIndex'] as num?)?.toInt() ?? 0,
      chapterTitle: json['chapter_title'] as String? ?? json['chapterTitle'] as String?,
      contentUrl: json['content_url'] as String? ?? json['url'] as String? ?? json['contentUrl'] as String?,
      subtitle: json['subtitle'] as String?,
      subjectName: json['subject_name'] as String? ?? json['subjectName'] as String?,
      subjectIndex: (json['subject_index'] as num?)?.toInt() ?? (json['subjectIndex'] as num?)?.toInt(),
      lessonNumber: (json['lesson_number'] as num?)?.toInt() ?? (json['lessonNumber'] as num?)?.toInt(),
      totalLessons: (json['total_lessons'] as num?)?.toInt() ?? (json['totalLessons'] as num?)?.toInt(),
      isBookmarked: json['is_bookmarked'] as bool? ?? json['isBookmarked'] as bool? ?? false,
      image: json['icon'] as String? ?? json['image'] as String?,
    );
  }
}
