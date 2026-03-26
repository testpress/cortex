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
  Stream<List<CourseDto>> watchCourses() {
    return _db.watchAllCourses().map(
          (rows) => rows.map(_rowToCourseDto).toList(),
        );
  }

  /// Fetch courses from [DataSource] and persist to local DB.
  Future<List<CourseDto>> refreshCourses() async {
    final courses = await _source.getCourses();
    final companions = courses.map(_courseDtoToCompanion).toList();
    await _db.upsertCourses(companions);
    return courses;
  }

  // ── Chapters ─────────────────────────────────────────────────────────────

  Stream<List<ChapterDto>> watchChapters(String courseId) {
    return _db
        .watchChaptersForCourse(courseId)
        .map((rows) => rows.map(_rowToChapterDto).toList());
  }

  Future<List<ChapterDto>> refreshChapters(String courseId) async {
    final chapters = await _source.getChapters(courseId);
    final companions = chapters.map(_chapterDtoToCompanion).toList();
    await _db.upsertChapters(companions);
    return chapters;
  }

  // ── Lessons ───────────────────────────────────────────────────────────────

  Stream<List<LessonDto>> watchLessons(String chapterId) {
    return _db
        .watchLessonsForChapter(chapterId)
        .map((rows) => rows.map(_rowToLessonDto).toList());
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
    return row != null ? _rowToLessonDto(row) : null;
  }

  /// Watch a single lesson by its ID.
  Stream<LessonDto?> watchLesson(String id) {
    return _db
        .watchLesson(id)
        .map((row) => row != null ? _rowToLessonDto(row) : null);
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

  CourseDto _rowToCourseDto(CoursesTableData row) => CourseDto(
        id: row.id,
        title: row.title,
        colorIndex: row.colorIndex,
        chapterCount: row.chapterCount,
        totalDuration: row.totalDuration,
        progress: row.progress,
        completedLessons: row.completedLessons,
        totalLessons: row.totalLessons,
      );

  CoursesTableCompanion _courseDtoToCompanion(CourseDto dto) =>
      CoursesTableCompanion.insert(
        id: dto.id,
        title: dto.title,
        colorIndex: dto.colorIndex,
        chapterCount: dto.chapterCount,
        totalDuration: dto.totalDuration,
        progress: Value(dto.progress),
        completedLessons: Value(dto.completedLessons),
        totalLessons: dto.totalLessons,
      );

  ChapterDto _rowToChapterDto(ChaptersTableData row) => ChapterDto(
        id: row.id,
        courseId: row.courseId,
        title: row.title,
        lessonCount: row.lessonCount,
        assessmentCount: row.assessmentCount,
        orderIndex: row.orderIndex,
      );

  ChaptersTableCompanion _chapterDtoToCompanion(ChapterDto dto) =>
      ChaptersTableCompanion.insert(
        id: dto.id,
        courseId: dto.courseId,
        title: dto.title,
        lessonCount: dto.lessonCount,
        assessmentCount: dto.assessmentCount,
        orderIndex: dto.orderIndex,
      );

  LessonDto _rowToLessonDto(LessonsTableData row) => LessonDto(
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
