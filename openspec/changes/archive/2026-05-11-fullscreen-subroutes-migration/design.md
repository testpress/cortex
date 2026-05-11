## Context

Currently, the app's bottom navigation bar uses `StatefulShellRoute.indexedStack`. Subroutes like `course/:courseId/chapters`, `lesson/:id`, `test/:id`, and forum threads are rendered *inside* the study/community branch. This keeps them alive in memory when hidden (causing video background play and memory leaks) and crowds the screen real estate for immersive study tasks.

## Goals / Non-Goals

**Goals:**
- Render all deep-dive study and community screens (lessons, tests, assessments, chapters, forums, doubt details) as immersive, full-screen pages.
- Enforce native disposal of heavy resources (like Video Players) when leaving the immersive screen.
- Retain existing deep-link capabilities and path structures.

**Non-Goals:**
- Modifying the underlying video player (`TestpressPlayer`).
- Restructuring the actual widget layout of the dashboard or course lists.
- Removing bottom tabs entirely (they remain on top-level branch screens).

## Decisions

1. **Push Subroutes to `_rootNavigatorKey`**: We will add `parentNavigatorKey: _rootNavigatorKey` to all deep-dive routes in `app_router.dart`. 
   - *Rationale*: This is a pure `GoRouter` architectural fix that requires zero custom state management, zero hacking with `visibility_detector`, and perfectly aligns with the framework's intent for transitioning from shell navigators to root navigators.

## Risks / Trade-offs

- [Risk] Users might find it jarring that they can no longer switch directly to 'Profile' or 'Explore' from inside a video player. → *Mitigation*: This is standard UX for immersive content (e.g., YouTube, Netflix). The back button clearly returns them to the tabbed environment.
