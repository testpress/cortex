## Why

When a user clicks "Ask Doubt" while watching a video lesson, the navigation pushes the Ask Doubt form onto the same root navigator, so the `CustomVideoPlayer` widget stays alive and `dispose()` never fires. The user can hear the audio from the video while filling out the doubt form, which is disruptive.

When the user navigates back (pops the route), the video stops — but only because the entire video player widget tree is disposed as a side effect. There is no intentional pre-navigate cleanup.

## What Changes

- Add `finalizePlayback()` to `CustomVideoPlayerState` that finalizes the current interval, force-syncs progress to server, and destroys the native player by unmounting the `TestpressPlayer` widget (same behavior as the back button).
- Add `restorePlayback()` that recreates the `TestpressPlayer` widget and seeks to the captured position so the video resumes from where it left off.
- `DoubtTab.onBeforeNavigate` fires the destroy + sync before `context.push()`.
- `DoubtTab.onResumeVideo` fires after `await context.push()` completes (user returns from Ask Doubt), recreating the player.
- Pass `onBeforeNavigate` and `onResumeVideo` callbacks from `VideoLessonViewer` and `VideoLessonDetailScreen` down to `DoubtTab`.

## Capabilities

### New Capabilities
- `video-player-pause`: Expose `finalizePlayback()` / `restorePlayback()` on `CustomVideoPlayerState` and wire into Ask Doubt navigation.

## Impact

- **Affected Code**: `custom_video_player.dart`, `video_lesson_viewer.dart`, `video_lesson_detail_screen.dart`, `doubt_tab.dart`
- **Behavior**: Video stops completely (native player destroyed) when user taps "Ask Doubt". When returning, a fresh player is created and seeks to the last position. Progress is synced before navigation.
