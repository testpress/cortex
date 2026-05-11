## Why

The current `app_router.dart` is a single 800-line file that manages over 35 distinct routes. This "God File" is difficult to maintain, prone to merge conflicts, and confusing for developers to navigate. Modularizing the routing configuration into feature-based files will improve maintainability, domain ownership, and clarity.

## What Changes

- **Route Extraction**: All route definitions will be moved from `app_router.dart` into a new `routes/` directory.
- **Logical Grouping**: Routes will be grouped into `auth_routes.dart`, `home_routes.dart`, `study_routes.dart`, `exams_routes.dart`, `profile_routes.dart`, and `global_routes.dart`.
- **Coordinator Pattern**: `app_router.dart` will be refactored to act as a lightweight coordinator using a `NavTab` enum as a single source of truth.
- **Encapsulation**: Helper widgets and specialized routing logic (like redirectors) will be moved to their respective feature modules.
- **Config Consolidation**: Runtime feature flags (like `showInfoTab`) will be moved into `ClientConfig` to clean up redundant providers.

## Capabilities

### New Capabilities
- `navigation-modularization`: Architectural refactoring of the routing system into a modular, maintainable structure.

### Modified Capabilities
- `lms-navigation-shell`: The navigation shell will now consume modular routes instead of inline definitions.

## Impact

- `packages/testpress/lib/navigation/app_router.dart`: Will be significantly reduced in size.
- `packages/testpress/lib/navigation/routes/`: New directory containing modular route definitions.
- All navigation-related code in the `testpress` package.
- `packages/core/lib/data/config/client_capabilities.dart`: Deleted (consolidated into `ClientConfig`).
