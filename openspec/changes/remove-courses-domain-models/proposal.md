## Why

The `courses` package maintains `Lesson` and `Chapter` domain models in
`packages/courses/lib/models/course_content.dart` that are near-identical
mirrors of `LessonDto` and `ChapterDto` already defined in `packages/core`.
This forces every detail provider (`lessonDetailProvider`,
`liveClassDetailProvider`, `chapterDetailProvider`) to manually copy ~40
fields one-by-one from DTO to domain model, with no meaningful transformation.
The extra layer adds maintenance burden, drift risk (the two `isComplete`
implementations are already subtly out of sync), and obscures the actual data
flow.

## What Changes

- **REMOVE** `class Lesson` from `packages/courses/lib/models/course_content.dart`
- **REMOVE** `class Chapter` from `packages/courses/lib/models/course_content.dart`
- **REMOVE** `class Course` wrapper from `packages/courses/lib/models/course.dart`
  (which exists only to hold `List<Chapter>`)
- **MOVE** computed getters `isZoom`, `isTeams`, `isFermion`, and the corrected
  `isComplete` (liveStream/Fermion branch) from `Lesson` → `LessonDto` in
  `packages/core/lib/data/models/lesson_dto.dart`
- **UPDATE** the three detail providers to stream `LessonDto?` / `ChapterDto?`
  directly instead of mapping to domain models:
  - `lesson_detail_provider.dart` — `Stream<LessonDto?>`
  - `live_class_detail_provider.dart` — `Stream<LessonDto?>`
  - `chapter_detail_provider.dart` — `Stream<ChapterDto?>` (with
    `courseTitle` passed as a separate field or added to `ChapterDto`)
- **UPDATE** all UI consumers (screens, widgets) to accept `LessonDto` / `ChapterDto`
  instead of `Lesson` / `Chapter`:
  - `lesson_detail_orchestrator.dart`
  - `chapter_detail_page.dart`
  - `widgets/lesson_detail/` — `VideoLessonViewer`, `LiveStreamViewer`,
    `VideoConferenceViewer`, `FermionLobbyView`, `NotesTab`, `AiTab`,
    `DoubtTab`, `TranscriptsTab`, `ChapterContentItem`
  - `downloads_provider.dart` — `startPdfLessonDownload(LessonDto)`
- **DELETE** `packages/courses/lib/models/course_content.dart` once empty
- **DELETE** `packages/courses/lib/models/course.dart` once empty

## Capabilities

### New Capabilities

_None. This is a pure internal refactor — no new user-facing behavior is introduced._

### Modified Capabilities

_No spec-level requirements change. The lesson detail, chapter detail, and live
class detail screens behave identically from the user's perspective. Internal
data flow simplification only._

> **Note:** `skip_specs: true` applies — zero spec deltas are warranted.

## Impact

| Area | Files affected |
|---|---|
| `core` SDK | `lesson_dto.dart` — add `isZoom`, `isTeams`, `isFermion` getters; reconcile `isComplete` for liveStream/Fermion |
| `courses` providers | `lesson_detail_provider.dart`, `live_class_detail_provider.dart`, `chapter_detail_provider.dart` |
| `courses` screens | `lesson_detail_orchestrator.dart`, `chapter_detail_page.dart` |
| `courses` widgets | ~8 files under `widgets/lesson_detail/`, `widgets/chapter_content_item.dart` |
| `courses` models | `course_content.dart`, `course.dart` — deleted |
| `courses` barrel | `courses.dart` — remove re-exports of deleted models |
| No external packages affected | `exams` and `app` shell consume `LessonDto` from `core` already |
