## Context

The `DesignConfig` class in `packages/core` was recently updated to include a mandatory `iconSize` parameter. This caused several widget and unit tests in `packages/core` to fail compilation because they rely on the `DesignConfig` constructor. Additionally, the project uses a multi-package structure (monorepo style) where some packages are importing others without explicitly declaring them as dependencies in their respective `pubspec.yaml` files.

## Goals / Non-Goals

**Goals:**
- Fix all compilation errors in `packages/core` tests.
- Resolve all `depend_on_referenced_packages` analyzer info messages.
- Ensure the project passes `dart analyze` with zero errors.

**Non-Goals:**
- Refactoring the `DesignConfig` class itself.
- Changing any UI behavior or design tokens.
- Migrating Riverpod providers (reserved for a later cleanup phase).

## Decisions

- **Test Fix Approach**: Use `DesignIconSize.defaults()` as the value for the `iconSize` parameter in all test-related `DesignConfig` instantiations. This ensures tests continue to run with standard values without needing custom icon size configurations for every test case.
- **Dependency Management**: Explicitly add missing dependencies to `pubspec.yaml` files for the following packages:
    - **App (Root)**: Add `courses`.
    - **Core Package**: (Verify if any are missing, though analyzer mostly complained about others).
    - **Courses Package**: Add `package_info_plus`.
    - **Testpress Package**: Add `flutter_riverpod` and `data`.

## Risks / Trade-offs

- **[Risk] Multiple manual edits** → Mitigation: Run `dart analyze` after each fix to ensure no new errors are introduced and existing ones are cleared.
- **[Risk] Incorrect dependency versioning** → Mitigation: Use existing project versions or `any` (if appropriate for internal packages) to avoid version mismatch.
