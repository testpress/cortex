import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import 'enrollment_provider.dart';

part 'lesson_providers.g.dart';

/// Flattens the course/chapter hierarchy into a single stream of all lessons.
/// This allows for efficient O(N) filtering in the UI.
@riverpod
List<LessonDto> allLessons(AllLessonsRef ref) {
  final courses = ref.watch(enrollmentProvider).asData?.value ?? [];
  return courses.expand((course) {
    return course.chapters.expand((chapter) => chapter.lessons);
  }).toList();
}
