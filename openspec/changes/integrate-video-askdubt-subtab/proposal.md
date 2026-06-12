## Why

The lesson detail experience supports multiple types of content (video, pdf, notes). Students frequently need to ask clarifying questions directly while watching a video lesson. Integrating a "Doubt Tab" directly into the video viewer's subtabs (alongside Notes and Transcripts) makes it seamless for students to ask and browse lesson-specific doubts without leaving the context of the player.

## What Changes

- Add a new "Doubt Tab" subtab inside the video lesson viewer.
- The tab will display a paginated list of existing doubts associated with the current lesson.
- A floating action button (FAB) inside the tab allows users to ask a new doubt specific to this lesson content.
- Ensure the scrolling behavior functions correctly without causing unbounded height exceptions when integrated into the `LessonDetailShell` or `TabBarView`.
- Resolve architectural boundaries between `courses` and `discussions` packages (either through core injection or relocating the doubt providers) to prevent circular dependencies.

## Capabilities

### New Capabilities
- None

### Modified Capabilities
- `video-lesson-subtabs`: Integrate the Doubt Tab as one of the default tabs available in the video lesson view.
- `ask-doubt-fab`: Display the Ask Doubt FAB contextually within the Doubt Tab instead of floating globally, when viewing video lessons.

## Impact

- `packages/courses`: The video player and orchestrator widgets (`VideoLessonViewer`, `VideoLessonDetailScreen`, `LessonDetailOrchestrator`) are impacted as they need to accommodate the new tab and handle its scroll mechanics.
- `packages/discussions`: `doubt_providers.dart` is impacted in how it is exposed, due to potential circular dependency risks when `courses` consumes it directly.
