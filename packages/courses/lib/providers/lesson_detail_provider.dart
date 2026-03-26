import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import 'course_list_provider.dart';
import '../models/course_content.dart';

part 'lesson_detail_provider.g.dart';

/// Provider that fetches a specific lesson domain model by its ID.
///
/// This provider searches through all chapters of all enrolled courses
/// to find the matching [LessonDto] and maps it to the domain [Lesson].
@riverpod
Future<Lesson?> lessonDetail(LessonDetailRef ref, String lessonId) async {
  final repository = await ref.watch(courseRepositoryProvider.future);
  final lessonDto = await repository.getLesson(lessonId);

  if (lessonDto == null) return null;

  return Lesson(
    id: lessonDto.id,
    title: lessonDto.title,
    type: lessonDto.type,
    progressStatus: lessonDto.progressStatus,
    duration: lessonDto.duration,
    isLocked: lessonDto.isLocked,
    isBookmarked: lessonDto.isBookmarked,
    subtitle: lessonDto.subtitle,
    subjectName: lessonDto.subjectName,
    subjectIndex: lessonDto.subjectIndex,
    lessonNumber: lessonDto.lessonNumber,
    totalLessons: lessonDto.totalLessons,
    contentUrl: lessonDto.contentUrl,
  );
}

/// Provider that watches and manages the bookmark status of a specific lesson.
@riverpod
Stream<bool> lessonBookmark(LessonBookmarkRef ref, String lessonId) async* {
  final repository = await ref.watch(courseRepositoryProvider.future);
  yield* repository.watchLesson(lessonId).map((l) => l?.isBookmarked ?? false);
}
