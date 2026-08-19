import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:async/async.dart';
import 'package:core/data/data.dart';
import 'course_list_provider.dart';

part 'live_class_detail_provider.g.dart';

/// Provider that fetches a specific live class domain model by its ID.
///
/// Uses a timed keep-alive cache exactly like lessonDetailProvider.
@riverpod
Stream<LessonDto?> liveClassDetail(
    LiveClassDetailRef ref, String lessonId) async* {
  final link = ref.keepAlive();
  Timer? disposeTimer;

  ref.onCancel(() {
    disposeTimer = Timer(const Duration(minutes: 5), link.close);
  });
  ref.onResume(() async {
    disposeTimer?.cancel();
    disposeTimer = null;
    final repository = await ref.read(courseRepositoryProvider.future);
    repository.refreshLiveClass(lessonId).ignore();
  });
  ref.onDispose(() => disposeTimer?.cancel());

  final repository = await ref.watch(courseRepositoryProvider.future);

  final initial = await repository.getLesson(lessonId);

  final Stream<LessonDto?> dbStream =
      repository.watchLesson(lessonId).map((row) {
    if (row == null) return null;
    return repository.rowToLessonDto(row);
  });

  if (initial == null) {
    // First time load: Await fetch so the UI starts in a loading state
    try {
      await repository.refreshLiveClass(lessonId);
    } catch (e) {
      rethrow;
    }
    yield* dbStream;
  } else if (!initial.isDetailFetched) {
    // Background refresh: Combine DB updates with the refresh result
    yield* StreamGroup.merge<LessonDto?>([
      dbStream,
      repository
          .refreshLiveClass(lessonId)
          .asStream()
          .handleError((e) {
            throw e;
          })
          .where((_) => false)
          .cast<LessonDto?>(),
    ]);
  } else {
    // Already have complete data: Safe to refresh in the background silently
    repository.refreshLiveClass(lessonId).ignore();
    yield* dbStream;
  }
}
