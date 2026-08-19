import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/data/data.dart';
import 'package:drift/native.dart';
import 'package:courses/providers/course_list_provider.dart';
import 'package:courses/repositories/course_repository.dart';

class MockCourseRepository extends CourseRepository {
  MockCourseRepository()
      : super(AppDatabase(NativeDatabase.memory()), MockDataSource(),
            MockSentryService());

  int searchCalls = 0;
  bool shouldThrow = false;

  @override
  Future<PaginatedResponseDto<CourseDto>> searchCourses({
    required String query,
    int page = 1,
  }) async {
    searchCalls++;
    if (shouldThrow) {
      throw Exception('Search failed');
    }
    return PaginatedResponseDto(results: []);
  }
}

class MockSentryService extends SentryService {
  @override
  Future<void> captureException(dynamic exception,
      {Map<String, dynamic>? contexts,
      AppErrorLevel? level,
      dynamic stackTrace,
      Map<String, String>? tags}) async {}
}

class FakeAuth extends Auth {
  bool _loggedIn = true;

  @override
  Future<bool> build() async => _loggedIn;

  void setLoggedIn(bool value) {
    _loggedIn = value;
    state = AsyncData(value);
  }
}

void main() {
  test('courseSyncMetadataProvider resets to null on logout', () async {
    final fakeAuth = FakeAuth();
    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWith(() => fakeAuth),
      ],
    );

    // Wait for authProvider to initialize
    await container.read(authProvider.future);

    // Initial state is null
    expect(container.read(courseSyncMetadataProvider), isNull);

    // Mark as synced
    container.read(courseSyncMetadataProvider.notifier).markSynced();
    final syncedTime = container.read(courseSyncMetadataProvider);
    expect(syncedTime, isNotNull);

    // Transition authProvider to logged out
    fakeAuth.setLoggedIn(false);

    // Verify metadata resets to null immediately on dependency change
    expect(container.read(courseSyncMetadataProvider), isNull);
  });

  group('CourseSearchState copyWith', () {
    test('preserves error when error parameter is not specified', () {
      final originalError = Exception('original error');
      final state = CourseSearchState(
        query: 'flutter',
        isLoading: true,
        error: originalError,
      );

      final updated = state.copyWith(isLoading: false);

      expect(updated.isLoading, isFalse);
      expect(updated.query, equals('flutter'));
      expect(updated.error, equals(originalError));
    });

    test('clears error when error parameter is explicitly set to null', () {
      final state = CourseSearchState(
        query: 'flutter',
        isLoading: true,
        error: Exception('original error'),
      );

      final updated = state.copyWith(error: null, isLoading: false);

      expect(updated.isLoading, isFalse);
      expect(updated.error, isNull);
    });

    test('updates error when new error is provided', () {
      final state = CourseSearchState(
        query: 'flutter',
        isLoading: true,
        error: Exception('original error'),
      );

      final newError = Exception('new error');
      final updated = state.copyWith(error: newError);

      expect(updated.error, equals(newError));
    });
  });

  group('CourseSearch provider error handling', () {
    test('clears stale error on successful retry/loadMore', () async {
      final mockRepo = MockCourseRepository();
      final container = ProviderContainer(
        overrides: [
          courseRepositoryProvider.overrideWith((ref) => mockRepo),
        ],
      );

      final notifier = container.read(courseSearchProvider.notifier);

      // 1. Make the first search fail (sets error)
      mockRepo.shouldThrow = true;
      await notifier.search('flutter');

      expect(container.read(courseSearchProvider).error, isNotNull);
      expect(mockRepo.searchCalls, 1);

      // 2. Make the retry (loadMore) succeed (should clear error)
      mockRepo.shouldThrow = false;
      await notifier.loadMore();

      expect(container.read(courseSearchProvider).error, isNull);
      expect(mockRepo.searchCalls, 2);
    });
  });
}
