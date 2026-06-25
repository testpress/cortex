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
    // Data in cache — stream immediately and refresh in background.
    repo.refreshChapters(courseId, parentId: parentId).ignore();
  } else {
    // DB is empty — must await network before streaming to avoid the
    // empty-folder → lessons flash bug.
    await repo.refreshChapters(courseId, parentId: parentId);
  }

  // 2. Stream DB changes. If data drops to empty after we've already emitted
  // real data (e.g. a pull-to-refresh on the course list wiped the chapters),
  // silently re-fetch instead of yielding the empty state — which would
  // incorrectly flip the UI into lesson-list mode.
  bool hasNonEmptyData = localChapters.isNotEmpty;

  await for (final rows in repo.watchChapters(courseId, parentId: parentId)) {
    final chapters = rows.map((row) => repo.rowToChapterDto(row)).toList();

    if (chapters.isEmpty && hasNonEmptyData) {
      // Chapters were externally purged (e.g. refreshCourses cascade delete).
      // Reset the flag first — if the re-fetch also returns empty, we should
      // yield the empty state rather than loop indefinitely.
      hasNonEmptyData = false;
      try {
        final refreshed =
            await repo.refreshChapters(courseId, parentId: parentId);
        if (refreshed.isEmpty) {
          // Server confirmed the folder is permanently empty.
          // Since no DB write occurs for empty results, watchChapters won't emit.
          // We must yield manually to unblock the UI.
          yield chapters;
        }
      } catch (_) {
        // Network failure: yield the empty state so the UI can show
        // a proper error or empty view rather than staying frozen.
        yield chapters;
      }
    } else {
      if (chapters.isNotEmpty) hasNonEmptyData = true;
      yield chapters;
    }
  }
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
