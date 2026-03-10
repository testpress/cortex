import 'package:data/data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'enrollment_provider.dart';
import 'course_list_provider.dart';

part 'course_detail_provider.g.dart';

/// Provider that fetches a specific course with its full curriculum (chapters and lessons).
///
/// This provider composes lower-level data providers from the `data` package
/// to build a complete [CourseDto] hierarchy.
@riverpod
Future<CourseDto?> courseDetail(CourseDetailRef ref, String courseId) async {
  final enrollment = await ref.watch(enrollmentProvider.future);
  final course = enrollment.where((c) => c.id == courseId).firstOrNull;
  if (course == null) return null;

  // Watch chapters for this course
  final chapters = await ref.watch(courseChaptersProvider(courseId).future);

  // Watch lessons for each chapter and combine them
  final chaptersWithLessons = await Future.wait(
    chapters.map((chapter) async {
      final lessons = await ref.watch(
        chapterLessonsProvider(chapter.id).future,
      );
      return chapter.copyWith(
        lessons: lessons
            .map((l) => l.copyWith(chapterTitle: chapter.title))
            .toList(),
      );
    }),
  );

  return course.copyWith(chapters: chaptersWithLessons);
}

/// A provider that flattens all lessons for a specific course into a single list.
/// Used for filtering lessons by type across the entire course.
@riverpod
Future<List<LessonDto>> allCourseLessons(
  AllCourseLessonsRef ref,
  String courseId,
) async {
  final course = await ref.watch(courseDetailProvider(courseId).future);
  if (course == null) return [];

  return course.chapters.expand((chapter) => chapter.lessons).toList();
}
