## Context

The current `app_router.dart` is a monolithic file containing all route definitions, redirects, and navigation-shell logic. This makes it difficult to maintain and expand the app's features. We recently migrated deep-dive routes to the root navigator, adding more complexity to this file.

## Goals / Non-Goals

**Goals:**
- Split `app_router.dart` into manageable, domain-specific modules.
- Maintain all existing functionality, including immersive (full-screen) routing.
- Simplify the main router entry point.
- Improve developer productivity by making routes easier to find and modify.

**Non-Goals:**
- Changing the actual URL paths (this is a pure refactor).
- Redesigning the UI of the navigation shell.
- Moving routes to separate packages (this will stay within the `testpress` package for now).

## Decisions

### 1. Static Module Pattern
**Decision**: Each route module will be a class with static getters for its route list.
**Rationale**: This is a simple, standard pattern in Flutter/GoRouter apps. It avoids the need for instance management while providing a clear namespace (e.g., `StudyRoutes.routes`).
**Alternative**: Function-based extraction. *Discarded* because classes provide a better structure for grouping related helpers (like redirects or transition builders).

### 2. Directory Structure
**Decision**: Create a `navigation/routes/` sub-directory.
**Rationale**: Keeps the navigation folder clean and explicitly separates the router configuration from the actual route definitions.

### 3. Shared Navigator Keys
**Decision**: Keep `_rootNavigatorKey` and other global keys in the main `app_router.dart` but pass them to modules as parameters.
**Rationale**: All modules need access to the same keys to ensure `parentNavigatorKey` works correctly. Passing them as parameters prevents circular dependencies while maintaining a single root key.

### 4. Unified Branch Configuration (NavTab)
**Decision**: Introduce a `NavTab` enum in `app_router.dart`.
**Rationale**: This enum centralizes IDs, labels, and icons. It allows the router to dynamically generate both the `StatefulShellBranch` list and the `AppTabItem` list from a single filtered source, preventing index-mismatch bugs.

### 5. Runtime Config Consolidation
**Decision**: Add `showInfoTab` to `ClientConfig` and remove `infoPageEnabledProvider`.
**Rationale**: This simplifies the router logic by making all tab visibility dependent on a single `ClientConfig` object rather than multiple disparate providers or compile-time flags.

## Risks / Trade-offs

- **Risk: Broken Routes** → Mitigation: Use named routes where possible and perform thorough verification of deep-link paths after the refactor.
- **Risk: Circular Dependencies** → Mitigation: Ensure route modules only import necessary screens and core utilities, never each other or the main `app_router.dart`.
- **Trade-off: More Files** → We are trading "one big file" for "multiple small files." This increases the number of files in the project but significantly improves readability.
