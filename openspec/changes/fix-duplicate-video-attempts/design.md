## Context

In the Cortex app, video progress updates were calling `POST /api/v2.5/chapter_content_attempts/videos/update/` without specifying an active attempt ID. On institutes where completion requirements are low (e.g. 1% watch percentage), reaching that threshold triggers automatic creation of duplicate attempts on the backend. In contrast, the native Android app retrieves/creates the attempt session once and subsequently updates that specific attempt via `PUT /api/v2.4/user_videos/{video_attempt_id}/`.

## Goals / Non-Goals

**Goals:**
- Identify the active `user_video` attempt ID before or during video playback.
- Support both nested `attempt['video']['id']` and direct `attempt['object_id']` extraction (conforming to backend `ContentAttempt` and Android SDK).
- Use `PUT /api/v2.4/user_videos/{video_attempt_id}/` during continuous and event-based playback syncs.
- Retain the existing endpoint as a fallback for offline playback sync or when attempt ID resolution fails.
- Cache the attempt ID in `CourseRepository` for the duration of the lesson playback to minimize redundant network roundtrips.

**Non-Goals:**
- Refactoring the entire offline download or exam attempt pipeline.
- Altering the debounce timers or 60-second periodic sync throttles in `VideoAttemptNotifier`.

## Decisions

### Decision 1: Query GET attempts first, fallback to POST on empty
- **Rationale**: Calling `GET /api/v2.3/contents/{id}/attempts/` is completely idempotent. If an attempt already exists, its `video['id']` or `object_id` is extracted without any side-effects. Only if no attempt exists does it perform `POST /api/v2.3/contents/{id}/attempts/` to initialize a new session.
- **Alternatives considered**: Directly calling `POST` on startup. While `ChapterContentAttemptFactory` generally reuses open attempts, checking `GET` first guarantees no duplicate creation across edge-case backend configurations.

### Decision 2: Fallback to `object_id` during attempt parsing
- **Rationale**: In the backend's `ContentAttempt` model, `object_id` points directly to the `UserVideo` instance (which Native Android uses). Relying solely on `video['id']` could fail if the serializer returns a shallow dictionary.
- **Alternatives considered**: Only parsing `video['id']`.

### Decision 3: Route through `updateUserVideo` with fallback in `CourseRepository`
- **Rationale**: If `videoAttemptId` is present or can be resolved, route to `_source.updateUserVideo(videoAttemptId: ...)`. If it cannot be resolved because the attempt is empty or unparseable, smoothly fallback to `_source.updateVideoAttempt(...)`.
- **Network Failure vs Fallback**: Transient network errors from `getVideoAttemptId` rethrow (and report to Sentry) rather than falling back to the legacy endpoint, preventing duplicate attempts from being created during temporary connection drops. Unsent delta ranges are retained by `VideoAttemptNotifier` for retry.

### Decision 4: In-flight deduplication for concurrent attempt resolutions
- **Rationale**: Concurrent sync triggers (e.g. initial playback + immediate seek/pause) share the same in-flight `Future<int?>` via `_activeVideoAttemptSyncs` to prevent racing GET/POST calls from creating duplicates.

### Decision 5: Persist local DB position before network attempt resolution
- **Rationale**: The user's last watched position is saved to the local Drift database first before initiating network calls, ensuring resume progress is never lost even if network requests fail.

## Risks / Trade-offs

- **[Risk]**: Initial GET/POST attempt retrieval fails due to temporary network glitch.
  - **Mitigation**: Local watch duration is already saved to Drift; transient error bubbles to `VideoAttemptNotifier` which keeps watched ranges queued for the next retry tick without creating duplicate attempts.
- **[Risk]**: First-time video viewing has one extra round-trip to initialize the attempt.
  - **Mitigation**: Once resolved, the attempt ID is cached in `CourseRepository._videoAttemptIds` for the duration of the video session. In-flight calls are deduplicated via `_activeVideoAttemptSyncs`.
