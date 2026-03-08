## 1. Data Foundation & Models
- [ ] 1.1 Move `RecentActivityDto` and related models from `packages/courses/lib/models/` to `packages/data/lib/models/`.
- [ ] 1.2 Export new models in `packages/data/lib/data.dart`.
- [ ] 1.3 Create a simple `IProfileRepository` abstract class in `packages/data` (keep it minimal).

## 2. Profile Package Setup
- [ ] 2.1 Create `packages/profile` directory structure.
- [ ] 2.2 Initialize `pubspec.yaml` for `packages/profile` with minimal dependencies on `core` and `data`.
- [ ] 2.3 Create `MockProfileRepository` in `packages/profile` using existing mock data.

## 3. State & Logic Refactoring
- [ ] 3.1 Move `notificationPreferencesProvider` from `packages/courses` to `packages/profile/lib/providers/`.
- [ ] 3.2 Extract stats calculation (strongest subject, etc.) from `ProfileSnapshotCard` into a simple `profileStatsProvider` in `packages/profile`.
- [ ] 3.3 Set up `profileProvider` that reads the user from the repository.

## 4. Widget & Screen Migration
- [ ] 4.1 Copy profile-specific widgets (Header, Snapshot, etc.) to `packages/profile/lib/widgets/`.
- [ ] 4.2 Update widgets to be private/internal and use the new `profileStatsProvider`.
- [ ] 4.3 Move `ProfilePage` and `NotificationsScreen` to `packages/profile/lib/screens/`.

## 5. Wiring & Cleanup
- [ ] 5.1 Link the new screens in `packages/testpress/lib/navigation/app_router.dart`.
- [ ] 5.2 Verification: Ensure 'Blind Navigation' from `courses/dashboard_drawer.dart` still works.
- [ ] 5.3 Cleanup: Delete the old profile code and mock-data parts from the `courses` package.
