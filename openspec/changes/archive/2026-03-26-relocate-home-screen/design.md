## Context

The `PaidActiveHomeScreen` is currently located in `packages/courses`. For a modular monorepo, top-level dashboard aggregation belongs in the app shell rather than in a domain-specific package.

## Goals / Non-Goals

**Goals:**
- Move `PaidActiveHomeScreen` from `packages/courses` to `packages/testpress` (the app shell).
- Update the App Router to point to the new location.
- Remove the home screen export from the `courses` domain library.

**Non-Goals:**
- Any changes related to the student identity or `userProvider` logic in this phase.
- Redesigning the dashboard contents beyond the relocation effort.

## Decisions

### 1. Relocate to testpress
The `testpress` package is the consumer orchestrator of the project. Relocating the dashboard here is the correct architectural home.

### 2. Standardize Imports
We will update the `courses` import in the home screen to use the package syntax (`package:courses/courses.dart`) now that the file lives in the shell.

## Risks / Trade-offs

- **Risk**: Missing imports during the move.
- **Mitigation**: Systematic refactor of all file exports and routing references project-wide. 
