import 'dart:async';
import 'package:core/data/data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'course_list_provider.dart';
import 'package:async/async.dart';

part 'lesson_detail_provider.g.dart';

/// Provider that fetches a specific lesson domain model by its ID.
///
/// Uses a timed keep-alive: the provider stays cached for 5 minutes after its
/// last listener drops (e.g. the user navigates away), then disposes itself.
/// This avoids the unbounded memory growth of a static [keepAlive: true] while
/// still providing fast re-entry for typical back-navigation patterns.
@riverpod
Stream<LessonDto?> lessonDetail(LessonDetailRef ref, String lessonId) async* {
  final link = ref.keepAlive();
  Timer? disposeTimer;

  final repository = await ref.watch(courseRepositoryProvider.future);

  final initial = await repository.getLesson(lessonId);

  ref.onCancel(() {
    if (initial == null || !initial.isComplete) {
      link.close();
    } else {
      disposeTimer = Timer(const Duration(minutes: 5), link.close);
    }
  });
  ref.onResume(() async {
    disposeTimer?.cancel();
    disposeTimer = null;
    final repository = await ref.read(courseRepositoryProvider.future);
    repository.refreshLesson(lessonId).ignore();
  });
  ref.onDispose(() => disposeTimer?.cancel());

  final Stream<LessonDto?> dbStream =
      repository.watchLesson(lessonId).map((row) {
    if (row == null) return null;
    return repository.rowToLessonDto(row);
  });

  final sentryService = ref.read(sentryServiceProvider);
  if (initial == null) {
    // First time load: Await fetch so the UI starts in a loading state
    try {
      await repository.refreshLesson(lessonId);
    } catch (e, st) {
      sentryService.captureException(e, stackTrace: st);
      link.close();
      rethrow;
    }
    yield* dbStream;
  } else if (!initial.isComplete) {
    // Background refresh: Combine DB updates with the refresh result
    // If refresh fails, the error propagates through the merged stream.
    yield* StreamGroup.merge<LessonDto?>([
      dbStream,
      repository
          .refreshLesson(lessonId)
          .asStream()
          .handleError((e) {
            link.close();
            throw e;
          })
          .where((_) => false)
          .cast<LessonDto?>(),
    ]);
  } else {
    // Already have complete data: Safe to refresh in the background silently,
    // but propagate critical access errors (401, 403, 404).
    yield* StreamGroup.merge<LessonDto?>([
      dbStream,
      repository
          .refreshLesson(lessonId)
          .asStream()
          .handleError((e) {
            if (e is ApiException &&
                (e.type == ApiErrorType.forbidden ||
                    e.type == ApiErrorType.unauthorized ||
                    e.type == ApiErrorType.notFound)) {
              link.close();
              throw e;
            }
          })
          .where((_) => false)
          .cast<LessonDto?>(),
    ]);
  }
}

/// Provider that watches and manages the bookmark status of a specific lesson.
@riverpod
Stream<bool> lessonBookmark(LessonBookmarkRef ref, String lessonId) async* {
  final repository = await ref.watch(courseRepositoryProvider.future);
  yield* repository.watchLesson(lessonId).map((l) => l?.bookmarkId != null);
}
