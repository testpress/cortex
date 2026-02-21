# Proposal: LMS Navigation Shell & App Routing

## Problem Statement

The LMS application requires a standardized navigation structure to support its core learning experience. Following the Figma design reference, the app needs a persistent bottom navigation bar across its main sections—Home, Study, Explore, and Profile—while also supporting full-screen modal flows for immersive content like Lesson Readers, Video Players, and Discussion Forums.

Without a robust navigation shell, the application cannot maintain state between tabs or handle the complex branching required for different user states (Paid Active, Paid New, Non-Paid).

## What Changes

1.  **Application Shell**: Implement a master `AppShell` in the `core` package that integrates smoothly with the `AppTabBar` without restricting the chosen routing map.
2.  **Stateful Routing**: Configure `GoRouter` with `StatefulShellRoute` to enable independent state persistence for each navigation tab.
3.  **Route Mapping**: Define the initial set of routes for Phase 1 and 2, including:
    -   `/home` (Home Tab)
    -   `/study` (Study Tab)
    -   `/explore` (Explore Tab)
    -   `/profile` (Profile Tab)
    -   `/lesson/:id` (Fullscreen Lesson)
    -   `/video/:id` (Fullscreen Video)
4.  **Refactoring**: Move the navigation and primitive testing logic currently residing in `CourseListScreen` into a dedicated navigation structure and temporary "Demo/Debug" tab if needed.

## Capabilities

### New Capabilities
- `lms-navigation-shell`: Provides the core layout and routing logic for the entire application, ensuring persistent navigation and smooth transitions between tabs and full-screen views.

## Impact

- **`packages/app`**: Minimal bootstrapping point executing the provided Router.
- **`packages/testpress`**: Primary location for routing configuration, coordinating multiple features.
- **`packages/core`**: The `AppShell` and `AppTabBar` components will be unified, acting as the foundation for complex navigation scenarios.
- **`packages/courses`**: Existing screens will be moved into the new routed structure.
- **Dependencies**: Introduces `go_router` as the primary navigation dependency for the app.
