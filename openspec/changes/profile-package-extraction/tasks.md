## 1. Data Foundation & Models
- [x] 1.1 Move `RecentActivityDto` and related models from `packages/courses/lib/models/` to `packages/data/lib/models/`. (Centralized & Immutable)
- [x] 1.2 Export new models in `packages/data/lib/data.dart`.
- [x] 1.3 Stabilize `UserDto` and shared identity providers in `packages/data`.

## 2. Profile Package Setup
- [x] 2.1 Create `packages/profile` directory structure.
- [x] 2.2 Initialize `pubspec.yaml` for `packages/profile` with minimal dependencies on `core` and `data`.
- [x] 2.3 Create `profile_mock_data.dart` in `packages/profile` using existing profile-only mock data.

## 3. State & Logic Refactoring
- [x] 3.1 Move `notificationPreferencesProvider` from `packages/courses` to `packages/profile/lib/providers/`.
- [x] 3.2 Deduplicate state: Remove `profileStatsProvider` and consume `studyMomentumProvider` from `data` package.
- [x] 3.3 Deduplicate state: Centralize `designModeProvider` in `data` package and consume throughout.

## 4. Widget & Screen Migration
- [x] 4.1 Copy profile-specific widgets (Header, Snapshot, etc.) to `packages/profile/lib/widgets/`.
- [x] 4.2 Update widgets to consume centralized providers.
- [x] 4.3 Move `ProfilePage` and `NotificationsScreen` to `packages/profile/lib/screens/`.

## 5. Wiring & Cleanup
- [x] 5.1 Link the new screens in `packages/testpress/lib/navigation/app_router.dart`.
- [x] 5.2 Verification: Ensure 'Blind Navigation' from `courses/dashboard_drawer.dart` still works.
- [x] 5.3 Cleanup: Delete the old profile code and redundant exports from the `courses` package.
