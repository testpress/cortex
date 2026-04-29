## 1. Feature Infrastructure

- [x] 1.1 Consolidate Info feature within `packages/courses/lib/`.
- [x] 1.2 Update `packages/courses/pubspec.yaml` to include necessary dependencies (`url_launcher`).

## 2. Code Implementation & Renaming

- [x] 2.1 Migrate models and providers to `packages/courses/lib/models/info_models.dart` and `packages/courses/lib/providers/info_providers.dart`.
- [x] 2.2 Rename and migrate `ClientInfoPage` to `InfoPage` and `ClientInfoCourseDetailScreen` to `InfoCourseDetailScreen` within the courses package.
- [x] 2.3 Rename feature toggle provider to `infoPageEnabledProvider` for consistency.

## 3. Navigation & Wiring

- [x] 3.1 Update `packages/testpress` to use the consolidated info features from `package:courses`.
- [x] 3.2 Refactor `app_router.dart` and the shell navigation builders to use renamed screens and providers.
- [x] 3.3 Ensure the client-toggle logic correctly wires the 4th/5th tab to the info entry point.

## 4. Validation

- [x] 4.1 Update tests to reflect the new consolidated structure and naming.
- [x] 4.2 Verify that the `ENABLE_INFO_PAGE` flag still correctly toggles between Profile and Info across different configurations.
- [x] 4.3 Smoke test the external video launch flow from the courses package.
- [x] 4.4 Remove redundant `onTap` handlers from `AppSemantics` button containers to optimize accessibility and prevent double execution.
- [x] 4.5 Update `app_router_test.dart` to match the 5-tab navigation implementation.
- [x] 4.6 Add error handling (try-catch) to the external video launcher in `InfoCourseDetailScreen` to prevent platform-specific crashes.
- [x] 4.7 Implement safe bounds handling (modulo) for subject color palette access in `InfoPage` to prevent out-of-bounds crashes with large hash values.

