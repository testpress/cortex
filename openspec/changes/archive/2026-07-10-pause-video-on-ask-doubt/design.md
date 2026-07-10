## Context

Currently, clicking "Ask Doubt" inside a video lesson pushes a new route on the same root navigator. The `CustomVideoPlayer` widget remains in the tree but is visually hidden. The native player continues playing because the `TestpressPlayer` widget stays mounted. The user hears audio from the video while filling out the doubt form.

The back button works correctly because it pops the route, destroying the entire widget tree. The `TestpressPlayer` widget is unmounted, which triggers the native SDK to release the player. Progress is saved via `dispose()` → `forceSync()`.

There are two video player screens that embed `CustomVideoPlayer`:
1. `VideoLessonViewer` (used inside `LessonDetailOrchestrator`)
2. `VideoLessonDetailScreen` (standalone screen, dead code)

## Goals / Non-Goals

**Goals:**
- Destroy the native player when user taps "Ask Doubt" (same as back button behavior)
- Resume playback from the correct position when user returns from Ask Doubt
- Sync video progress to server before destroying the player
- Keep changes minimal and localized

**Non-Goals:**
- Changing the navigation architecture (routes stay stacked on root navigator)
- Adding global route lifecycle hooks
- Changing the Ask Doubt form behavior

## Decisions

**Decision 1: Unmount TestpressPlayer to destroy native player (not just pause)**
Instead of calling `_controller?.pause()`, we set a `_isPlayerDestroyed` flag and return `SizedBox.shrink()` from `build()`. This unmounts `TestpressPlayer`, causing the native SDK to fully release the player — exactly like the back button.
*Rationale:* A simple `pause()` keeps the native player alive (buffering audio/video). The back button destroys it entirely. To match that behavior, we need to remove the widget from the tree.

**Decision 2: Recreate the player on return from Ask Doubt**
`DoubtTab` awaits `context.push()` (which returns a `Future` that completes when the pushed route is popped), then calls `onResumeVideo` which resets the flag and calls `setState()`. A fresh `TestpressPlayer` is rendered.
*Rationale:* GoRouter's `push()` returns a `Future` — this is the cleanest hook for post-navigation cleanup without adding route lifecycle infrastructure.

**Decision 3: Capture position before destroy, seek on restore**
`_lastPosition` is captured into `_pendingSeekPosition` before destroying the player. On restore, `_hasSeekedToInitial` is reset and `_onPlayerCreated` uses `_pendingSeekPosition ?? widget.initialPosition` for the initial seek.
*Rationale:* `widget.initialPosition` is set once at page load and never updates. Using a captured position ensures the seek target reflects where the user actually was.
