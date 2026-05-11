## 1. Directory and Module Setup

- [x] 1.1 Create the directory `packages/testpress/lib/navigation/routes/`.
- [x] 1.2 Create `auth_routes.dart` and extract all onboarding/login routes and redirect logic.
- [x] 1.3 Create `home_routes.dart` and extract the Dashboard branch.
- [x] 1.4 Create `study_routes.dart` and extract the Study branch (courses, chapters, lessons, tests, assessments).
- [x] 1.5 Create `exams_routes.dart` and extract the Exams branch.
- [x] 1.6 Create `profile_routes.dart` and extract the Profile branch (settings, notifications, edit, certificates).
- [x] 1.7 Create `global_routes.dart` and extract standalone routes (Forum, Doubts, Explore, Info, Downloads, Typography).

## 2. Refactor app_router.dart

- [x] 2.1 Refactor the `GoRouter` initialization in `app_router.dart` to use the new modular route lists.
- [x] 2.2 Move `_LessonRedirector` and any other helper widgets to their respective domain modules.
- [x] 2.3 Clean up imports and unused code in `app_router.dart`.
- [x] 2.4 Consolidate Info Tab logic into `ClientConfig` and remove `infoPageEnabledProvider`.
- [x] 2.5 Implement `NavTab` enum for unified branch and tab management.

## 3. Verification

- [x] 3.1 Verify that all immersive (full-screen) routes still hide the bottom navigation bar correctly.
- [x] 3.2 Verify that the auth redirect logic still functions correctly for both protected and public routes.
- [x] 3.3 Ensure deep links (e.g., `/study/lesson/:id`) and parameters are correctly resolved.
