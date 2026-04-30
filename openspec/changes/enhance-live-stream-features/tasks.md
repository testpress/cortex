## 1. Core Model & Parser Updates (packages/core)

- [x] 1.1 Update `LessonDto` fields to include `streamStatus` and `showRecordedVideo`.
- [x] 1.2 Refactor `LessonDto._identifyLessonType` to include `content_type` string matching for "Live Stream".
- [x] 1.3 Update `LessonDto._parseLiveStreamLesson` to correctly extract `stream_url` and other nested fields from the `live_stream` object.
- [x] 1.4 Enhance `LessonDto._parseBase` to extract `isRunning` and `isUpcoming` flags from `live_stream['status']`.

## 2. Domain Model & Repository (packages/courses)

- [x] 2.1 Update the `Lesson` domain model in `packages/courses/lib/models/course_content.dart` with new live-stream fields.
- [x] 2.2 Update mapping logic in `CourseRepository` and `lessonDetail` provider to handle the transfer of new fields from DTO to Domain.
- [x] 2.3 Update `Lesson.isComplete` logic to ensure required metadata is present for live streams.

## 3. UI Orchestration & Live Viewer (packages/courses)

- [x] 3.1 Enhance `LessonDetailOrchestrator` to route live lessons through a dedicated live viewer.
- [x] 3.2 Create a `LiveStreamViewer` that prioritizes stable video playback.
- [x] 3.3 Ensure live lessons do not render embedded chat webviews in the lesson detail view.
- [x] 3.4 Ensure proper full-screen behavior and footer interaction for live content.
