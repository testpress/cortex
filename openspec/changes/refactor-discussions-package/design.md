## Context
The `forum` package is being elevated to a `discussions` package to support the Phase 9 "Ask Mentor" feature.

## Goals / Non-Goals
**Goals:**
- Complete the rename with zero remaining `forum` references in imports.
- Ensure build stability after the rename.

**Non-Goals:**
- Renaming internal files (e.g., `forum_repository.dart`) in this phase. This refactor is focused on the package-level namespace.

## Decisions
### 1. Namespace Transition
- **Decision**: Rename `packages/forum` to `packages/discussions` and update `pubspec.yaml`.
- **Rationale**: Provides a broader semantic home for multiple discussion types.

### 2. URL Path Alignment
- **Decision**: Update the router path from `forum` to `discussions`.
- **Rationale**: Aligns user-facing URLs with the new branding. Deep-link compatibility is secondary to naming consistency in this phase.

## Risks / Trade-offs
- **[Risk]** Breaking dependencies in `app` and `testpress`.
- **[Mitigation]** Sequential update: 1. Rename dir, 2. Update pubspec, 3. Update imports, 4. `flutter pub get`.
