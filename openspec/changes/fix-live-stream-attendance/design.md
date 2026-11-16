## Context

In Cortex Flutter, lesson playback and attempt tracking are integrated within `CustomVideoPlayer`. When initialized with a valid `lessonId`, `CustomVideoPlayer` extracts `_contentId` and listens to `videoAttemptNotifierProvider`. During playback intervals, pause, seek, and lifecycle teardown events, `_syncVideoAttempt()` syncs watched intervals and initializes an attempt via `CourseRepository.updateVideoAttempt()` / `HttpDataSource.getVideoAttemptId()`, executing `POST /api/v2.3/contents/<id>/attempts/`.

While `VideoLessonViewer` passes `lessonId: widget.lesson.id`, `LiveStreamViewer` historically mounted `CustomVideoPlayer` with only `assetId: lesson.uuid`. This left live stream playback unmonitored by the attempt engine, omitting the attendance registration request.

## Goals / Non-Goals

**Goals:**
- Provide `lessonId` and `thumbnailUrl` to `CustomVideoPlayer` in `LiveStreamViewer`.
- Activate attempt tracking and attendance logging for TPStreams live streams on mobile without disturbing video rendering or chat integration.
- Omit `onComplete` to avoid premature completion triggers during stream stalls or live-head playback.
- Verify through unit/widget tests that `LiveStreamViewer` passes `lessonId` without `onComplete` to `CustomVideoPlayer`.

**Non-Goals:**
- Modifying offline player behavior (which intentionally omits `lessonId` for downloaded content).
- Changing backend attempt APIs or data models.
- Altering Fermion or VideoConference (Zoom / MS Teams) routing.

## Decisions

### Decision 1: Pass `lessonId: lesson.id` in `LiveStreamViewer`
- **Choice**: Forward `lesson.id` directly to `CustomVideoPlayer.lessonId`.
- **Rationale**: `CustomVideoPlayer` already encapsulates the periodic flush timer, debounced sync, keep-alive notifier link, and `getVideoAttemptId` fallback. Reusing the existing player contract aligns live stream playback with standard video lesson attempt tracking.

### Decision 2: Maintain default `initialPosition: 0.0`
- **Choice**: Do not parse or pass `lastWatchedDuration` for live streams.
- **Rationale**: Live streams are live events playing in real-time, unlike on-demand video where resuming at previous positions is desirable. Defaulting to 0.0 ensures playback attaches to the live head.

### Decision 3: Omit `onComplete` callback
- **Choice**: Do not pass `onComplete` to `CustomVideoPlayer` for live streams.
- **Rationale**: In ExoPlayer, `position >= duration` can fire when catching up to the live edge or during transient network interruptions. Live streams must only complete when the backend flags `isStreamCompleted`. Attendance tracking is driven entirely by `lessonId` and does not rely on `onComplete`.

## Risks / Trade-offs

- **[Risk]**: Live stream attempt sync may record progress intervals into `user_videos` on the backend.
  - **Mitigation**: `CourseRepository.updateVideoAttempt` and `HttpDataSource.updateUserVideo` accept standard position and interval payloads safely, matching regular video playback.
