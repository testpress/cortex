## Why
When closing and reopening the app, video playback currently starts from the beginning instead of resuming from the saved position. This happens because:
1. Watched time ranges are only flushed from `CustomVideoPlayer` to `VideoAttemptNotifier` upon pause or seek gestures, so uninterrupted watching is never buffered or synced to the backend.
2. `VideoLessonViewer` uses `double.tryParse` on `lastWatchedDuration`, which fails and returns `0.0` when the stored duration is a formatted time string (e.g., `"00:02:05"`).
3. Position updates are not force-synced when the app lifecycle changes to `paused` / `inactive` before app termination.

## What Changes
- Implement periodic buffer flushing in `CustomVideoPlayer` during continuous playback so watched time ranges and position are sent to `VideoAttemptNotifier` every 10 seconds.
- Maintain a 60-second minimum server sync throttle in `VideoAttemptNotifier` to comply with backend API rate limits.
- Hook into Flutter app lifecycle states to force sync pending video attempts when the app is backgrounded.
- Update `VideoLessonViewer` to parse `lastWatchedDuration` using `TimeFormatter.parseDuration(...)` to support both numeric seconds (`"125.4"`) and time-formatted strings (`"00:02:05"`).

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `video-lesson-viewer`: Add video playback position persistence and resume capability requirements across app lifecycle transitions and continuous playback.

## Impact
- `packages/courses/lib/widgets/lesson_detail/custom_video_player.dart`
- `packages/courses/lib/widgets/lesson_detail/video_lesson_viewer.dart`
- `packages/courses/lib/providers/video_attempt_provider.dart`
