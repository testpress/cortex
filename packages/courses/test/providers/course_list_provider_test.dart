import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/data/data.dart';
import 'package:courses/providers/course_list_provider.dart';

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
}
