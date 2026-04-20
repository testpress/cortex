import 'dart:async';
import 'package:async/async.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import 'package:core/data/data.dart';

/// Repository for all course-related operations.
/// Owns the bridge between [DataSource] (network/mock) and [AppDatabase] (local cache).
/// UI should only interact with [watchCourses], [watchChapters], [watchLessons] streams.
class CourseRepository {
  final AppDatabase _db;
  final DataSource _source;

  /// In-flight structural syncs to prevent duplicate network requests.
  final Map<String, Future<CourseCurriculumDto>> _activeStructuralSyncs = {};
  final Map<String, Future<List<ChapterDto>>> _activeChapterSyncs = {};
  final Map<String, Future<CourseDto?>> _activeDetailSyncs = {};
  final Map<String, Future<List<LessonDto>>> _activeContentSyncs = {};

  CourseRepository(this._db, this._source);

  // ── Courses ──────────────────────────────────────────────────────────────

  /// Live stream of all courses from the local DB (single source of truth).
  Stream<List<CoursesTableData>> watchCourses() {
    return _db.watchAllCourses();
  }

  /// Live stream of a specific course with its chapters.
  Stream<CourseDto?> watchCourse(String courseId) async* {
    // Combine course and chapter streams by reacting to both table changes
    final combinedWatcher = StreamGroup.merge([
      Stream.value(null), // Initial trigger
      (_db.select(
        _db.coursesTable,
      )..where((t) => t.id.equals(courseId))).watch(),
      (_db.select(
        _db.chaptersTable,
      )..where((t) => t.courseId.equals(courseId))).watch(),
    ]);

    yield* combinedWatcher.asyncMap((_) async {
      final courseData = await (_db.select(
        _db.coursesTable,
      )..where((t) => t.id.equals(courseId))).getSingleOrNull();

      CourseDto course;
      if (courseData != null) {
        course = rowToCourseDto(courseData);
      } else {
        // Search result fallback: Fetch from network but DON'T persist
        // to avoid cluttering the user's course list.
        try {
          course = await _source.getCourseDetail(courseId);
        } catch (_) {
          return null; // Both local and remote failed
        }
      }

      final chaptersData =
          await (_db.select(_db.chaptersTable)
                ..where(
                  (t) => t.courseId.equals(courseId) & t.parentId.isNull(),
                )
                ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
              .get();

      return course.copyWith(
        chapters: chaptersData.map(rowToChapterDto).toList(),
      );
    });
  }

  /// Fetch courses for a specific [page] from [DataSource] and persist to local DB.
  Future<PaginatedResponseDto<CourseDto>> refreshCourses({int page = 1}) async {
    final response = await _source.getCourses(page: page);

    if (response.results.isNotEmpty) {
      final companions = response.results.map(_courseDtoToCompanion).toList();
      await _db.upsertCourses(companions);
    }

    return response;
  }

  /// Searches courses from the API without persisting them to the local DB.
  Future<PaginatedResponseDto<CourseDto>> searchCourses({
    required String query,
    int page = 1,
  }) async {
    return await _source.getCourses(page: page, search: query);
  }

  // ── Chapters ─────────────────────────────────────────────────────────────

  Stream<List<ChaptersTableData>> watchChapters(
    String courseId, {
    String? parentId,
  }) {
    final query = _db.select(_db.chaptersTable)
      ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]);

    if (parentId == null) {
      query.where((t) => t.courseId.equals(courseId) & t.parentId.isNull());
    } else {
      query.where((t) => t.parentId.equals(parentId));
    }

