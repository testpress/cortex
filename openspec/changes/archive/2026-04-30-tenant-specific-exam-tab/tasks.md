## 1. Model & Data Layer

- [x] 1.1 Add `showExamTab` and `useRestrictedNavigation` to `ClientConfig` model in `packages/core/lib/data/models/client_config.dart`.
- [x] 1.2 Update `ClientConfig.brilliant` static constant with the new flags set to `true`.
- [x] 1.3 Update `ClientConfig.fromJson` and `toJson` to handle the new fields.

## 2. UI & Screen Layer

- [x] 2.1 Create `ExamsScreen` placeholder in `packages/exams/lib/screens/exams_screen.dart`.
- [x] 2.2 Export `ExamsScreen` from `packages/exams/lib/exams.dart`.

## 3. Navigation Layer

- [x] 3.1 Update `buildPrimaryNavigationItems` in `packages/testpress/lib/navigation/app_router.dart` to conditionally include the Exam tab and filter Explore/Profile if `useRestrictedNavigation` is true.
- [x] 3.2 Add the Exams branch to `StatefulShellRoute.indexedStack` in `app_router.dart`.
- [x] 3.3 Refactor `_tabPaths` and `_getCurrentTabId` to derive paths dynamically from the active navigation items instead of hardcoded lists.
- [x] 3.4 Update `_onTabItemTapped` to correctly map tab IDs to branch indices.
- [x] 3.5 Verify that for "brilliantpala", the tab bar shows: Home, Study, Exam, Info.
- [x] 3.6 Verify that for other tenants, the existing navigation (Home, Study, Explore, [Info], Profile) remains functional.
