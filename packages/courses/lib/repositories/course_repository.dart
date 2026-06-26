import 'dart:async';
import 'package:async/async.dart';
import 'dart:convert';
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

  /// Stream controller for sync status updates
  final _syncStatusController = StreamController<Set<String>>.broadcast();
  final Set<String> _activeSyncIds = {};

  /// Stream of course IDs currently being synced.
  Stream<Set<String>> get activeSyncsStream => _syncStatusController.stream;

  /// Returns true if a specific course is currently syncing.
  bool isSyncing(String courseId) => _activeSyncIds.contains(courseId);

  void _updateSyncStatus(String courseId, bool isSyncing) {
    if (isSyncing) {
      _activeSyncIds.add(courseId);
    } else {
      _activeSyncIds.remove(courseId);
    }
    _syncStatusController.add(Set.unmodifiable(_activeSyncIds));
  }

  CourseRepository(this._db, this._source);

  // ── Courses ──────────────────────────────────────────────────────────────

  /// Live stream of all courses from the local DB (single source of truth).
  Stream<List<CoursesTableData>> watchCourses() {
    return _db.watchAllCourses();
  }

  /// Live stream of courses filtered for the Exams tab.
  Stream<List<CoursesTableData>> watchExamCourses() {
    return _db.watchAllCourses().map((courses) {
      return courses.where((course) {
        final dto = rowToCourseDto(course);
        final hasMobileAccess = dto.allowedDevices.any(
          (d) => d.toLowerCase().contains('mobile'),
        );

        // If showExamTab is enabled, identify exams by tag or fallback to examsCount.
        final isExamCourse = dto.tags.any((t) => t.toLowerCase() == 'exams') ||
            (dto.tags.isEmpty && dto.examsCount > 0);

        return isExamCourse && hasMobileAccess;
      }).toList();
    });
  }

  /// Live stream of courses filtered for the Info (Learning Resources) tab.
  Stream<List<CoursesTableData>> watchInfoCourses() {
    return _db.watchAllCourses().map((courses) {
      return courses.where((course) {
        final dto = rowToCourseDto(course);
        final hasMobileAccess = dto.allowedDevices.any(
          (d) => d.toLowerCase().contains('mobile'),
        );
        return dto.tags.any((t) => t.toLowerCase() == 'info') &&
            hasMobileAccess;
      }).toList();
    });
  }

  /// Live stream of courses filtered for the Study tab.
  /// Excludes exams and info courses to maintain tab independence.
  Stream<List<CoursesTableData>> watchStudyCourses() {
    return _db.watchAllCourses().map((courses) {
      return courses.where((course) {
        final dto = rowToCourseDto(course);

        final isExamCourse = dto.tags.any((t) => t.toLowerCase() == 'exams') ||
            (dto.tags.isEmpty && dto.examsCount > 0);
        final isInfoCourse = dto.tags.any((t) => t.toLowerCase() == 'info');

        if (AppConfig.showExamTab && isExamCourse) return false;
        if (AppConfig.showInfoTab && isInfoCourse) return false;
        return true;
      }).toList();
    });
  }

  /// Live stream of a specific course with its chapters.
  Stream<CourseDto?> watchCourse(String courseId) async* {
    // Combine course and chapter streams by reacting to both table changes
    final combinedWatcher = StreamGroup.merge([
      Stream.value(null), // Initial trigger
      (_db.select(
        _db.coursesTable,
      )..where((t) => t.id.equals(courseId)))
          .watch(),
      (_db.select(
        _db.chaptersTable,
      )..where((t) => t.courseId.equals(courseId)))
          .watch(),
    ]);

    yield* combinedWatcher.asyncMap((_) async {
      final courseData = await (_db.select(
        _db.coursesTable,
      )..where((t) => t.id.equals(courseId)))
          .getSingleOrNull();

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

      final chaptersData = await (_db.select(_db.chaptersTable)
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
  /// Supports optional [tags] filter for server-side filtering.
  Future<PaginatedResponseDto<CourseDto>> refreshCourses({
    int page = 1,
    dynamic tags,
  }) async {
    final response = await _source.getCourses(page: page, tags: tags);

    await _db.transaction(() async {
      if (page == 1) {
        final allCourses = await _db.select(_db.coursesTable).get();
        final idsToDelete = allCourses
            .where((row) {
              final dto = rowToCourseDto(row);
              final isExam = dto.tags.any((t) => t.toLowerCase() == 'exams') ||
                  (dto.tags.isEmpty && dto.examsCount > 0);
              final isInfo = dto.tags.any((t) => t.toLowerCase() == 'info');

              if (tags == 'exams') return isExam;
              if (tags == 'info' || tags == 'info_page') return isInfo;
              if (tags == null) return !isExam && !isInfo;
              return dto.tags
                  .any((t) => t.toLowerCase() == tags.toString().toLowerCase());
            })
            .map((r) => r.id)
            .toList();

        if (idsToDelete.isNotEmpty) {
          await (_db.delete(_db.chaptersTable)
                ..where((t) => t.courseId.isIn(idsToDelete)))
              .go();
          await (_db.delete(_db.lessonsTable)
                ..where((t) => t.courseId.isIn(idsToDelete)))
              .go();
          await (_db.delete(_db.coursesTable)
                ..where((t) => t.id.isIn(idsToDelete)))
              .go();
        }
      }

      if (response.results.isNotEmpty) {
        final companions = response.results.map(_courseDtoToCompanion).toList();
        await _db.upsertCourses(companions);
      }
    });

    return response;
  }

  /// Searches courses from the API without persisting them to the local DB.
  Future<PaginatedResponseDto<CourseDto>> searchCourses({
    required String query,
    int page = 1,
  }) async {
    return _source.getCourses(page: page, search: query);
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
      )..where((t) => t.id.equals(rowId)))
          .getSingleOrNull();
      return chapter?.isChaptersSynced ?? false;
    } else {
      final course = await (_db.select(
        _db.coursesTable,
      )..where((t) => t.id.equals(rowId)))
          .getSingleOrNull();
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
  /// Watches the curriculum for a specific course, yielding local cache first
  /// then initiating a background refresh.
  Stream<CourseCurriculumDto> watchCourseCurriculum(String courseId) async* {
    final combinedWatcher = StreamGroup.merge([
      Stream.value(null),
      (_db.select(_db.chaptersTable)..where((t) => t.courseId.equals(courseId)))
          .watch(),
      _db.watchAllLessons(),
    ]);

    yield* combinedWatcher.asyncMap((_) => getLocalCourseCurriculum(courseId));
  }

  /// Builds a curriculum snapshot directly from the local database.
  Future<CourseCurriculumDto> getLocalCourseCurriculum(String courseId) async {
    final chaptersData = await (_db.select(_db.chaptersTable)
          ..where((t) => t.courseId.equals(courseId)))
        .get();

    final chapterIds = chaptersData.map((c) => c.id).toSet();
    final lessonsData = await (_db.select(_db.lessonsTable)
          ..where((t) => t.chapterId.isIn(chapterIds)))
        .get();

    return CourseCurriculumDto(
      chapters: chaptersData.map(rowToChapterDto).toList(),
      lessons: lessonsData.map(rowToLessonDto).toList(),
    );
  }

  /// Direct fetch of a course by ID from the database or network fallback.
  Future<CourseDto?> getCourse(String courseId) async {
    return watchCourse(courseId).first;
  }

  /// Watches filtered lessons directly from the local database.
  Stream<List<LessonDto>> watchFilteredLessonsLocal(String courseId,
      {String? chapterId, String? type}) {
    final query = _db.select(_db.lessonsTable).join([
      leftOuterJoin(_db.chaptersTable,
          _db.chaptersTable.id.equalsExp(_db.lessonsTable.chapterId)),
    ]);

    if (chapterId != null && chapterId.isNotEmpty) {
      query.where(_db.lessonsTable.ancestorChapterIds.like('%,$chapterId,%'));
    } else {
      query.where(_db.lessonsTable.courseId.equals(courseId));
    }

    if (type != null && type.isNotEmpty) {
      if (type == LessonType.attachment.name) {
        query.where(_db.lessonsTable.type
            .isIn([LessonType.attachment.name, LessonType.pdf.name]));
      } else if (type == LessonType.notes.name) {
        query.where(_db.lessonsTable.type
            .isIn([LessonType.notes.name, LessonType.embedContent.name]));
      } else {
        query.where(_db.lessonsTable.type.equals(type));
      }
    }

    return query.watch().map((rows) {
      return rows.map((row) {
        final lessonRow = row.readTable(_db.lessonsTable);
        final chapterRow = row.readTableOrNull(_db.chaptersTable);

        var dto = rowToLessonDto(lessonRow);
        if ((dto.chapterTitle == null || dto.chapterTitle!.isEmpty) &&
            chapterRow != null) {
          dto = dto.copyWith(chapterTitle: chapterRow.title);
        }
        return dto;
      }).toList();
    });
  }

  String? _getApiCompatibleType(String? type) {
    if (type == 'test') return 'exam';
    if (type == 'assessment') return 'quiz';
    return type;
  }

  String? _buildAncestorChapterIds(
    String chapterId,
    Map<String, ChaptersTableData> chapterById,
  ) {
    if (chapterId.isEmpty) return null;
    final chain = <String>[];
    final visited = <String>{};
    String? current = chapterId;
    while (
        current != null && current.isNotEmpty && !visited.contains(current)) {
      visited.add(current);
      chain.insert(0, current);
      current = chapterById[current]?.parentId;
    }
    if (chain.isEmpty) return ',$chapterId,';
    return ',${chain.join(',')},';
  }

  /// Returns a clean pagination controller that internally coordinates the
  /// local database stream and the background paginated API stream.
  LessonPaginationController getFilteredLessonsController(
    String courseId, {
    String? chapterId,
    String? type,
  }) {
    final lessonsController = StreamController<List<LessonDto>>.broadcast();
    final isLoadingMoreController = StreamController<bool>.broadcast();
    final hasMoreController = StreamController<bool>.broadcast();

    bool isApiSyncing = false;
    bool hasMore = true;

    // 1. Listen to reactive DB updates
    final dbSub = watchFilteredLessonsLocal(
      courseId,
      chapterId: chapterId,
      type: type,
    ).listen((lessons) {
      if (!lessonsController.isClosed) {
        lessonsController.add(lessons);
      }
    });

    StreamSubscription<List<LessonDto>>? apiSub;

    void startApiSync() {
      if (isApiSyncing) return;
      isApiSyncing = true;
      if (!isLoadingMoreController.isClosed) {
        isLoadingMoreController.add(true);
      }

      final apiStream = streamFilteredContents(
        courseId,
        chapterId: chapterId,
        type: type,
      );

      apiSub = apiStream.listen(
        (_) {
          apiSub?.pause();
          isApiSyncing = false;
          if (!isLoadingMoreController.isClosed) {
            isLoadingMoreController.add(false);
          }
        },
        onError: (e) {
          isApiSyncing = false;
          if (!isLoadingMoreController.isClosed) {
            isLoadingMoreController.add(false);
          }
        },
        onDone: () {
          isApiSyncing = false;
          hasMore = false;
          if (!isLoadingMoreController.isClosed) {
            isLoadingMoreController.add(false);
          }
          if (!hasMoreController.isClosed) {
            hasMoreController.add(false);
          }
        },
      );
    }

    // Start background sync on next loop tick
    Future.microtask(() => startApiSync());

    void fetchNextPage() {
      if (!hasMore || isApiSyncing) return;
      if (apiSub != null && apiSub!.isPaused) {
        isApiSyncing = true;
        if (!isLoadingMoreController.isClosed) {
          isLoadingMoreController.add(true);
        }
        apiSub!.resume();
      }
    }

    void dispose() {
      dbSub.cancel();
      apiSub?.cancel();
      lessonsController.close();
      isLoadingMoreController.close();
      hasMoreController.close();
    }

    return LessonPaginationController(
      lessonsStream: lessonsController.stream,
      isLoadingMoreStream: isLoadingMoreController.stream,
      hasMoreStream: hasMoreController.stream,
      fetchNextPage: fetchNextPage,
      dispose: dispose,
    );
  }

  /// Streams filtered content from the API and persists results to DB.
  /// Used by filter tabs (Videos/Assessments/Tests) for direct API results.
  /// Lessons are yielded incrementally as pages arrive.
  Stream<List<LessonDto>> streamFilteredContents(String courseId,
      {String? chapterId, String? type}) {
    String? mergeScopedAncestor(String? existing, String scopedChapterId) {
      final token = ',$scopedChapterId,';
      if (existing == null || existing.isEmpty) return token;
      if (existing.contains(token)) return existing;
      final trimmed = existing.replaceAll(RegExp(r'^,|,$'), '');
      if (trimmed.isEmpty) return token;
      return ',$trimmed,$scopedChapterId,';
    }

    return () async* {
      final apiType = _getApiCompatibleType(type);
      final stream = _source.getCourseContents(courseId,
          chapterId: chapterId, type: apiType);
      await for (final page in stream) {
        final lessonIds = page.lessons.map((l) => l.id).toList();
        final existingLessons = await (_db.select(_db.lessonsTable)
              ..where((t) => t.id.isIn(lessonIds)))
            .get();

        final existingById = {
          for (final row in existingLessons) row.id: rowToLessonDto(row)
        };

        final enrichedLessons = page.lessons.map((lesson) {
          final existingDbLesson = existingById[lesson.id];
          final existingAncestry =
              existingDbLesson?.ancestorChapterIds ?? lesson.ancestorChapterIds;

          final seededAncestor = chapterId != null && chapterId.isNotEmpty
              ? mergeScopedAncestor(existingAncestry, chapterId)
              : existingAncestry;

          // Merge with existing DB lesson to preserve local progress and bookmarks
          var enriched = existingDbLesson != null
              ? lesson.mergeWith(existingDbLesson)
              : lesson;

          // Apply the newly computed ancestry and courseId
          return enriched.copyWith(
            courseId: lesson.courseId ?? courseId,
            ancestorChapterIds: seededAncestor,
          );
        }).toList();

        final companions = enrichedLessons.map(_lessonDtoToCompanion).toList();

        if (companions.isNotEmpty) {
          await _db.upsertLessons(companions);
        }

        yield enrichedLessons;
      }
    }();
  }

  /// Synchronizes all data needed for a specific chapter view.
  /// Handles the complexity of checking if it's a leaf and coordinating status refreshes.
  Future<List<LessonDto>> syncChapterContents(
    String courseId,
    String chapterId,
  ) async {
    // Only refresh the specific chapter lessons to ensure lazy-loading performance.
    // We no longer trigger a global course sync here.
    return await refreshLessons(courseId, chapterId);
  }

  Future<List<LessonDto>> refreshLessons(
      String courseId, String chapterId) async {
    if (_activeContentSyncs.containsKey(chapterId)) {
      final rows = await getLessons(chapterId);
      return rows.map(rowToLessonDto).toList();
    }

    final syncFuture = () async {
      try {
        final lessons = await _source.getLessons(chapterId);
        final chapterRows = await (_db.select(_db.chaptersTable)
              ..where((t) => t.courseId.equals(courseId)))
            .get();
        final chapterById = {for (final row in chapterRows) row.id: row};

        final remoteIds = lessons.map((l) => l.id).toSet();

        await _db.transaction(() async {
          final localLessons = await getLessons(chapterId);
          final localIds = localLessons.map((l) => l.id).toSet();
          final existingById = {
            for (final row in localLessons) row.id: rowToLessonDto(row)
          };

          final idsToDelete = localIds.difference(remoteIds).toList();
          if (idsToDelete.isNotEmpty) {
            await _db.deleteLessonsByIds(idsToDelete);
          }

          // Merge each remote lesson with its local counterpart before persisting.
          // This preserves locally-enriched fields (e.g. duration, contentUrl, videoSubtitleUrl)
          // that the list API may return as empty/null.
          final companions = lessons.map((lesson) {
            final enriched = lesson.copyWith(
              courseId: lesson.courseId ?? courseId,
              ancestorChapterIds: lesson.ancestorChapterIds ??
                  _buildAncestorChapterIds(lesson.chapterId, chapterById),
            );
            final existing = existingById[lesson.id];
            return _lessonDtoToCompanion(enriched.mergeWith(existing));
          }).toList();

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

  /// Synchronizes curriculum contents for a course or a specific chapter.
  /// Uses a Stream to persist pages incrementally, enabling real-time UI population.
  Future<CourseCurriculumDto> refreshCourseContents(
    String courseId, {
    String? chapterId,
  }) async {
    // Request Deduplication: Avoid duplicate pagination loops.
    final syncKey = chapterId ?? courseId;
    if (_activeStructuralSyncs.containsKey(syncKey)) {
      return _activeStructuralSyncs[syncKey]!;
    }

    final syncFuture = () async {
      try {
        _updateSyncStatus(courseId, true);

        final curriculumStream = _source.getCourseContents(
          courseId,
          chapterId: chapterId,
        );

        CourseCurriculumDto finalSnapshot = const CourseCurriculumDto();

        // 1. Process and persist each page incrementally.
        await for (final pageCurriculum in curriculumStream) {
          await _persistCurriculumPage(courseId, pageCurriculum);

          // Collect for the final return value
          finalSnapshot = finalSnapshot.copyWith(
            chapters: [...finalSnapshot.chapters, ...pageCurriculum.chapters],
            lessons: [...finalSnapshot.lessons, ...pageCurriculum.lessons],
          );
        }

        // 2. Trigger secondary status refreshes ONLY during a full global sync.
        // For chapter-scoped syncs, we keep it lightweight.
        if (chapterId == null) {
          refreshContentStatuses(courseId).ignore();
        }

        return finalSnapshot;
      } catch (e) {
        rethrow;
      } finally {
        _activeStructuralSyncs.remove(syncKey);
        _updateSyncStatus(courseId, false);
      }
    }();

    _activeStructuralSyncs[syncKey] = syncFuture;
    return syncFuture;
  }

  /// Persists a single page of curriculum data to the local database.
  Future<void> _persistCurriculumPage(
    String courseId,
    CourseCurriculumDto curriculum,
  ) async {
    final chapterRows = await (_db.select(_db.chaptersTable)
          ..where((t) => t.courseId.equals(courseId)))
        .get();
    final chapterById = {for (final row in chapterRows) row.id: row};

    final lessonIds = curriculum.lessons.map((l) => l.id).toList();
    final existingLessons = await (_db.select(_db.lessonsTable)
          ..where((t) => t.id.isIn(lessonIds)))
        .get();
    final existingById = {
      for (final row in existingLessons) row.id: rowToLessonDto(row)
    };

    final lessonCompanions = curriculum.lessons.map((lesson) {
      final ancestry = lesson.ancestorChapterIds ??
          _buildAncestorChapterIds(lesson.chapterId, chapterById);
      final enriched = lesson.copyWith(
        courseId: lesson.courseId ?? courseId,
        ancestorChapterIds: ancestry,
      );
      final existing = existingById[lesson.id];
      return _lessonDtoToCompanion(enriched.mergeWith(existing));
    }).toList();
    final chapterCompanions =
        curriculum.chapters.map(_chapterDtoToCompanion).toList();

    await _db.transaction(() async {
      if (lessonCompanions.isNotEmpty) {
        await _db.upsertLessons(lessonCompanions);
      }
      if (chapterCompanions.isNotEmpty) {
        await _db.upsertChapters(chapterCompanions);
      }
    });
  }

  /// Background refresh for lesson progress/lifecycle statuses.
  Future<void> refreshContentStatuses(String courseId,
      {String? chapterId}) async {
    try {
      final results = await Future.wait([
        _source.getRunningContents(courseId, chapterId: chapterId),
        _source.getUpcomingContents(courseId, chapterId: chapterId),
        _source.getContentAttempts(courseId, chapterId: chapterId),
      ]);

      final remote = (
        all: const CourseCurriculumDto(), // We only need the statuses here
        running: results[0],
        upcoming: results[1],
        attempts: results[2],
      );

      // Scoped reload: Only get lessons that we actually need to update.
      // If chapterId is null, we fall back to the full course curriculum.
      final List<LessonDto> localLessons;
      if (chapterId != null) {
        final rows = await getLessons(chapterId);
        localLessons = rows.map(rowToLessonDto).toList();
      } else {
        final snapshot = await getLocalCourseCurriculum(courseId);
        localLessons = snapshot.lessons;
      }

      final enrichedCompanions = _applyContentStatuses(localLessons, remote);

      if (enrichedCompanions.isNotEmpty) {
        await _db.upsertLessons(enrichedCompanions);
      }
    } catch (e) {
      debugPrint('CourseRepository: Status refresh failed: $e');
    }
  }

  List<LessonsTableCompanion> _applyContentStatuses(
    List<LessonDto> lessons,
    ({
      CourseCurriculumDto all,
      CourseCurriculumDto running,
      CourseCurriculumDto upcoming,
      CourseCurriculumDto attempts,
    }) remote,
  ) {
    final runningIds = remote.running.lessons.map((l) => l.id).toSet();
    final upcomingIds = remote.upcoming.lessons.map((l) => l.id).toSet();
    final attemptsById = {for (final l in remote.attempts.lessons) l.id: l};

    return lessons.map((dto) {
      final isVideoOrStream =
          dto.type == LessonType.video || dto.type == LessonType.liveStream;

      bool hasAttempts = dto.hasAttempts;
      LessonProgressStatus progressStatus = dto.progressStatus;

      if (!isVideoOrStream) {
        final remoteLesson = attemptsById[dto.id];
        if (remoteLesson != null) {
          hasAttempts = remoteLesson.hasAttempts;
          progressStatus = remoteLesson.progressStatus;
        } else {
          hasAttempts = false;
          progressStatus = LessonProgressStatus.notStarted;
        }
      }

      return _lessonDtoToCompanion(dto).copyWith(
        isRunning: Value(runningIds.contains(dto.id)),
        isUpcoming: Value(upcomingIds.contains(dto.id)),
        hasAttempts: Value(hasAttempts),
        progressStatus: Value(progressStatus.name),
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

    // Attempts call here, before anything else
    LessonDto dtoWithAttempts = dto;
    if (dto.attemptsUrl != null) {
      try {
        final lastWatched =
            await _source.getLastWatchedPosition(dto.attemptsUrl!);
        dtoWithAttempts = dto.copyWith(
          lastWatchedDuration: lastWatched,
        );
      } catch (e) {
        // Log the error but allow the lesson refresh to succeed
        debugPrint(
            'CourseRepository: Failed to fetch last watched position: $e');
      }
    }

    final existing = await getLesson(id);
    final updated = dtoWithAttempts.copyWith(isDetailFetched: true);
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
    )..where((t) => t.id.equals(id)))
        .watchSingleOrNull();
  }

  /// Direct fetch of a chapter by ID.
  Future<ChaptersTableData?> getChapter(String id) async {
    return (_db.select(
      _db.chaptersTable,
    )..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Direct fetch of lessons for a chapter from DB.
  Future<List<LessonsTableData>> getLessons(String chapterId) async {
    return (_db.select(
      _db.lessonsTable,
    )
          ..where((t) => t.chapterId.equals(chapterId))
          ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
        .get();
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

  /// Updates video attempt with watched time ranges
  Future<void> updateVideoAttempt({
    required int chapterContentId,
    required String lastWatchPosition,
    required List<List<double>> watchedTimeRanges,
  }) async {
    await _source.updateVideoAttempt(
      chapterContentId: chapterContentId,
      lastWatchPosition: lastWatchPosition,
      watchedTimeRanges: watchedTimeRanges,
    );

    // Update the local database with the new position so it resumes correctly when navigating back
    try {
      final existing = await getLesson(chapterContentId.toString());
      if (existing != null) {
        final updated =
            existing.copyWith(lastWatchedDuration: lastWatchPosition);
        await _db.upsertLessons([_lessonDtoToCompanion(updated)]);
      }
    } catch (e) {
      debugPrint('CourseRepository: Failed to update local DB after sync: $e');
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
        totalContents: row.totalContents,
        progress: row.progress,
        completedLessons: row.completedLessons,
        totalLessons: row.totalLessons,
        image: row.image,
        tags: _safeDecodeList<String>(row.tags),
        allowedDevices: _safeDecodeList<String>(row.allowedDevices),
        examsCount: row.examsCount,
        isChaptersSynced: row.isChaptersSynced,
      );

  static List<T> _safeDecodeList<T>(String? json) {
    if (json == null || json.isEmpty) return const [];
    try {
      return List<T>.from(jsonDecode(json));
    } catch (_) {
      return const [];
    }
  }

  CoursesTableCompanion _courseDtoToCompanion(CourseDto dto) =>
      CoursesTableCompanion(
        id: Value(dto.id),
        title: Value(dto.title),
        colorIndex: Value(dto.colorIndex),
        chapterCount: Value(dto.chapterCount),
        totalContents: Value(dto.totalContents),
        progress: Value(dto.progress),
        completedLessons: Value(dto.completedLessons),
        totalLessons: Value(dto.totalLessons),
        image: dto.image != null ? Value(dto.image) : const Value.absent(),
        tags: dto.tags.isNotEmpty
            ? Value(jsonEncode(dto.tags))
            : const Value.absent(),
        allowedDevices: dto.allowedDevices.isNotEmpty
            ? Value(jsonEncode(dto.allowedDevices))
            : const Value.absent(),
        examsCount: Value(dto.examsCount),
        orderIndex: Value(dto.order),
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
        parentId:
            dto.parentId != null ? Value(dto.parentId) : const Value.absent(),
        isLeaf: Value(dto.isLeaf),
        isChaptersSynced: Value(dto.isChaptersSynced),
        image: dto.image != null ? Value(dto.image) : const Value.absent(),
      );

  LessonDto rowToLessonDto(LessonsTableData row) => LessonDto(
        id: row.id,
        chapterId: row.chapterId,
        courseId: row.courseId,
        ancestorChapterIds: row.ancestorChapterIds,
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
        bookmarkId: row.bookmarkId,
        isRunning: row.isRunning,
        isUpcoming: row.isUpcoming,
        hasAttempts: row.hasAttempts,
        image: row.image,
        nextContentId: row.nextContentId,
        previousContentId: row.previousContentId,
        htmlContent: row.htmlContent,
        isDetailFetched: row.isDetailFetched,
        chatEmbedUrl: row.chatEmbedUrl,
        streamStatus: row.streamStatus,
        showRecordedVideo: row.showRecordedVideo,
        isScheduled: row.isScheduled,
        scheduledMessage: row.scheduledMessage,
        attemptsUrl: row.attemptsUrl,
        slug: row.slug,
        description: row.description,
        enableTranscript: row.enableTranscript,
        videoSubtitleUrl: row.videoSubtitleUrl,
        isAiEnabled: row.isAiEnabled,
        aiNotesUrl: row.aiNotesUrl,
        lastWatchedDuration: row.lastWatchedDuration,
        exam: row.examMetadataJson != null
            ? ExamDto.fromJson(
                jsonDecode(row.examMetadataJson!) as Map<String, dynamic>)
            : null,
      );

  LessonsTableCompanion _lessonDtoToCompanion(LessonDto dto) =>
      LessonsTableCompanion(
        id: Value(dto.id),
        chapterId: Value(dto.chapterId),
        courseId:
            dto.courseId != null ? Value(dto.courseId) : const Value.absent(),
        ancestorChapterIds: dto.ancestorChapterIds != null
            ? Value(dto.ancestorChapterIds)
            : const Value.absent(),
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
        subtitle:
            dto.subtitle != null ? Value(dto.subtitle) : const Value.absent(),
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
        bookmarkId: Value(dto.bookmarkId),
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
        chatEmbedUrl: dto.chatEmbedUrl != null
            ? Value(dto.chatEmbedUrl)
            : const Value.absent(),
        streamStatus: dto.streamStatus != null
            ? Value(dto.streamStatus)
            : const Value.absent(),
        showRecordedVideo: Value(dto.showRecordedVideo),
        isScheduled: Value(dto.isScheduled),
        scheduledMessage: dto.scheduledMessage != null
            ? Value(dto.scheduledMessage)
            : const Value.absent(),
        attemptsUrl: dto.attemptsUrl != null
            ? Value(dto.attemptsUrl)
            : const Value.absent(),
        slug: dto.slug != null ? Value(dto.slug) : const Value.absent(),
        description: dto.description != null
            ? Value(dto.description)
            : const Value.absent(),
        enableTranscript: Value(dto.enableTranscript),
        videoSubtitleUrl: dto.videoSubtitleUrl != null
            ? Value(dto.videoSubtitleUrl)
            : const Value.absent(),
        isAiEnabled: Value(dto.isAiEnabled),
        aiNotesUrl: dto.aiNotesUrl != null
            ? Value(dto.aiNotesUrl)
            : const Value.absent(),
        lastWatchedDuration: dto.lastWatchedDuration != null
            ? Value(dto.lastWatchedDuration)
            : const Value.absent(),
        examMetadataJson: dto.exam != null
            ? Value(jsonEncode(dto.exam!.toJson()))
            : const Value.absent(),
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

/// Controller returned by the repository to encapsulate paginated data fetching and DB watching.
class LessonPaginationController {
  final Stream<List<LessonDto>> lessonsStream;
  final Stream<bool> isLoadingMoreStream;
  final Stream<bool> hasMoreStream;
  final VoidCallback fetchNextPage;
  final VoidCallback dispose;

  LessonPaginationController({
    required this.lessonsStream,
    required this.isLoadingMoreStream,
    required this.hasMoreStream,
    required this.fetchNextPage,
    required this.dispose,
  });
}
