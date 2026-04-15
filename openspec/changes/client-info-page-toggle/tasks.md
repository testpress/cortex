## 1. Package Infrastructure

- [ ] 1.1 Create `packages/client_info` with the standard SDK boilerplate.
- [ ] 1.2 Configure `pubspec.yaml` to include core dependencies (`core`, `riverpod`, `lucide_icons`).

## 2. Code Migration & Implementation

- [ ] 2.1 Migrate models and providers from `packages/profile` to `packages/client_info`.
- [ ] 2.2 Migrate `ClientInfoPage` and `ClientInfoCourseDetailScreen` to the new package.
- [ ] 2.3 Clean up the `profile` package by removing the migrated files and any stale exports.

## 3. Navigation & Wiring

- [ ] 3.1 Update `packages/testpress` to import `package:client_info`.
- [ ] 3.2 Refactor `app_router.dart` and the shell navigation builders to use screens from the new package.
- [ ] 3.3 Ensure the client-toggle logic correctly wires the 5th tab to the new package's entry point.

## 4. Validation

- [ ] 4.1 Update tests to reflect the new package structure.
- [ ] 4.2 Verify that the `ENABLE_INFO_PAGE` flag still correctly toggles between Profile and Info across different configurations.
- [ ] 4.3 Smoke test the external video launch flow from the new package location.
