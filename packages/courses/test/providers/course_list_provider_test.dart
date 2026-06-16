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
}
