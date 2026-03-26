## Why

The `PaidActiveHomeScreen` (the main dashboard) currently resides in the `courses` package. As a top-level feature orchestrator that aggregates various domain contents, its location in a domain-specific package violates our "SDK-first" modularity. Moving it to the app shell ensures that domain packages remain focused and decoupled.

## What Changes

- **MOVE**: Relocate `PaidActiveHomeScreen` from `packages/courses/lib/screens/` to `packages/testpress/lib/screens/dashboard/`.
- **ARCHITECTURAL CLEANUP**: Update the project-wide navigation to reference the new dashboard location.
- **DECOUPLING**: Ensure the `courses` package remains a pure domain provider without housing the primary application entry screen.

## Capabilities

### New Capabilities
- `dashboard-relocation`: Establishing the main application dashboard within the `testpress` app shell to serve as a high-integrity feature orchestrator.

### Modified Capabilities
None.

## Impact

- **Affected Code**: `PaidActiveHomeScreen` (moved), `AppRouter` (path updates), `packages/courses` (export cleanup).
- **Dependencies**: Restores strict domain boundaries by keeping the orchestrating screen in the shell layer.
