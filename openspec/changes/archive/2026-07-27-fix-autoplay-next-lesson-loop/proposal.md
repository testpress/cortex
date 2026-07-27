## Why

When the Auto-Play Next Lesson feature is enabled, navigating back to a previously completed video lesson (using the Previous button or other navigation) causes the app to immediately auto-play the next lesson again. This is because the video player seeks to the end (its last watched position), triggering a video completion event which immediately auto-navigates the user forward, creating an inescapable loop.

## What Changes

- Modify completed video lessons to initialize their playback position at `0.0` rather than the end of the video, so that users can replay them from the beginning.
- Introduce an initialization completion guard in `CustomVideoPlayer` that ignores completion events if the video was initialized at or near the end.
- Allow completion events to fire normally if the user actively seeks backward or replays the video from a non-completed position.

## Capabilities

### Modified Capabilities
- `unified-lesson-shell`: Refine "AutoPlay Next Video Evaluation" to specify that initialization or seek-on-load to near-end positions of a video lesson must not trigger automatic navigation.

## Impact

- `packages/courses/lib/widgets/lesson_detail/custom_video_player.dart`
- `packages/courses/lib/widgets/lesson_detail/video_lesson_viewer.dart`
- `packages/courses/lib/screens/video_lesson_detail_screen.dart`
