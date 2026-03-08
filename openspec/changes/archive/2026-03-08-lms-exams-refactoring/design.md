## Context

The `courses` package currently holds the complete implementation of tests, exams, and assessments (screens, widgets, layout models, and mock data). Since the project has a designated `exams` package meant to handle exam-specific features, this leads to a bloated `courses` library and incorrect separation of concerns.

## Goals / Non-Goals

**Goals:**
- Relocate all files related to test, assessment, and exam answers review smoothly from `packages/courses` to `packages/exams`.
- Ensure everything compiles successfully with updated imports following the file move.
- Make the `exams` package the primary module for test/assessment features.

**Non-Goals:**
- No functionality changes to the test/assessment screens or business logic.
- No new UI screens or features are being designed as part of this scope.

## Decisions

- **File Migration Strategy:**
  - Move from `courses/lib/*` to corresponding directories in `exams/lib/*` (e.g., `lib/screens/`, `lib/widgets/`).
  - Update relative and absolute imports inside migrated files from `package:courses/...` to `package:exams/...` or relative paths.
- **Dependency Management:**
  - The `exams` package will be updated in its `pubspec.yaml` to depend on `core`, `data`, and potentially `courses` if there's any deep interconnection left, though the goal is minimizing coupling.
- **Router Updates:**
  - Update global or parent routing components (e.g., in `packages/testpress`) to import the screens from the `exams` package instead of `courses`.

## Risks / Trade-offs

- **Dependency Compilation Errors:** `exams` package may lack some dependencies that `courses` had.
  - *Mitigation:* Ensure we add missing internal or external dependencies to `packages/exams/pubspec.yaml` and verify via `flutter pub get`.
- **Breaking imports all over the codebase:**
  - *Mitigation:* Will rely on IDE tools and `flutter analyze` to replace references globally.
