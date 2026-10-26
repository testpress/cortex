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
- **Rationale**: If `videoAttemptId` is present or can be resolved, route to `_source.updateUserVideo(videoAttemptId: ...)`. If it cannot be resolved (or during offline sync), smoothly fallback to `_source.updateVideoAttempt(...)`.

## Risks / Trade-offs

- **[Risk]**: Initial GET/POST attempt retrieval fails due to temporary network glitch.
  - **Mitigation**: Video playback continues uninterrupted; sync gracefully falls back to the previous endpoint, and next sync tick attempts to re-resolve the ID.
- **[Risk]**: First-time video viewing has one extra round-trip to initialize the attempt.
  - **Mitigation**: Once resolved, the attempt ID is cached in `CourseRepository._videoAttemptIds` for the duration of the video session.
