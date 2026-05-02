import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'course_list_provider.dart';
import '../models/course_content.dart';

import 'package:async/async.dart';
 
part 'lesson_detail_provider.g.dart';
 
/// Provider that fetches a specific lesson domain model by its ID.
@riverpod
Stream<Lesson?> lessonDetail(LessonDetailRef ref, String lessonId) async* {
  final repository = await ref.watch(courseRepositoryProvider.future);
 
  final initial = await repository.getLesson(lessonId);
 
  final dbStream = repository.watchLesson(lessonId).map((row) {
    if (row == null) return null;
 
    final lessonDto = repository.rowToLessonDto(row);
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
      image: lessonDto.image,
      isRunning: lessonDto.isRunning,
      isUpcoming: lessonDto.isUpcoming,
      hasAttempts: lessonDto.hasAttempts,
      nextContentId: lessonDto.nextContentId,
      previousContentId: lessonDto.previousContentId,
      htmlContent: lessonDto.htmlContent,
      isDetailFetched: lessonDto.isDetailFetched,
      chatEmbedUrl: lessonDto.chatEmbedUrl,
      streamStatus: lessonDto.streamStatus,
      showRecordedVideo: lessonDto.showRecordedVideo,
      isScheduled: lessonDto.isScheduled,
      scheduledMessage: lessonDto.scheduledMessage,
    );
  });
 
  if (initial == null) {
    // First time load: Await fetch so the UI starts in a loading state
    try {
      await repository.refreshLesson(lessonId);
    } catch (e) {
      rethrow;
    }
    yield* dbStream;
  } else if (!initial.isComplete) {
    // Background refresh: Combine DB updates with the refresh result
    // If refresh fails, the error propagates through the merged stream.
    yield* StreamGroup.merge([
      dbStream,
      repository.refreshLesson(lessonId).asStream().handleError((e) {
        throw e;
      }).where((_) => false).cast<Lesson?>(),
    ]);
  } else {
    // Already have complete data: Safe to refresh in the background silently
    repository.refreshLesson(lessonId).ignore();
    yield* dbStream;
  }
}


/// Provider that watches and manages the bookmark status of a specific lesson.
@riverpod
Stream<bool> lessonBookmark(LessonBookmarkRef ref, String lessonId) async* {
  final repository = await ref.watch(courseRepositoryProvider.future);
  yield* repository.watchLesson(lessonId).map((l) => l?.isBookmarked ?? false);
}
