import 'chapter_dto.dart';
import 'lesson_dto.dart';

/// One-time authoritative hierarchy snapshot for a course curriculum.
/// Used as the input for structural mapping and descendant resolution.
/// This prevents dependency on partially-synced database folders.
class CourseCurriculumDto {
  final List<ChapterDto> chapters;
  final List<LessonDto> lessons;

  const CourseCurriculumDto({
    this.chapters = const [],
    this.lessons = const [],
  });

  bool get isEmpty => chapters.isEmpty && lessons.isEmpty;

  /// Creates a copy of this snapshot with new entities.
  CourseCurriculumDto copyWith({
    List<ChapterDto>? chapters,
    List<LessonDto>? lessons,
  }) {
    return CourseCurriculumDto(
      chapters: chapters ?? this.chapters,
      lessons: lessons ?? this.lessons,
    );
  }
}
