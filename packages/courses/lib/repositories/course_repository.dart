import 'dart:async';
import 'package:async/async.dart';
import 'package:drift/drift.dart';

import 'package:core/data/data.dart';

/// Repository for all course-related operations.
/// Owns the bridge between [DataSource] (network/mock) and [AppDatabase] (local cache).
/// UI should only interact with [watchCourses], [watchChapters], [watchLessons] streams.
class CourseRepository {
  final AppDatabase _db;
  final DataSource _source;

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
      (_db.select(_db.coursesTable)..where((t) => t.id.equals(courseId))).watch(),
      (_db.select(_db.chaptersTable)..where((t) => t.courseId.equals(courseId))).watch(),
    ]);

    yield* combinedWatcher.asyncMap((_) async {
      final courseData = await (_db.select(_db.coursesTable)
            ..where((t) => t.id.equals(courseId)))
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
            ..where((t) => t.courseId.equals(courseId) & t.parentId.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
          .get();

      return course.copyWith(
        chapters: chaptersData.map(rowToChapterDto).toList(),
      );
    });
  }

  /// Fetch courses for a specific [page] from [DataSource] and persist to local DB.
  Future<PaginatedResponseDto<CourseDto>> refreshCourses({
    int page = 1,
  }) async {
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

  Stream<List<ChaptersTableData>> watchChapters(String courseId, {String? parentId}) {
    final query = _db.select(_db.chaptersTable)
      ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]);

    if (parentId == null) {
      query.where((t) => t.courseId.equals(courseId) & t.parentId.isNull());
    } else {
      query.where((t) => t.parentId.equals(parentId));
    }

    return query.watch();
  }

  /// Checks if chapters/subjects for a course or folder are already in the DB.
  Future<bool> isChaptersSynced(String courseId, {String? parentId}) async {
    final rowId = parentId ?? courseId;
    final isChapter = parentId != null;

    if (isChapter) {
      final chapter = await (_db.select(_db.chaptersTable)..where((t) => t.id.equals(rowId))).getSingleOrNull();
      return chapter?.isChaptersSynced ?? false;
    } else {
      final course = await (_db.select(_db.coursesTable)..where((t) => t.id.equals(rowId))).getSingleOrNull();
      return course?.isChaptersSynced ?? false;
    }
  }

  /// Refreshes chapters for a course or folder and marks it as synced.
  Future<List<ChapterDto>> refreshChapters(String courseId, {String? parentId}) async {
    final chapters = await _source.getChapters(courseId, parentId: parentId);
    
    await _db.upsertChapters(chapters.map(_chapterDtoToCompanion).toList());
    await _markAsSynced(courseId: courseId, folderId: parentId);

    return chapters;
  }

  // ── Internal Helpers ─────────────────────────────────────────────────────

  Future<void> _markAsSynced({required String courseId, String? folderId}) async {
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

  Future<List<LessonDto>> refreshLessons(String chapterId) async {
    final lessons = await _source.getLessons(chapterId);
    final companions = lessons.map(_lessonDtoToCompanion).toList();
    await _db.upsertLessons(companions);
    return lessons;
  }

  /// Direct fetch of a lesson by ID.
  Future<LessonDto?> getLesson(String id) async {
    final row = await _db.getLessonById(id);
    return row != null ? rowToLessonDto(row) : null;
  }

  /// Watch a single lesson by its ID.
  Stream<LessonsTableData?> watchLesson(String id) {
    return _db.watchLesson(id);
  }

  /// Watch a single chapter by its ID.
  Stream<ChaptersTableData?> watchChapter(String id) {
    return (_db.select(_db.chaptersTable)..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  /// Toggles the bookmark status locally.
  Future<void> toggleLessonBookmark(String id) async {
    await _db.toggleLessonBookmark(id);
  }

  /// Updates lesson progress locally.
  Future<void> updateLessonProgress(
      String id, LessonProgressStatus status) async {
    await _db.updateLessonProgress(id, status);
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
      CoursesTableCompanion.insert(
        id: dto.id,
        title: dto.title,
        colorIndex: dto.colorIndex,
        chapterCount: dto.chapterCount,
        totalDuration: dto.totalDuration,
        totalContents: Value(dto.totalContents),
        progress: Value(dto.progress),
        completedLessons: Value(dto.completedLessons),
        totalLessons: dto.totalLessons,
        image: Value(dto.image),
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
      ChaptersTableCompanion.insert(
        id: dto.id,
        courseId: dto.courseId,
        title: dto.title,
        lessonCount: dto.lessonCount,
        assessmentCount: dto.assessmentCount,
        orderIndex: dto.orderIndex,
        parentId: Value(dto.parentId),
        isLeaf: Value(dto.isLeaf),
        isChaptersSynced: Value(dto.isChaptersSynced),
        image: Value(dto.image),
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
      );

  LessonsTableCompanion _lessonDtoToCompanion(LessonDto dto) =>
      LessonsTableCompanion.insert(
        id: dto.id,
        chapterId: dto.chapterId,
        title: dto.title,
        type: dto.type.name,
        duration: dto.duration,
        progressStatus: Value(dto.progressStatus.name),
        isLocked: Value(dto.isLocked),
        orderIndex: dto.orderIndex,
        chapterTitle: Value(dto.chapterTitle),
        contentUrl: Value(dto.contentUrl),
        subtitle: Value(dto.subtitle),
        subjectName: Value(dto.subjectName),
        subjectIndex: Value(dto.subjectIndex),
        lessonNumber: Value(dto.lessonNumber),
        totalLessons: Value(dto.totalLessons),
        isBookmarked: Value(dto.isBookmarked),
      );

  LessonType _parseType(String s) => LessonType.values.firstWhere(
        (e) => e.name == s,
        orElse: () => LessonType.video,
      );

  LessonProgressStatus _parseStatus(String s) =>
      LessonProgressStatus.values.firstWhere(
        (e) => e.name == s,
        orElse: () => LessonProgressStatus.notStarted,
      );
}
