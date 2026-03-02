import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:data/data.dart';
import '../models/course_content.dart';

part 'lesson_detail_provider.g.dart';

/// Provider that fetches a specific lesson domain model by its ID.
///
/// This provider searches through all chapters of all enrolled courses
/// to find the matching [LessonDto] and maps it to the domain [Lesson].
@riverpod
Future<Lesson?> lessonDetail(LessonDetailRef ref, String lessonId) async {
  final enrollment = await ref.watch(enrollmentProvider.future);

  for (final course in enrollment) {
    // 1. Fetch chapters for the course
    final chapters = await ref.watch(courseChaptersProvider(course.id).future);

    for (final chapter in chapters) {
      // 2. Fetch lessons for the chapter
      final lessons = await ref.watch(
        chapterLessonsProvider(chapter.id).future,
      );

      // 3. Find matching lesson ID
      final lessonDto = lessons.where((l) => l.id == lessonId).firstOrNull;

      if (lessonDto != null) {
        // 4. Map to domain model with rich content
        return Lesson(
          id: lessonDto.id,
          title: lessonDto.title,
          type: lessonDto.type,
          progressStatus: lessonDto.progressStatus,
          duration: lessonDto.duration,
          isLocked: lessonDto.isLocked,
          subtitle: lessonDto.subtitle,
          subjectName: lessonDto.subjectName,
          subjectIndex: lessonDto.subjectIndex,
          lessonNumber: lessonDto.lessonNumber,
          totalLessons: lessonDto.totalLessons,
          content: lessonDto.content.map(LessonContentItem.fromDto).toList(),
        );
      }
    }
  }

  // Not found in current enrollment
  return null;
}
