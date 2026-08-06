import 'package:core/data/data.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courses/providers/chapter_detail_provider.dart';
import 'package:courses/repositories/course_repository.dart';
import 'package:courses/providers/course_list_provider.dart';

class MockCourseRepository extends CourseRepository {
  MockCourseRepository()
      : super(AppDatabase(NativeDatabase.memory()), MockDataSource(),
            MockSentryService());

  bool syncChapterContentsCalled = false;
  bool refreshContentStatusesCalled = false;

  @override
  Future<List<LessonDto>> syncChapterContents(
      String courseId, String chapterId) async {
    syncChapterContentsCalled = true;
    return [];
  }

  @override
  Future<void> refreshContentStatuses(String courseId,
      {String? chapterId}) async {
    refreshContentStatusesCalled = true;
  }
}

class ErrorCourseRepository extends MockCourseRepository {
  @override
  Future<List<LessonDto>> syncChapterContents(
      String courseId, String chapterId) async {
    throw Exception('Sync failed');
  }
}

class MockSentryService extends SentryService {
  Exception? capturedException;

  @override
  Future<void> captureException(dynamic exception,
      {Map<String, dynamic>? contexts,
      AppErrorLevel? level,
      dynamic stackTrace,
      Map<String, String>? tags}) async {
    capturedException = exception as Exception;
  }
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  group('ChapterDetailController', () {
    late ProviderContainer container;
    late MockCourseRepository mockRepo;
    late MockSentryService mockSentry;

    setUp(() {
      mockRepo = MockCourseRepository();
      mockSentry = MockSentryService();
      container = ProviderContainer(
        overrides: [
          courseRepositoryProvider.overrideWith((ref) => mockRepo),
          sentryServiceProvider.overrideWithValue(mockSentry),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initialSync completes successfully and updates state', () async {
      final controller =
          container.read(chapterDetailControllerProvider.notifier);

      expect(container.read(chapterDetailControllerProvider), true);

      await controller.initialSync('course-1', 'chapter-1');

      expect(mockRepo.syncChapterContentsCalled, true);
      expect(mockRepo.refreshContentStatusesCalled, true);
      expect(container.read(chapterDetailControllerProvider), false);
    });

    test('initialSync captures exception and updates state to false on error',
        () async {
      final errorRepo = ErrorCourseRepository();
      container = ProviderContainer(
        overrides: [
          courseRepositoryProvider.overrideWith((ref) => errorRepo),
          sentryServiceProvider.overrideWithValue(mockSentry),
        ],
      );

      final controller =
          container.read(chapterDetailControllerProvider.notifier);

      await controller.initialSync('course-1', 'chapter-1');

      expect(mockSentry.capturedException, isNotNull);
      expect(container.read(chapterDetailControllerProvider), false);
    });

    test('refresh completes successfully and updates state', () async {
      final controller =
          container.read(chapterDetailControllerProvider.notifier);

      // Assume initial state is false after some operation
      container.read(chapterDetailControllerProvider.notifier).state = false;

      final future = controller.refresh('course-1', 'chapter-1');

      // Should immediately be true
      expect(container.read(chapterDetailControllerProvider), true);

      await future;

      expect(mockRepo.syncChapterContentsCalled, true);
      expect(mockRepo.refreshContentStatusesCalled, true);
      expect(container.read(chapterDetailControllerProvider), false);
    });

    test(
        'refresh captures exception, rethrows, and updates state to false on error',
        () async {
      final errorRepo = ErrorCourseRepository();
      container = ProviderContainer(
        overrides: [
          courseRepositoryProvider.overrideWith((ref) => errorRepo),
          sentryServiceProvider.overrideWithValue(mockSentry),
        ],
      );

      final controller =
          container.read(chapterDetailControllerProvider.notifier);

      await expectLater(
        controller.refresh('course-1', 'chapter-1'),
        throwsA(isA<Exception>()),
      );

      expect(mockSentry.capturedException, isNotNull);
      expect(container.read(chapterDetailControllerProvider), false);
    });
  });
}
