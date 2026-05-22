## 1. Repository Deduplication

- [x] 1.1 Add `Future<UserDto>? _activeProfileRefresh` to `UserRepository` (`packages/profile/lib/repositories/user_repository.dart`) to memoize in-flight network fetches.
- [x] 1.2 Update `UserRepository.refreshProfile()` to return the existing `_activeProfileRefresh` if active, instead of launching a new request.
- [x] 1.3 Ensure `_activeProfileRefresh` is cleared on both success and error to allow future manual refreshes.

## 2. Provider Cleanup

- [x] 2.1 Remove the background `userRepository.refreshProfile().ignore()` call from the `user` StreamProvider in `packages/profile/lib/providers/user_provider.dart`.
- [x] 2.2 Verify `appInitialization` in `packages/testpress/lib/providers/initialization_provider.dart` remains the sole orchestrator triggering `refreshProfile()` upon login or startup.
