import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import 'course_list_provider.dart';

part 'lesson_providers.g.dart';

/// Flattens the course/chapter hierarchy into a single stream of all lessons.
/// 
/// This allows for efficient O(N) filtering in the UI across the entire local cache.
@riverpod
Stream<List<LessonDto>> allLessons(AllLessonsRef ref) async* {
  final repo = await ref.watch(courseRepositoryProvider.future);
  yield* repo.watchAllLessons();
}
