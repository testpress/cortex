## Why

The current navigation structure uses a tabbed layout (`StatefulShellRoute.indexedStack`), where "deep dive" learning components like video lessons, text chapters, forum discussions, and doubt details are pushed *inside* the bottom navigation tabs. This causes several issues:
1. **Memory Leaks and Video Bugs**: Because `IndexedStack` hides tabs instead of disposing them, heavy resources like the `TestpressPlayer` remain active when users switch tabs, leading to severe memory leaks and audio playing in the background indefinitely.
2. **Cluttered UX**: Immersive study and communication experiences are constantly constrained by the bottom navigation bar.

To fix these bugs and provide an immersive, focused learning experience, we need to flatten the hierarchy and push all deep subroutes onto the root navigator.

## What Changes

- Modify `app_router.dart` to push "deep dive" routes (chapter lists, lesson details, tests, assessments, forums, and doubt details) onto the root navigator (`_rootNavigatorKey`) rather than the shell navigator.
- This will completely hide the bottom navigation bar on all these specific screens, making them full-screen.
- When users navigate away (via the back button) to return to the course lists, these screens and their heavy native components will be cleanly popped and disposed of by Flutter natively.

## Capabilities

### New Capabilities

### Modified Capabilities
- `lms-navigation-shell`: Modifying the navigation rules so that all core study/discussion subroutes render immersively via the root navigator, effectively disabling the bottom tab bar on these screens.

## Impact

- **app_router.dart**: Will receive `parentNavigatorKey: _rootNavigatorKey` on the `course/:courseId/chapters`, `lesson/:id`, `test/:id`, `assessment/:id`, `discussions/forum/posts/:courseId`, and `discussions/doubts` routes (and their sub-routes).
- **User Experience**: The bottom navigation bar will only be visible on the top-level tab screens (like the dashboard and course lists). The study and discussion experience becomes immersive.
- **Resource Management**: Automatically fixes the video player memory leak and background audio issues by ensuring native resource disposal.
