## Why

A recent update to the `DesignConfig` class added a mandatory `iconSize` parameter. This change was not propagated to the test suite in `packages/core`, leading to compilation errors that block CI and local testing. Additionally, several packages are missing explicit dependencies in their `pubspec.yaml` files for imported packages, which causes analyzer warnings and potential build failures in fresh environments.

## What Changes

- **Update Core Tests**: Modify `design_motion_test.dart`, `design_provider_test.dart`, and `app_primitive_design_test.dart` in `packages/core` to include the required `iconSize` argument (using `DesignIconSize.defaults()`) in `DesignConfig` constructors.
- **Fix Dependency Declarations**: 
  - Add `courses` as a dependency to the main `app`.
  - Add `package_info_plus` as a dependency to `packages/courses`.
  - Add `flutter_riverpod` and `data` as dependencies to `packages/testpress`.
- **Analyzer Cleanup**: Resolve the specific warnings and info messages identified in the `dart analyze` report related to these infrastructure issues.

## Capabilities

### New Capabilities
- None (This is a maintenance and infrastructure stability change).

### Modified Capabilities
- None (Behavioral requirements are unchanged; this resolves implementation inconsistencies with existing design system specs).

## Impact

- **Core Package**: Restores test suite functionality.
- **Dependency Graph**: Ensures correct package resolution and adherence to `depend_on_referenced_packages` lint rules.
- **Developer Experience**: Resolves red analyzer markers in the IDE.
