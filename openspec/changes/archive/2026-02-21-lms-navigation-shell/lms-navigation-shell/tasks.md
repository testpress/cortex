## 1. Setup & Dependencies

- [x] 1.1 Add `go_router` dependency to `packages/testpress/pubspec.yaml` (later removed; core handles this)
- [x] 1.2 Add `go_router` dependency to `packages/core/pubspec.yaml`

## 2. Shell Implementation

- [x] 2.1 Refine `AppShell` in `packages/core/lib/shell/app_shell.dart` to accept a `bottomNavigationBar`
- [x] 2.2 Ensure `AppTabBar` correctly handles navigation callbacks via the routing system

## 3. Routing Configuration

- [x] 3.1 Create `packages/testpress/lib/navigation/app_router.dart`
- [x] 3.2 Implement `StatefulShellRoute` with 4 branches: Home, Study, Explore, Profile
- [x] 3.3 Create placeholder screen widgets for Explore and Profile in their respective packages
- [x] 3.4 Define full-screen routes for `/lesson/:id` and `/video/:id`

## 4. Main App Integration

- [x] 4.1 Update the main application entry point to use `MaterialApp.router` with the new configuration
- [x] 4.2 Verify tab switching preserves state (scroll position, etc.)
- [x] 4.3 Verify full-screen navigation correctly hides the bottom shell

## 5. Cleanup

- [x] 5.1 Remove hardcoded `AppTabBar` and `AppSearchBar` playground logic from `CourseListScreen`
- [x] 5.2 Move global navigation state into the router
