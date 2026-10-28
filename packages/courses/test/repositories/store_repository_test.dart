import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/data.dart';
import 'package:courses/repositories/store_repository.dart';

class MockSentryService extends SentryService {
  @override
  Future<void> captureException(dynamic exception,
      {Map<String, dynamic>? contexts,
      AppErrorLevel? level,
      dynamic stackTrace,
      Map<String, String>? tags,
      bool bypassFilter = false}) async {}
}

class TrackingMockDataSource extends MockDataSource {
  int getCourseChaptersCallCount = 0;
  int getChapterContentsCallCount = 0;

  @override
  Future<List<ChapterDto>> getCourseChapters(String courseId) async {
    getCourseChaptersCallCount++;
    return const [
      ChapterDto(
        id: 'ch-1',
        courseId: 'course-1',
        title: 'Chapter 1',
        lessonCount: 1,
        assessmentCount: 0,
        orderIndex: 0,
      ),
    ];
  }

  @override
  Future<List<LessonDto>> getChapterContents(
    String courseId,
    String chapterId,
  ) async {
    getChapterContentsCallCount++;
    return const [
      LessonDto(
        id: 'lesson-1',
        chapterId: 'ch-1',
        title: 'Lesson 1',
        type: LessonType.video,
        duration: '10 min',
        progressStatus: LessonProgressStatus.notStarted,
        isLocked: false,
        orderIndex: 0,
      ),
    ];
  }
}

void main() {
  group('StoreRepository curriculum caching', () {
    late TrackingMockDataSource dataSource;
    late StoreRepository repository;

    setUp(() {
      dataSource = TrackingMockDataSource();
      repository = StoreRepository(
        source: dataSource,
        sentryService: MockSentryService(),
      );
    });

    test('caches course chapters and avoids redundant network calls', () async {
      expect(dataSource.getCourseChaptersCallCount, 0);

      // First fetch
      final chapters1 = await repository.fetchCourseChapters('course-1');
      expect(chapters1.length, 1);
      expect(dataSource.getCourseChaptersCallCount, 1);

      // Second fetch should use in-memory cache
      final chapters2 = await repository.fetchCourseChapters('course-1');
      expect(chapters2.length, 1);
      expect(dataSource.getCourseChaptersCallCount, 1);
    });

    test('caches chapter contents and avoids redundant network calls',
        () async {
      expect(dataSource.getChapterContentsCallCount, 0);

      // First fetch
      final contents1 =
          await repository.fetchChapterContents('course-1', 'ch-1');
      expect(contents1.length, 1);
      expect(dataSource.getChapterContentsCallCount, 1);

      // Second fetch should return cached list without invoking dataSource again
      final contents2 =
          await repository.fetchChapterContents('course-1', 'ch-1');
      expect(contents2.length, 1);
      expect(dataSource.getChapterContentsCallCount, 1);
    });

    test('forceRefresh bypasses cache for course chapters and chapter contents',
        () async {
      await repository.fetchCourseChapters('course-1');
      expect(dataSource.getCourseChaptersCallCount, 1);

      // forceRefresh = true re-queries
      await repository.fetchCourseChapters('course-1', forceRefresh: true);
      expect(dataSource.getCourseChaptersCallCount, 2);

      await repository.fetchChapterContents('course-1', 'ch-1');
      expect(dataSource.getChapterContentsCallCount, 1);

      // forceRefresh = true re-queries
      await repository.fetchChapterContents('course-1', 'ch-1',
          forceRefresh: true);
      expect(dataSource.getChapterContentsCallCount, 2);
    });

    test('clearCurriculum clears curriculum caches', () async {
      await repository.fetchChapterContents('course-1', 'ch-1');
      expect(dataSource.getChapterContentsCallCount, 1);

      repository.clearCurriculum(courseId: 'course-1');

      // Next call should re-query
      await repository.fetchChapterContents('course-1', 'ch-1');
      expect(dataSource.getChapterContentsCallCount, 2);
    });

    test('clearAll clears curriculum caches', () async {
      await repository.fetchChapterContents('course-1', 'ch-1');
      expect(dataSource.getChapterContentsCallCount, 1);

      repository.clearAll();

      // Next call should re-query
      await repository.fetchChapterContents('course-1', 'ch-1');
      expect(dataSource.getChapterContentsCallCount, 2);
    });
  });
}
