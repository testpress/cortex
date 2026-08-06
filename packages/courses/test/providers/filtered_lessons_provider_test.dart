import 'dart:async';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/data/data.dart';
import 'package:courses/providers/filtered_lessons_provider.dart';
import 'package:courses/repositories/course_repository.dart';
import 'package:courses/providers/course_list_provider.dart';

class MockSentryService extends SentryService {
  @override
  Future<void> captureException(dynamic exception,
      {Map<String, dynamic>? contexts,
      AppErrorLevel? level,
      dynamic stackTrace,
      Map<String, String>? tags}) async {}
}

class MockLessonPaginationController extends LessonPaginationController {
  MockLessonPaginationController({
    required super.lessonsStream,
    required super.isLoadingMoreStream,
    required super.hasMoreStream,
    required super.fetchNextPage,
    required super.refresh,
    required super.dispose,
  });

  bool refreshCalled = false;
  bool fetchNextPageCalled = false;
  bool disposeCalled = false;

  @override
  VoidCallback get fetchNextPage => () {
        fetchNextPageCalled = true;
      };

  @override
  Future<void> Function() get refresh => () async {
        refreshCalled = true;
      };

  @override
  VoidCallback get dispose => () {
        disposeCalled = true;
      };
}

class MockCourseRepository extends CourseRepository {
  MockCourseRepository()
      : super(AppDatabase(NativeDatabase.memory()), MockDataSource(),
            MockSentryService());

  MockLessonPaginationController? mockController;

  @override
  LessonPaginationController getFilteredLessonsController(
    String courseId, {
    String? chapterId,
    String? type,
  }) {
    mockController = MockLessonPaginationController(
      lessonsStream: const Stream.empty(),
      isLoadingMoreStream: const Stream.empty(),
      hasMoreStream: const Stream.empty(),
      fetchNextPage: () {},
      refresh: () async {},
      dispose: () {},
    );
    return mockController!;
  }
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('FilteredLessons', () {
    late ProviderContainer container;
    late MockCourseRepository mockRepo;

    setUp(() {
      mockRepo = MockCourseRepository();
      container = ProviderContainer(
        overrides: [
          courseRepositoryProvider
              .overrideWith((ref) => Future.value(mockRepo)),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('refresh calls underlying controller refresh', () async {
      // Initialize the provider
      final subscription = container.listen(
        filteredLessonsProvider('course-1', chapterId: 'chapter-1'),
        (_, __) {},
      );

      // Wait for repository to resolve and controller to be created
      await container.read(courseRepositoryProvider.future);
      while (mockRepo.mockController == null) {
        await Future.delayed(const Duration(milliseconds: 10));
      }

      final controller = mockRepo.mockController;
      expect(controller, isNotNull);

      // Call refresh on the provider
      await container
          .read(filteredLessonsProvider('course-1', chapterId: 'chapter-1')
              .notifier)
          .refresh();

      expect(controller!.refreshCalled, true);

      subscription.close();
    });

    test('fetchNextPage calls underlying controller fetchNextPage', () async {
      final subscription = container.listen(
        filteredLessonsProvider('course-1', chapterId: 'chapter-1'),
        (_, __) {},
      );

      await container.read(courseRepositoryProvider.future);
      while (mockRepo.mockController == null) {
        await Future.delayed(const Duration(milliseconds: 10));
      }

      final controller = mockRepo.mockController;
      expect(controller, isNotNull);

      container
          .read(filteredLessonsProvider('course-1', chapterId: 'chapter-1')
              .notifier)
          .fetchNextPage();

      expect(controller!.fetchNextPageCalled, true);

      subscription.close();
    });
  });
}
