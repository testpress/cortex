import 'dart:async';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/data.dart';
import 'package:courses/repositories/course_repository.dart';

class MockSentryService extends SentryService {
  @override
  Future<void> captureException(dynamic exception,
      {Map<String, dynamic>? contexts,
      AppErrorLevel? level,
      dynamic stackTrace,
      Map<String, String>? tags}) async {}
}

class TestableCourseRepository extends CourseRepository {
  TestableCourseRepository()
      : super(AppDatabase(NativeDatabase.memory()), MockDataSource(),
            MockSentryService());

  final watchController = StreamController<List<LessonDto>>.broadcast();
  final apiController = StreamController<List<LessonDto>>.broadcast();

  int apiStreamCallCount = 0;

  @override
  Stream<List<LessonDto>> watchFilteredLessonsLocal(
    String courseId, {
    String? chapterId,
    String? type,
  }) {
    return watchController.stream;
  }

  @override
  Stream<List<LessonDto>> streamFilteredContents(
    String courseId, {
    String? chapterId,
    String? type,
  }) {
    apiStreamCallCount++;
    return apiController.stream;
  }
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  group('CourseRepository getFilteredLessonsController', () {
    late TestableCourseRepository repo;

    setUp(() {
      repo = TestableCourseRepository();
    });

    tearDown(() {
      repo.watchController.close();
      repo.apiController.close();
    });

    test('startApiSync cancels existing stream and starts a new one', () async {
      final controller = repo.getFilteredLessonsController('course-1');

      // startApiSync is called in a microtask automatically on creation
      await Future.microtask(() {});
      expect(repo.apiStreamCallCount, 1);

      // Call refresh to trigger startApiSync again
      final refreshFuture = controller.refresh();

      // startApiSync awaits apiSub?.cancel(), which yields the event loop.
      // We must wait for the event loop to flush before the stream count increments.
      await pumpEventQueue();

      // Should immediately increment count after the cancel completes
      expect(repo.apiStreamCallCount, 2);

      // Simulate API stream completing
      repo.apiController.add([]);
      repo.apiController.close();

      await refreshFuture;

      controller.dispose();
    });

    test('fetchNextPage resumes api sub if it was paused', () async {
      final controller = repo.getFilteredLessonsController('course-1');

      await Future.microtask(() {});
      expect(repo.apiStreamCallCount, 1);

      // The api sub pauses when it receives data
      repo.apiController.add([
        const LessonDto(
            id: '1',
            title: 'Test',
            chapterId: '1',
            type: LessonType.video,
            orderIndex: 1,
            isLocked: false,
            hasAttempts: false,
            isRunning: false,
            isUpcoming: false,
            hasEnded: false,
            allowDownload: false,
            watermarkBeforeDownload: false,
            duration: '0',
            progressStatus: LessonProgressStatus.notStarted)
      ]);

      await Future.delayed(Duration.zero);

      bool isLoadingMore = false;
      final sub = controller.isLoadingMoreStream.listen((val) {
        isLoadingMore = val;
      });

      // It should not be loading more now
      expect(isLoadingMore, false);

      // Now fetch next page
      controller.fetchNextPage();

      await Future.microtask(() {});

      expect(isLoadingMore, true);

      sub.cancel();
      controller.dispose();
    });

    test(
        'enrichContentStatuses correctly applies attempts to video, stream, and non-video lessons',
        () {
      final List<LessonDto> localLessons = [
        const LessonDto(
          id: 'vid-1',
          title: 'Video 1',
          chapterId: 'c1',
          type: LessonType.video,
          orderIndex: 1,
          duration: '10 min',
          isLocked: false,
          hasAttempts: false,
          progressStatus: LessonProgressStatus.notStarted,
        ),
        const LessonDto(
          id: 'exam-1',
          title: 'Exam 1',
          chapterId: 'c1',
          type: LessonType.test,
          orderIndex: 2,
          duration: '60 min',
          isLocked: false,
          hasAttempts: false,
          progressStatus: LessonProgressStatus.notStarted,
        ),
        const LessonDto(
          id: 'attach-1',
          title: 'PDF 1',
          chapterId: 'c1',
          type: LessonType.attachment,
          orderIndex: 3,
          duration: '',
          isLocked: false,
          hasAttempts: true,
          progressStatus: LessonProgressStatus.completed,
        ),
      ];

      final remoteAttempts = CourseCurriculumDto(
        lessons: [
          const LessonDto(
            id: 'vid-1',
            title: 'Video 1',
            chapterId: 'c1',
            type: LessonType.video,
            orderIndex: 1,
            duration: '10 min',
            isLocked: false,
            hasAttempts: true,
            progressStatus: LessonProgressStatus.inProgress,
          ),
          const LessonDto(
            id: 'exam-1',
            title: 'Exam 1',
            chapterId: 'c1',
            type: LessonType.test,
            orderIndex: 2,
            duration: '60 min',
            isLocked: false,
            hasAttempts: true,
            progressStatus: LessonProgressStatus.completed,
          ),
        ],
        chapters: const [],
      );

      final emptyCurriculum =
          const CourseCurriculumDto(lessons: [], chapters: []);

      final enriched = repo.applyContentStatusesForTest(
        localLessons,
        (
          all: emptyCurriculum,
          running: emptyCurriculum,
          upcoming: emptyCurriculum,
          attempts: remoteAttempts,
        ),
      );

      expect(enriched.length, 3);

      // Video 1 should have attempts synced from remoteAttempts
      final vid = enriched.firstWhere((c) => c.id.value == 'vid-1');
      expect(vid.hasAttempts.value, true);
      expect(vid.progressStatus.value, 'inProgress');

      // Exam 1 should have attempts synced from remoteAttempts
      final exam = enriched.firstWhere((c) => c.id.value == 'exam-1');
      expect(exam.hasAttempts.value, true);
      expect(exam.progressStatus.value, 'completed');

      // PDF 1 is NOT in remoteAttempts, so non-video gets reset to notStarted
      final pdf = enriched.firstWhere((c) => c.id.value == 'attach-1');
      expect(pdf.hasAttempts.value, false);
      expect(pdf.progressStatus.value, 'notStarted');
    });

    test('refreshCourseDetail preserves existing progress and completedLessons',
        () async {
      final db = AppDatabase(NativeDatabase.memory());
      final fakeSource = FakeProgressDataSource();
      final repository = CourseRepository(db, fakeSource, MockSentryService());

      // Seed database with a course having 60% progress and 6 completed lessons
      await db.upsertCourses([
        const CoursesTableCompanion(
          id: Value('course-101'),
          title: Value('Flutter Mastery'),
          colorIndex: Value(1),
          chapterCount: Value(5),
          totalContents: Value(10),
          progress: Value(60.0),
          completedLessons: Value(6),
        ),
      ]);

      // 1. Server returns course detail WITHOUT progress (null)
      fakeSource.detailToReturn = const CourseDto(
        id: 'course-101',
        title: 'Flutter Mastery Updated Title',
        colorIndex: 1,
        chapterCount: 5,
        totalContents: 10,
        progress: null,
        completedLessons: null,
      );

      final result = await repository.refreshCourseDetail('course-101');

      expect(result?.title, 'Flutter Mastery Updated Title');
      expect(result?.progress, 60.0);
      expect(result?.completedLessons, 6);

      // Verify the database row retained the progress
      final updatedCourse = await repository.getCourse('course-101');
      expect(updatedCourse?.progress, 60.0);
      expect(updatedCourse?.completedLessons, 6);
      expect(updatedCourse?.title, 'Flutter Mastery Updated Title');

      // 2. Server genuinely returns progress: 0.0 (e.g. course reset)
      fakeSource.detailToReturn = const CourseDto(
        id: 'course-101',
        title: 'Flutter Mastery Reset',
        colorIndex: 1,
        chapterCount: 5,
        totalContents: 10,
        progress: 0.0,
        completedLessons: 0,
      );

      final resetResult = await repository.refreshCourseDetail('course-101');
      expect(resetResult?.progress, 0.0);
      expect(resetResult?.completedLessons, 0);

      final resetDbCourse = await repository.getCourse('course-101');
      expect(resetDbCourse?.progress, 0.0);
      expect(resetDbCourse?.completedLessons, 0);

      // 3. Server updates metadata (e.g. order set to 0, tags cleared)
      fakeSource.detailToReturn = const CourseDto(
        id: 'course-101',
        title: 'Flutter Mastery Top Order',
        colorIndex: 2,
        chapterCount: 5,
        totalContents: 10,
        order: 0,
        tags: [],
        progress: null,
        completedLessons: null,
      );

      final metadataResult = await repository.refreshCourseDetail('course-101');
      expect(metadataResult?.title, 'Flutter Mastery Top Order');
      expect(metadataResult?.colorIndex, 2);
      expect(metadataResult?.order, 0);
      expect(metadataResult?.tags, isEmpty);
    });

    test(
        'refreshLesson skips parent hydration if course and chapters already synced',
        () async {
      final db = AppDatabase(NativeDatabase.memory());
      final fakeSource = FakeProgressDataSource();
      final repository = CourseRepository(db, fakeSource, MockSentryService());

      // Seed database with course (isChaptersSynced: true)
      await db.upsertCourses([
        const CoursesTableCompanion(
          id: Value('course-101'),
          title: Value('Flutter Mastery'),
          colorIndex: Value(1),
          chapterCount: Value(5),
          totalContents: Value(10),
          isChaptersSynced: Value(true),
        ),
      ]);

      fakeSource.lessonToReturn = const LessonDto(
        id: 'lesson-1',
        title: 'Intro Lesson',
        chapterId: 'chap-1',
        courseId: 'course-101',
        type: LessonType.notes,
        orderIndex: 1,
        duration: '10 min',
        isLocked: false,
        progressStatus: LessonProgressStatus.notStarted,
      );

      await repository.refreshLesson('lesson-1');
      await pumpEventQueue();

      // Should have fetched the lesson, but NOT course detail or chapters
      expect(fakeSource.getLessonDetailCallCount, 1);
      expect(fakeSource.getCourseDetailCallCount, 0);
      expect(fakeSource.getChaptersCallCount, 0);
    });
  });
}

class FakeProgressDataSource extends MockDataSource {
  CourseDto? detailToReturn;
  LessonDto? lessonToReturn;

  int getCourseDetailCallCount = 0;
  int getChaptersCallCount = 0;
  int getLessonDetailCallCount = 0;

  @override
  Future<CourseDto> getCourseDetail(String courseId) async {
    getCourseDetailCallCount++;
    if (detailToReturn != null) {
      return detailToReturn!;
    }
    return super.getCourseDetail(courseId);
  }

  @override
  Future<List<ChapterDto>> getChapters(String courseId,
      {String? parentId}) async {
    getChaptersCallCount++;
    return super.getChapters(courseId, parentId: parentId);
  }

  @override
  Future<LessonDto> getLessonDetail(String lessonId) async {
    getLessonDetailCallCount++;
    if (lessonToReturn != null) {
      return lessonToReturn!;
    }
    return super.getLessonDetail(lessonId);
  }
}
