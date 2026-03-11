## 1. Decentralize Feature Logic
- [x] 1.1 Move Profile & Settings repositories/providers from `data` to `profile`
- [x] 1.2 Move Course repositories/providers from `data` to `courses`
- [x] 1.3 Move Exam repositories/providers from `data` to `exams`
- [x] 1.4 Relocate `DashboardDrawer` to `testpress` package to resolve circular coupling

## 2. Consolidate Shared Foundation in Core
- [x] 2.1 Move shared Models (DTOs) from `data` to `packages/core/lib/data/models/`
- [x] 2.2 Move `AppDatabase` and database providers to `packages/core/lib/data/db/`
- [x] 2.3 Move `authProvider` and global auth logic to `packages/core/lib/data/auth/`
- [x] 2.4 Update all cross-package imports to use `package:core/data/`
- [x] 2.5 Remove the `packages/data` package entirely

## 3. Implementation Verification
- [x] 3.1 Clean up orphaned files in feature packages
- [x] 3.2 Run `flutter pub get` and `build_runner build` in all packages
- [x] 3.3 Verify app stability and dependency graph cleanliness
## 4. Decentralize DTOs and Mocks from Core
- [x] 4.1 Move feature-specific DTOs (`Assignment`, `Learner`, `Momentum`, `Shortcut`, `Banner`, `RecentActivity`) to `courses`
- [x] 4.2 Move `TestDto` to `exams`
- [x] 4.3 Relocate feature mock data from `core/infra/mock_data.dart` to feature packages
- [x] 4.4 Update `core/data.dart` exports and all project-wide imports
- [x] 4.5 Verify `core` has zero imports from feature packages
- [x] 4.6 Final build verification (`flutter pub get`, `dart analyze`)
