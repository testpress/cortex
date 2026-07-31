## Why

The current transcript view in the video lesson details remains static during playback. To provide an interactive and immersive learning experience similar to modern video players (like YouTube), the transcript should automatically highlight the currently spoken sentence, keep it scrolled into view, and allow the user to easily toggle back to auto-sync mode if they manually scroll away.

Additionally, the UI of the transcript items needs to be modernized and made more compact, aligning the timestamp and text directly without excessive spacing.

## What Changes

- **Active Cue Highlighting**: Change font style of the currently spoken cue to bold (using `FontWeight.bold`) and apply active text color.
- **Auto-Scrolling**: Automatically scroll the transcript container to keep the active cue centered/visible.
- **Scroll Override**: Detect when the user manually scrolls the transcript list, and pause auto-scrolling.
- **"Sync to Video" Overlay Button**: Show a floating button when auto-scroll is paused; clicking it resumes auto-scrolling and centers the active cue.
- **Modernized Transcript UI Layout**: Re-align the timestamp and the transcript text to be compact and continuous, resembling YouTube's transcript layout.
- **Position Tracking Integration**: Update `CustomVideoPlayer` and `VideoLessonViewer` to broadcast/propagate current playback progress.

## Capabilities

### Modified Capabilities
- `video-lesson-subtabs`: Add playback-synchronized auto-scrolling, cue highlighting, user-scroll detection, sync-to-video button, and compact YouTube-like UI layout to the transcripts tab.

## Impact

- `packages/courses/lib/widgets/lesson_detail/custom_video_player.dart`
- `packages/courses/lib/widgets/lesson_detail/video_lesson_viewer.dart`
- `packages/courses/lib/widgets/lesson_detail/transcripts_tab.dart`