    return query.watch();
  }

  /// Live stream of ALL chapters for a course (regardless of depth).
  /// Used for hierarchical filtering and breadcrumb calculations.
  Stream<List<ChaptersTableData>> watchAllChapters(String courseId) {
    return (_db.select(_db.chaptersTable)
          ..where((t) => t.courseId.equals(courseId))
          ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
        .watch();
  }

  Future<CourseDto?> refreshCourseDetail(String courseId) async {
    final lockKey = 'detail_$courseId';
    if (_activeDetailSyncs.containsKey(lockKey)) {
      return _activeDetailSyncs[lockKey]!;
    }

    final syncFuture = () async {
      try {
        final dto = await _source.getCourseDetail(courseId);
        await _db.upsertCourses([_courseDtoToCompanion(dto)]);
        return dto;
      } finally {
        _activeDetailSyncs.remove(lockKey);
      }
    }();

    _activeDetailSyncs[lockKey] = syncFuture;
    return syncFuture;
  }

  /// Checks if chapters/subjects for a course or folder are already in the DB.
  Future<bool> isChaptersSynced(String courseId, {String? parentId}) async {
    final rowId = parentId ?? courseId;
    final isChapter = parentId != null;

    if (isChapter) {
      final chapter = await (_db.select(
        _db.chaptersTable,
      )..where((t) => t.id.equals(rowId))).getSingleOrNull();
      return chapter?.isChaptersSynced ?? false;
    } else {
      final course = await (_db.select(
        _db.coursesTable,
      )..where((t) => t.id.equals(rowId))).getSingleOrNull();
      return course?.isChaptersSynced ?? false;
    }
  }

  /// Refreshes chapters for a course or folder and marks it as synced.
  Future<List<ChapterDto>> refreshChapters(
    String courseId, {
    String? parentId,
  }) async {
    final lockKey = 'chapters_${courseId}_${parentId ?? "root"}';
    if (_activeChapterSyncs.containsKey(lockKey)) {
      return _activeChapterSyncs[lockKey]!;
    }

    final syncFuture = () async {
      try {
        final chapters = await _source.getChapters(
          courseId,
          parentId: parentId,
        );
        final companions = chapters.map(_chapterDtoToCompanion).toList();

        if (companions.isNotEmpty) {
          await _db.upsertChapters(companions);
        }
        await _markAsSynced(courseId: courseId, folderId: parentId);
        return chapters;
      } finally {
        _activeChapterSyncs.remove(lockKey);
      }
    }();

    _activeChapterSyncs[lockKey] = syncFuture;
    return syncFuture;
  }

  // ── Internal Helpers ─────────────────────────────────────────────────────

  Future<void> _markAsSynced({
    required String courseId,
    String? folderId,
  }) async {
    if (folderId != null) {
      await (_db.update(_db.chaptersTable)..where((t) => t.id.equals(folderId)))
          .write(const ChaptersTableCompanion(isChaptersSynced: Value(true)));
    } else {
      await (_db.update(_db.coursesTable)..where((t) => t.id.equals(courseId)))
          .write(const CoursesTableCompanion(isChaptersSynced: Value(true)));
    }
  }

  // ── Lessons ───────────────────────────────────────────────────────────────

  Stream<List<LessonsTableData>> watchLessons(String chapterId) {
    return _db.watchLessonsForChapter(chapterId);
  }

  /// Watch all lessons belonging to any chapter within a course.
  /// Uses a projection layer to decouple relational truth from SQL.
  Stream<CourseCurriculumDto> watchLessonsForCourse(String courseId) {
    return watchCourseCurriculum(courseId);
  }

  /// Watches the curriculum for a course by combining the structure snapshot
  /// with live database state. This does not depend on SQL joins.
  Stream<CourseCurriculumDto> watchCourseCurriculum(String courseId) async* {
    // 1. Get the authoritative structure snapshot for this course.
    final CourseCurriculumDto hierarchy = await refreshCourseContents(courseId);

    // Immediate yield of the hierarchy to ensure instant UI responsiveness.
    yield hierarchy;

    if (hierarchy.isEmpty) return;

    // 2. Build the lesson stream from the live Database vault.
    // Instead of mapping the static API snapshot, we watch ALL lessons in the DB
    // and filter them by the chapters that belong to this course.
    yield* _db.watchAllLessons().map((dbRows) {
      // Collect all chapter IDs that belong to this course hierarchy.
      final courseChapterIds = {for (var c in hierarchy.chapters) c.id};

      final courseLessons = dbRows
          .map(rowToLessonDto)
          .where((l) => courseChapterIds.contains(l.chapterId))
          .toList();

      // Enforce the API-provided sequence for consistent ordering.
      courseLessons.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

      return hierarchy.copyWith(lessons: courseLessons);
    });
  }

  /// Direct fetch of a course by ID from the database or network fallback.
  Future<CourseDto?> getCourse(String courseId) async {
    return watchCourse(courseId).first;
  }

  /// Synchronizes all data needed for a specific chapter view.
  /// Handles the complexity of checking if it's a leaf and coordinating status refreshes.
  Future<List<LessonDto>> syncChapterContents(
    String courseId,
    String chapterId,
  ) async {
    final course = await getCourse(courseId);
    final chapter = course?.chapters
        .where((c) => c.id == chapterId)
        .firstOrNull;

    if (chapter != null && chapter.isLeaf) {
      // Refresh the course-wide status tags first.
      await refreshCourseContents(courseId);
      // Then refresh the specific chapter lessons vertically to ensure data integrity.
      return await refreshLessons(chapterId);
    }
    return [];
  }

  Future<List<LessonDto>> refreshLessons(String chapterId) async {
    if (_activeContentSyncs.containsKey(chapterId)) {
      final rows = await getLessons(chapterId);
      return rows.map(rowToLessonDto).toList();
    }

    final syncFuture = () async {
      try {
        final lessons = await _source.getLessons(chapterId);
        final companions = lessons.map(_lessonDtoToCompanion).toList();

        final remoteIds = lessons.map((l) => l.id).toSet();

        await _db.transaction(() async {
          final localLessons = await getLessons(chapterId);
          final localIds = localLessons.map((l) => l.id).toSet();

          final idsToDelete = localIds.difference(remoteIds).toList();
          if (idsToDelete.isNotEmpty) {
            await _db.deleteLessonsByIds(idsToDelete);
          }

          await _db.upsertLessons(companions);
        });

        return lessons;
      } finally {
        _activeContentSyncs.remove(chapterId);
      }
    }();

    _activeContentSyncs[chapterId] = syncFuture.then((_) async {
      final rows = await getLessons(chapterId);
      return rows.map(rowToLessonDto).toList();
    });

    return syncFuture;
  }

  Future<CourseCurriculumDto> refreshCourseContents(String courseId) async {
    // Request Deduplication: Avoid duplicate pagination loops if sync is already in progress.
    if (_activeStructuralSyncs.containsKey(courseId)) {
      return _activeStructuralSyncs[courseId]!;
    }

    final syncFuture = () async {
      try {
        // Authoritative Structural Mapping: Hierarchy comes strictly from the paginated /contents/ API.
        final remoteAll = await _source.getCourseContents(courseId);

        // Status Enrichment: Fetch progress/lifecycle flags in parallel.
        // These are secondary and do NOT affect the curriculum structure.
        final results = await Future.wait([
          _source.getRunningContents(courseId),
          _source.getUpcomingContents(courseId),
          _source.getContentAttempts(courseId),
        ]);

        final remote = (
          all: remoteAll,
          running: results[0],
          upcoming: results[1],
          attempts: results[2],
        );

        final mergedCurriculum = await _mergeLocalAndRemoteCurriculum(
          courseId,
          remote.all,
        );

        // Enrichment Phase: Distribute status flags to the authoritative entities.
        final lessonCompanions = _applyContentStatuses(
          mergedCurriculum.lessons,
          remote,
        );
        final chapterCompanions = mergedCurriculum.chapters
            .map(_chapterDtoToCompanion)
            .toList();

        await _db.transaction(() async {
          if (lessonCompanions.isNotEmpty) {
            await _db.upsertLessons(lessonCompanions);
          }
          if (chapterCompanions.isNotEmpty) {
            await _db.upsertChapters(chapterCompanions);
          }
        });

        return mergedCurriculum;
      } catch (e) {
        rethrow;
      } finally {
        _activeStructuralSyncs.remove(courseId);
      }
    }();

    _activeStructuralSyncs[courseId] = syncFuture;
    return syncFuture;
  }

  Future<CourseCurriculumDto> _mergeLocalAndRemoteCurriculum(
    String courseId,
    CourseCurriculumDto remoteAll,
  ) async {
    final Map<String, LessonDto> merged = {};

    // 1. Identify authoritative IDs from the API hierarchy
    final remoteIds = remoteAll.lessons.map((l) => l.id).toSet();

    // 2. Load existing persistent state from DB cache for ONLY these IDs.
    // This avoids SQL JOINs and recursion with the projection layer.
    final localRows = await (_db.select(
      _db.lessonsTable,
    )..where((t) => t.id.isIn(remoteIds))).get();

    for (final row in localRows) {
      merged[row.id] = rowToLessonDto(row);
    }

    // 3. Layer on the authoritative hierarchy/metadata from the API
    for (final l in remoteAll.lessons) {
      merged[l.id] = l;
    }

    return CourseCurriculumDto(
      lessons: merged.values.toList(),
      chapters: remoteAll.chapters,
    );
  }

  List<LessonsTableCompanion> _applyContentStatuses(
    List<LessonDto> lessons,
    ({
      CourseCurriculumDto all,
      CourseCurriculumDto running,
      CourseCurriculumDto upcoming,
      CourseCurriculumDto attempts,
    })
    remote,
  ) {
    final runningIds = remote.running.lessons.map((l) => l.id).toSet();
    final upcomingIds = remote.upcoming.lessons.map((l) => l.id).toSet();
    final historyIds = remote.attempts.lessons.map((l) => l.id).toSet();

    return lessons.map((dto) {
      return _lessonDtoToCompanion(dto).copyWith(
        isRunning: Value(runningIds.contains(dto.id)),
        isUpcoming: Value(upcomingIds.contains(dto.id)),
        hasAttempts: Value(
          historyIds.contains(dto.id) ||
              dto.progressStatus == LessonProgressStatus.completed,
        ),
      );
    }).toList();
  }

  /// Direct fetch of a lesson by ID.
  Future<LessonDto?> getLesson(String id) async {
    final row = await _db.getLessonById(id);
    return row != null ? rowToLessonDto(row) : null;
  }

  /// Refetches a single lesson's full metadata from the v2.4 API and persists it.
  Future<LessonDto> refreshLesson(String id) async {
    final dto = await _source.getLessonDetail(id);
    final existing = await getLesson(id);

    // Explicitly mark as detail fetched
    final updated = dto.copyWith(isDetailFetched: true);
    final merged = updated.mergeWith(existing);

    await _db.upsertLessons([_lessonDtoToCompanion(merged)]);
    return merged;
  }

  /// Watch a single lesson by its ID.
  Stream<LessonsTableData?> watchLesson(String id) {
    return _db.watchLesson(id);
  }

  /// Watch a single chapter by its ID.
  Stream<ChaptersTableData?> watchChapter(String id) {
    return (_db.select(
      _db.chaptersTable,
    )..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  /// Direct fetch of a chapter by ID.
  Future<ChaptersTableData?> getChapter(String id) async {
    return (_db.select(
      _db.chaptersTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Direct fetch of lessons for a chapter from DB.
  Future<List<LessonsTableData>> getLessons(String chapterId) async {
    return (_db.select(
      _db.lessonsTable,
    )..where((t) => t.chapterId.equals(chapterId))).get();
  }

  /// Toggles the bookmark status locally.
  Future<void> toggleLessonBookmark(String id) async {
    await _db.toggleLessonBookmark(id);
  }

  /// Updates lesson progress locally and on the server if completed.
  Future<void> updateLessonProgress(
    String id,
    LessonProgressStatus status,
  ) async {
    // 1. Update locally for immediate UI feedback
    await _db.updateLessonProgress(id, status);

    // 2. Sync with server if marked as completed
    if (status == LessonProgressStatus.completed) {
      try {
        await _source.markLessonCompleted(id);
      } catch (e) {
        // Log error but don't block local success
        debugPrint('CourseRepository: Failed to sync completion to server: $e');
      }
    }
  }

  /// Downloads a file via the data source.
  Future<void> downloadFile({
    required String url,
    required String savePath,
    void Function(int count, int total)? onReceiveProgress,
    dynamic cancelToken,
    bool requireAuth = true,
  }) async {
    await _source.downloadFile(
      url: url,
      savePath: savePath,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
      requireAuth: requireAuth,
    );
  }

  /// Efficiently fetches lesson and parent titles by lesson ID.
  Future<({String lessonTitle, String chapterTitle, String courseTitle})?>
  getLessonDetails(String lessonId) async {
    final result = await _db.getLessonDetails(lessonId);
    if (result == null) return null;

    final lesson = result.readTable(_db.lessonsTable);
    final chapter = result.readTable(_db.chaptersTable);
    final course = result.readTable(_db.coursesTable);

    return (
      lessonTitle: lesson.title,
      chapterTitle: chapter.title,
      courseTitle: course.title,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Mapping helpers
  // ─────────────────────────────────────────────────────────────────────────

  CourseDto rowToCourseDto(CoursesTableData row) => CourseDto(
    id: row.id,
    title: row.title,
    colorIndex: row.colorIndex,
    chapterCount: row.chapterCount,
    totalDuration: row.totalDuration,
    totalContents: row.totalContents,
    progress: row.progress,
    completedLessons: row.completedLessons,
    totalLessons: row.totalLessons,
    image: row.image,
    isChaptersSynced: row.isChaptersSynced,
  );

  CoursesTableCompanion _courseDtoToCompanion(CourseDto dto) =>
      CoursesTableCompanion(
        id: Value(dto.id),
        title: Value(dto.title),
        colorIndex: Value(dto.colorIndex),
        chapterCount: Value(dto.chapterCount),
        totalDuration: Value(dto.totalDuration),
        totalContents: Value(dto.totalContents),
        progress: Value(dto.progress),
        completedLessons: Value(dto.completedLessons),
        totalLessons: Value(dto.totalLessons),
        image: dto.image != null ? Value(dto.image) : const Value.absent(),
        isChaptersSynced: Value(dto.isChaptersSynced),
      );

  ChapterDto rowToChapterDto(ChaptersTableData row) => ChapterDto(
    id: row.id,
    courseId: row.courseId,
    title: row.title,
    lessonCount: row.lessonCount,
    assessmentCount: row.assessmentCount,
    orderIndex: row.orderIndex,
    parentId: row.parentId,
    isLeaf: row.isLeaf,
    isChaptersSynced: row.isChaptersSynced,
    image: row.image,
  );

  ChaptersTableCompanion _chapterDtoToCompanion(ChapterDto dto) =>
      ChaptersTableCompanion(
        id: Value(dto.id),
        courseId: Value(dto.courseId),
        title: Value(dto.title),
        lessonCount: Value(dto.lessonCount),
        assessmentCount: Value(dto.assessmentCount),
        orderIndex: Value(dto.orderIndex),
        parentId: dto.parentId != null
            ? Value(dto.parentId)
            : const Value.absent(),
        isLeaf: Value(dto.isLeaf),
        isChaptersSynced: Value(dto.isChaptersSynced),
        image: dto.image != null ? Value(dto.image) : const Value.absent(),
      );

  LessonDto rowToLessonDto(LessonsTableData row) => LessonDto(
    id: row.id,
    chapterId: row.chapterId,
    title: row.title,
    type: _parseType(row.type),
    duration: row.duration,
    progressStatus: _parseStatus(row.progressStatus),
    isLocked: row.isLocked,
    orderIndex: row.orderIndex,
    chapterTitle: row.chapterTitle,
    contentUrl: row.contentUrl,
    subtitle: row.subtitle,
    subjectName: row.subjectName,
    subjectIndex: row.subjectIndex,
    lessonNumber: row.lessonNumber,
    totalLessons: row.totalLessons,
    isBookmarked: row.isBookmarked,
    isRunning: row.isRunning,
    isUpcoming: row.isUpcoming,
    hasAttempts: row.hasAttempts,
    image: row.image,
    nextContentId: row.nextContentId,
    previousContentId: row.previousContentId,
    htmlContent: row.htmlContent,
    isDetailFetched: row.isDetailFetched,
  );

  LessonsTableCompanion _lessonDtoToCompanion(LessonDto dto) =>
      LessonsTableCompanion(
        id: Value(dto.id),
        chapterId: Value(dto.chapterId),
        title: Value(dto.title),
        type: Value(dto.type.name),
        duration: Value(dto.duration),
        progressStatus: Value(dto.progressStatus.name),
        isLocked: Value(dto.isLocked),
        orderIndex: Value(dto.orderIndex),
        chapterTitle: dto.chapterTitle != null
            ? Value(dto.chapterTitle)
            : const Value.absent(),
        contentUrl: dto.contentUrl != null
            ? Value(dto.contentUrl)
            : const Value.absent(),
        subtitle: dto.subtitle != null
            ? Value(dto.subtitle)
            : const Value.absent(),
        subjectName: dto.subjectName != null
            ? Value(dto.subjectName)
            : const Value.absent(),
        subjectIndex: dto.subjectIndex != null
            ? Value(dto.subjectIndex)
            : const Value.absent(),
        lessonNumber: dto.lessonNumber != null
            ? Value(dto.lessonNumber)
            : const Value.absent(),
        totalLessons: dto.totalLessons != null
            ? Value(dto.totalLessons)
            : const Value.absent(),
        isBookmarked: Value(dto.isBookmarked),
        isRunning: Value(dto.isRunning),
        isUpcoming: Value(dto.isUpcoming),
        hasAttempts: Value(dto.hasAttempts),
        image: dto.image != null ? Value(dto.image) : const Value.absent(),
        nextContentId: dto.nextContentId != null
            ? Value(dto.nextContentId)
            : const Value.absent(),
        previousContentId: dto.previousContentId != null
            ? Value(dto.previousContentId)
            : const Value.absent(),
        htmlContent: dto.htmlContent != null
            ? Value(dto.htmlContent)
            : const Value.absent(),
        isDetailFetched: Value(dto.isDetailFetched),
      );

  LessonType _parseType(String s) {
    try {
      return LessonType.values.byName(s);
    } catch (_) {
      // Compatibility with old DB strings or fuzzy inputs
      if (s.contains('live')) return LessonType.liveStream;
      if (s.contains('notes')) return LessonType.notes;
      if (s.contains('embed')) return LessonType.embedContent;
      if (s.contains('attachment')) return LessonType.attachment;
      if (s.contains('video')) return LessonType.video;
      if (s.contains('pdf')) return LessonType.pdf;
      if (s.contains('test')) return LessonType.test;
      if (s.contains('assessment')) return LessonType.assessment;
      return LessonType.unknown;
    }
  }

  LessonProgressStatus _parseStatus(String s) {
    try {
      return LessonProgressStatus.values.byName(s);
    } catch (_) {
      return LessonProgressStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == s.toLowerCase(),
        orElse: () => LessonProgressStatus.notStarted,
      );
    }
  }
}
