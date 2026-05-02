## Why

Live stream content is currently not parsed correctly from the API, leading to broken playback (incorrect stream URL) and missing status indicators (isRunning/isUpcoming). The lesson experience also needs a stable, simplified live layout that prioritizes video playback and avoids unstable embedded-chat behavior.

## What Changes

- **Parser Fix**: Update `LessonDto.fromJson` to correctly identify "Live Stream" content and extract nested data (`stream_url`, `status`, `duration`) from the `live_stream` object.
- **Model Refactoring**: Enhance `LessonDto` and `Lesson` domain models to include live stream specific fields such as `streamStatus` and `showRecordedVideo`.
- **UI Enhancement**: Update the lesson detail orchestration and live viewer for a stable live playback experience (video-first layout with non-interactive filler area below).
- **Database Schema**: Potentially update `LessonsTable` to persist new live-stream specific fields.

## Capabilities

### Modified Capabilities
- `lesson-content-orchestration`: Adding support for live-stream specific metadata and simplified live-view orchestration.
- `unified-lesson-shell`: Adapting the shell behavior for stable live playback presentation.

## Impact

- `packages/core`: `LessonDto` parsing, domain model definitions, and database schema updates.
- `packages/courses`: `Lesson` model mapping, `LessonDetailOrchestrator`, and live stream viewing components.
