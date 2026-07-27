## Context

When the "Auto-Play Next Lesson" setting is enabled, completing a video lesson automatically triggers navigation to the next lesson. However, because the app saves the playback progress, navigating back to a completed video lesson causes the player to initialize and seek to the end of the video. Once the seek completes, the player's position changes to the end, which is immediately interpreted as a new completion event. Since the orchestrator's state (including completion flags) is re-initialized on navigation, it immediately fires the `onNext` callback, throwing the user forward again in an inescapable navigation loop.

## Goals / Non-Goals

**Goals:**
- Prevent automatic navigation to the next lesson when navigating back to or reloading a completed video lesson.
- Ensure that completed video lessons start playback from the beginning (`0.0`) when opened, so the user can actually replay them.
- Keep the `onComplete` trigger functional if the user seeks backwards or chooses to replay the video from the beginning.

**Non-Goals:**
- Changing the global autoplay logic for non-video content types.
- Modifying how playback tracking (attempts) are synchronized to the backend.

## Decisions

### 1. Reset initial playback position for completed video lessons
In `VideoLessonViewer` and `VideoLessonDetailScreen`, check if the lesson has been completed (`lesson.progressStatus == LessonProgressStatus.completed`). If it has, set `initialPosition` to `0.0`.

- *Rationale:* If the user has finished a video, returning to it should let them watch it again from the beginning, rather than staring at a black ended screen. This naturally avoids seeking to the end on initialization.

### 2. Introduce an initial completion guard in `CustomVideoPlayer`
Add a `_shouldIgnoreInitialCompletion` boolean flag inside `CustomVideoPlayerState`. During the first build/seek (where `_hasSeekedToInitial` is processed), if the target seek position is within a near-end threshold (defined dynamically as `duration > 2.0 ? 2.0 : duration * 0.5`) of the video duration, set this flag to `true`. In the player's listener, check this flag before firing `widget.onComplete`.

- *Rationale:* This serves as a safety guard. If the initial position is at/near the end of the video, we do not want to trigger `onComplete` immediately on load. The dynamic threshold ensures short clips (≤ 5s) are also guarded without activating too early on their initial playback.

### 3. Reset the guard on user interaction, backward seek, or forward playback progress
If `_shouldIgnoreInitialCompletion` is `true`, reset it to `false` when:
- The current position has advanced forward from the initial seek position by a small margin (e.g., `currentPos > _initialSeekPos + 0.1`).
- The user seeks backwards from the initial seek position (e.g., `currentPos < _initialSeekPos - 0.5`).

- *Rationale:* This ensures that if a user resumes a video near the end and actually starts playing it, the video can still complete naturally and trigger auto-play. It also allows completion if they seek backwards to watch from an earlier point. It only suppresses completion if the video loads and is immediately evaluated at the end without any actual forward progress or user interaction.

## Risks / Trade-offs

- **Risk**: Video playback state might not update the duration immediately when `_hasSeekedToInitial` is evaluated.
  - *Mitigation*: We only perform the initial seek and set the ignore flag when `controller.value.duration != Duration.zero` is true.
