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

## 5. Enforce Domain Isolation
- [x] 5.1 Relocate `RecentActivityDto` and its mock data from `courses` to `profile` so profile no longer imports `package:courses` for domain models.
- [x] 5.2 Replace the `courses` `upcomingTests` provider so it no longer imports `package:exams`—serve its dashboard tests from course-owned DTOs or mocks instead.
- [x] 5.3 Verify `packages/courses` has zero `package:exams` imports and `packages/profile` no longer imports `package:courses`.

## 6. Restore Exam Mock Depth
- [x] 6.1 Expand the thermodynamics mock questions so the dataset includes at least 30 curated entries across MCQ, multiple-select, and true/false types.
- [x] 6.2 Update the thermodynamics mock test metadata (question IDs, totalQuestions) to match the expanded list.
- [x] 6.3 Rerun `flutter analyze` (workspace) and confirm no new errors were introduced while touching the exams package.
