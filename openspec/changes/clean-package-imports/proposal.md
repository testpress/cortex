## Why

The codebase currently contains several analyzer warnings related to unused imports, unnecessary imports, and unused shown names. These issues clutter the code, increase cognitive load for developers, and can slightly impact compile times. Cleaning these up ensures a healthier, more professional codebase and eliminates "noise" from the `dart analyze` report.

## What Changes

- **Remove Unused Imports**: Clean up imports in `app/lib/main.dart`, `packages/courses/lib/providers/dashboard_providers.dart`, `packages/profile/lib/providers/profile_providers.dart`, and `packages/profile/lib/data/profile_mock_data.dart`.
- **Resolve Unnecessary Imports**: Remove redundant `material.dart` imports in files where `widgets.dart` already provides the necessary symbols, or vice versa (specifically in `packages/exams` and `packages/profile/test`).
- **Clean Up Shown Names**: Remove unused `shown` members like `FontWeight` in `test_question_card.dart`.
- **Standardize Router Imports**: Resolve unnecessary package imports in `app_router.dart`.

## Capabilities

### New Capabilities
- None (Maintenance focus).

### Modified Capabilities
- None (Internal code cleanup only).

## Impact

- **Code Quality**: Reduces analyzer warnings to zero for the touched files.
- **Maintainability**: Cleaner import blocks across multiple packages.
