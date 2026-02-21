## Context

The application needs a unified navigation shell that mimics the Figma design. Currently, components like `AppTabBar` are being tested in isolation within individual screens. This change will establish the permanent routing architecture.

## Goals / Non-Goals

**Goals:**
- Implement a 4-tab bottom navigation shell (Home, Study, Explore, Profile).
- Enable "Stateful" routing where each tab preserves its scroll position and state when switching.
- Support "Full-screen" routing for depth views (Lessons, Videos) that hide the bottom bar.
- Use `GoRouter` as the standard navigation library.

**Non-Goals:**
- Implementing the inner content of all 4 tabs (this change focuses on the *shell* and routing).
- Implementing authentication guards at this stage (to be added in a future security-focused change).

## Decisions

- **Routing Library**: Use `go_router` for its first-class support for sub-routes and stateful shells.
- **Stateful Shell**: Use `StatefulShellRoute.indexedStack` to ensure that when a user switches from "Study" to "Home" and back, they are exactly where they left off.
- **Shell Location**: The `AppShell` will act as a generic wrapper residing in `packages/core`. The specific navigation configuration (routes, mappings) and nested shell logic will live in `packages/testpress` and imported into the root `app`. `go_router` will be defined as a dependency in `packages/core` to serve as a single abstraction point.
- **Root App Wrapper**: The top-level application in `app/lib/main.dart` uses `MaterialApp.router` strictly as a foundational engine for localization and text directionality, NOT for Material UI components. We override its default behavior by intercepting the `builder` to inject our own `DesignSystem` topography. This ensures zero Material visual leaking, guaranteeing pixel-perfect identical cross-platform rendering (iOS and Android).

## Risks / Trade-offs

- **Deep Linking complexity**: Early adoption of nested routing requires careful path naming to avoid collisions.
- **State management**: Stateful shells consume more memory as multiple screen states are kept in the `IndexedStack`. Given the targeted mobile platforms, this is an acceptable trade-off for the premium UX it provides.
