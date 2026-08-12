## Why

`contentUrl` is overloaded. For `video` and `liveStream` (TPStreams) lessons the parser stores
`json['uuid']` into `contentUrl` because that is what the TPStreams player needs — but `contentUrl`
should be a URL, not an identifier. The conflict surfaces with `videoConference`: during a meeting
`contentUrl` holds the Zoom join URL, and after the meeting the root-level content UUID is needed for
the TPStreams player but is currently dropped for conference lessons.

## What Changes

- **ADD**: A dedicated nullable `uuid` field on `LessonDto` that always captures the root-level
  `json['uuid']` from the content API, regardless of lesson type.
- **ADD**: Persistence of the `uuid` column in the local lessons DB table (migration bump).
- **ADD**: Propagation of `uuid` through the `Lesson` domain model, `toDto()`, mapping providers, and
  repository read/write.
- **MODIFY**: `_parseVideoLesson` sets `contentUrl: null` — the TPStreams asset id now comes from `uuid`.
- **MODIFY**: TPStreams video and live-stream viewers (and the AI/MCQ tabs that share the TPStreams
  asset id) read `lesson.uuid` instead of `lesson.contentUrl`.
- **KEEP**: `contentUrl` as a real URL everywhere it is one (embed, PDF, notes, attachment, Fermion
  stream/join URLs, video conference join URL).

## Capabilities

### New Capabilities

- None.

### Modified Capabilities

- `video-lesson-viewer`: Video lessons now carry a dedicated root `uuid`; the TPStreams player sources
  its asset id from `uuid` rather than `contentUrl`.
- `live-stream/fermion-provider`: TpStreams live sessions source the TPStreams asset id from the root
  `uuid`; `contentUrl` remains the Fermion embed URL.

## Impact

- **Core package**: `LessonDto` (field, constructor, `copyWith`, `merge`, `toJson`, `_parseBase`,
  `_parseVideoLesson`), `LessonsTable` schema + migration version, regenerated `app_database.g.dart`.
- **Courses package**: `Lesson` domain model + `toDto()`, `lesson_detail_provider.dart`,
  `chapter_detail_provider.dart`, `course_repository.dart`, `video_lesson_viewer.dart`,
  `live_stream_viewer.dart`, `ai_tab.dart`, `video_mcq_tab.dart`.
- **No breaking API changes**: `uuid` is additive and nullable; existing `contentUrl` consumers that
  use real URLs are untouched.
