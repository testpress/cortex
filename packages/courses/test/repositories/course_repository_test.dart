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

      // Should immediately increment count
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
  });
}
