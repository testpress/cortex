import 'package:data/data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'course_detail_provider.g.dart';

/// Provider that fetches a specific course with its full curriculum (chapters and lessons).
///
/// This provider composes lower-level data providers from the `data` package
/// to build a complete [CourseDto] hierarchy.
@riverpod
CourseDto? courseDetail(CourseDetailRef ref, String courseId) {
  final enrollment = ref.watch(enrollmentProvider).valueOrNull;
  if (enrollment == null) return null;

  final course = enrollment.where((c) => c.id == courseId).firstOrNull;
  if (course == null) return null;

  // Watch chapters for this course
  final chapters =
      ref.watch(courseChaptersProvider(courseId)).valueOrNull ?? [];

  // Watch lessons for each chapter and combine them
  final chaptersWithLessons = chapters.map((chapter) {
    final lessons =
        ref.watch(chapterLessonsProvider(chapter.id)).valueOrNull ?? [];
    return chapter.copyWith(
      lessons: lessons
          .map((l) => l.copyWith(chapterTitle: chapter.title))
          .toList(),
    );
  }).toList();

  return course.copyWith(chapters: chaptersWithLessons);
}

/// A provider that flattens all lessons for a specific course into a single list.
/// Used for filtering lessons by type across the entire course.
@riverpod
List<LessonDto> allCourseLessons(AllCourseLessonsRef ref, String courseId) {
  final course = ref.watch(courseDetailProvider(courseId));
  if (course == null) return [];

  return course.chapters.expand((chapter) => chapter.lessons).toList();
}
