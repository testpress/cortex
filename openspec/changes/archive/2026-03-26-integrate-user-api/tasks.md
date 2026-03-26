## 1. Auth & Session Refactor

- [x] 1.1 Update `AuthProvider.build()` to return `AsyncData<bool>` (using `repo.isUserLoggedIn()`).
- [x] 1.2 Update `app_router.dart` redirection logic to correctly use `isLoggedIn == true`.
- [x] 1.3 Simplify `AuthLocalDataSource` (Boolean Token-only storage).
- [x] 1.4 Implement atomic `saveToken` in `AuthRepository`.
- [x] 1.5 Update `auth_repository_test.dart` to match atomic session logic.

## 2. Shared Meta & Persistence (Single-Record DB)

- [x] 2.1 Add `getProfile()` to `DataSource` interface and implement in `HttpDataSource`.
- [x] 2.2 Implement `watchCurrentUser()` in `UserRepository` for ID-less Drift caching.
- [x] 2.3 Implement `refreshProfile()` in `UserRepository` to sync DB with API.
- [x] 2.4 Extract `UserProgressRepository` to `core` for domain-agnostic progress tracking.
- [x] 2.5 Refactor `courses/recent_activity_provider.dart` to rely on `core` exclusively.

## 3. UserProvider Implementation (The Brain)

- [x] 3.1 Restore `userRepositoryProvider` in `packages/profile`.
- [x] 3.2 Implement `UserProvider` to watch `authProvider` and yield `Stream<UsersTableData?>`.
- [x] 3.3 Add "Refresh-on-Watch" orchestration to `UserProvider`.

## 4. UI Wiring (Decoupled & Reactive)

- [x] 4.1 Update `PaidActiveHomeScreen` to use `userProvider` for greeting.
- [x] 4.2 Update `PaidActiveProfileScreen` (`ProfilePage`) to use `userProvider`.
- [x] 4.3 Update `EditProfileScreen` to use `userProvider` for its initial state.
- [x] 4.4 Ensure `appInitializationProvider` clears `UsersTable` on logout (via `AuthProvider.logout()`).

## 5. Validation

- [x] 5.1 Run `flutter analyze` on `packages/core` and `packages/profile`.
- [x] 5.2 Verify login → background fetch → Home/Profile reactive update from DB.
