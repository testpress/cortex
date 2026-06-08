import 'package:core/data/data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'course_list_provider.dart';

part 'course_detail_provider.g.dart';

/// Provider that fetches a specific course with its full curriculum (chapters and lessons).
@Riverpod(keepAlive: true)
Stream<CourseDto?> courseDetail(CourseDetailRef ref, String courseId) async* {
  final repo = await ref.watch(courseRepositoryProvider.future);

  // We no longer trigger greedy background refreshes here.
  // Structural sync happens lazily via subChaptersProvider.
  // Content sync happens on-demand when a filter is applied in ChaptersListPage.
  yield* repo.watchCourse(courseId);
}

/// A provider that watches chapters for a specific parent (folder).
/// Triggers a refresh if the folder has not been synced yet.
@Riverpod(keepAlive: true)
Stream<List<ChapterDto>> subChapters(
  SubChaptersRef ref,
  String courseId,
  String? parentId,
) async* {
  final repo = await ref.watch(courseRepositoryProvider.future);

  // 1. Check for existing local data to avoid blocking the UI with a loader.
  final localChapters =
      await repo.watchChapters(courseId, parentId: parentId).first;

  if (localChapters.isNotEmpty) {
    // If we have contents, yield them instantly from DB and refresh in background.
    repo.refreshChapters(courseId, parentId: parentId).ignore();
    yield* repo.watchChapters(courseId, parentId: parentId).map(
          (rows) => rows.map((row) => repo.rowToChapterDto(row)).toList(),
        );
    return;
  }

  // 2. If DB is empty, decide whether to block based on previous sync history.
  final isSynced = await repo.isChaptersSynced(courseId, parentId: parentId);
  if (!isSynced) {
    // Await the sync ONLY if it's the first time and we have no data.
    await repo.refreshChapters(courseId, parentId: parentId);
  } else {
    // It's genuinely empty or already synced; refresh quietly.
    repo.refreshChapters(courseId, parentId: parentId).ignore();
  }

  yield* repo.watchChapters(courseId, parentId: parentId).map(
        (rows) => rows.map((row) => repo.rowToChapterDto(row)).toList(),
      );
}

@Riverpod(keepAlive: true)
Stream<List<LessonDto>> chapterLessons(
  ChapterLessonsRef ref,
  String courseId,
  String chapterId,
) async* {
  final repo = await ref.watch(courseRepositoryProvider.future);

  yield* repo.watchLessons(chapterId).map(
        (rows) => rows.map(repo.rowToLessonDto).toList(),
      );
}

/// Provider that tracks if a specific course is currently undergoing a structural sync.
@Riverpod(keepAlive: true)
Stream<bool> courseSyncStatus(CourseSyncStatusRef ref, String courseId) async* {
  final repo = await ref.watch(courseRepositoryProvider.future);
  yield repo.isSyncing(courseId);
  yield* repo.activeSyncsStream
      .map((syncs) => syncs.contains(courseId))
      .distinct();
}
