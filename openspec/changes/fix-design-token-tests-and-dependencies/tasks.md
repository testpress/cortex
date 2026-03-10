## 1. Fix Core Package Tests

- [x] 1.1 Update `packages/core/test/design/design_motion_test.dart` with `iconSize` argument
- [x] 1.2 Update `packages/core/test/design/design_provider_test.dart` with `iconSize` argument
- [x] 1.3 Update `packages/core/test/widgets/app_primitive_design_test.dart` with `iconSize` argument

## 2. Resolve Dependency Issues

- [x] 2.1 Add `courses` dependency to `app/pubspec.yaml`
- [x] 2.2 Add `package_info_plus` dependency to `packages/courses/pubspec.yaml`
- [x] 2.3 Add `flutter_riverpod` and `data` dependencies to `packages/testpress/pubspec.yaml`
- [x] 2.4 Run `flutter pub get` across affected packages

## 3. Verification

- [x] 3.1 Run `dart analyze` to ensure all Tier 1 blockers are resolved
- [x] 3.2 Verify that all errors and specific dependency warnings are cleared
