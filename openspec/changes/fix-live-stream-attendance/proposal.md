## Why

TPStreams live classes played on Android (Cortex Flutter) stream the video successfully but fail to record user attendance, causing the "View Attendees" report on the institute dashboard to remain empty for mobile attendees. This occurs because `LiveStreamViewer` instantiates `CustomVideoPlayer` without supplying `lessonId`, leaving player attempt synchronization inactive and skipping the `POST /api/v2.3/contents/<id>/attempts/` attempt creation request that marks attendance.

## What Changes

- Pass `lessonId: lesson.id` and `thumbnailUrl: lesson.image` to `CustomVideoPlayer` in `LiveStreamViewer` (omitting `onComplete` so temporary stream stalls or live-edge buffering do not prematurely mark the lesson as completed).
- Ensure `CustomVideoPlayer` activates `videoAttemptNotifierProvider` for live streams, initializing an attempt session via `POST /api/v2.3/contents/<id>/attempts/` and syncing watch intervals.
- Add widget tests verifying that `LiveStreamViewer` passes `lessonId` to `CustomVideoPlayer` without `onComplete`.

## Capabilities

### New Capabilities
<!-- None -->

### Modified Capabilities
- `live-stream`: Add requirement that active TPStreams live streams render `CustomVideoPlayer` with the lesson ID so attendance and attempt tracking are initialized on playback.

## Impact

- `packages/courses/lib/widgets/lesson_detail/live_stream_viewer.dart`: Pass `lessonId` and related props to `CustomVideoPlayer`.
- `packages/courses/test/widgets/live_stream_viewer_test.dart`: Assert `CustomVideoPlayer` receives `lessonId`.
- No API contract changes or database schema migrations needed.
