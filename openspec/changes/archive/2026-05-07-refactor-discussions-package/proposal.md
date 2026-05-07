# Proposal: refactor-discussions-package

## Why
The existing `forum` package name is too narrow for our upcoming "Ask Mentor" expansion. Renaming it to `discussions` allows it to serve as a unified hub for both public community threads and private student-mentor dialogues.

## What Changes
1.  **Directory Rename**: Rename `packages/forum` to `packages/discussions`.
2.  **Package Identity**: Update `pubspec.yaml` and the main library entry point.
3.  **Global Import Update (BREAKING)**: Replace all `package:forum/` imports with `package:discussions/`.
4.  **Dependency Alignment**: Update all dependent packages (`app`, `testpress`, etc.).

## Capabilities

### New Capabilities
- `discussions-refactor`: The structural transition and standardization of the package naming.

## Impact
- **All Packages**: Breaking changes to imports and dependency names.
- **Navigation**: Update router imports.
