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
  });
}
