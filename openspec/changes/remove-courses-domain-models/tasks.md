## 1. Extend `LessonDto` in `core`

- [x] 1.1 Add `isZoom` getter to `LessonDto` — `liveStreamProvider?.toLowerCase().contains('zoom') ?? false`
- [x] 1.2 Add `isTeams` getter to `LessonDto` — `liveStreamProvider?.toLowerCase().contains('teams') ?? false`
- [x] 1.3 Add `isFermion` getter to `LessonDto` — `liveStreamProvider?.toLowerCase().contains('fermion') ?? false`
- [x] 1.4 Update `LessonDto.isComplete` for the `liveStream` case to use the Fermion branch: if `isFermion`, check `contentUrl != null && contentUrl!.isNotEmpty`; otherwise check `uuid != null && uuid!.isNotEmpty`
- [x] 1.5 Run `dart analyze packages/core` — zero errors

## 2. Update `lessonDetailProvider`

- [x] 2.1 Change return type from `Stream<Lesson?>` to `Stream<LessonDto?>`
- [x] 2.2 Remove the 40-field `Lesson(...)` constructor block inside `dbStream`; replace with `repository.rowToLessonDto(row)` directly
- [x] 2.3 Remove the `import '../models/course_content.dart'` line
- [x] 2.4 Run `dart analyze packages/courses` — no new errors from this file

## 3. Update `liveClassDetailProvider`

- [x] 3.1 Change return type from `Stream<Lesson?>` to `Stream<LessonDto?>`
- [x] 3.2 Remove the 40-field `Lesson(...)` constructor block inside `dbStream`; stream `rowToLessonDto` directly
- [x] 3.3 Remove the `import '../models/course_content.dart'` line
- [x] 3.4 Run `dart analyze packages/courses` — no new errors from this file

## 4. Update `chapterDetailProvider`

- [x] 4.1 Change return type of `chapterDetail` from `Stream<Chapter?>` to `Stream<(ChapterDto, String?)?>` (record type with chapter + courseTitle)
- [x] 4.2 Update `_watchChapter` helper to return `Stream<(ChapterDto, String?)?>` — keep the `watchCourses().first` lookup for `courseTitle` but return a record instead of constructing `Chapter`
- [x] 4.3 Remove the inner `Lesson(...)` mapping inside `_watchChapter`; use `repo.rowToLessonDto(l)` directly to populate `ChapterDto.lessons`
- [x] 4.4 Remove the `import '../models/course_content.dart'` line
- [x] 4.5 Run `dart analyze packages/courses` — no new errors from this file

## 5. Update screens

- [x] 5.1 `lesson_detail_orchestrator.dart` — change `final Lesson lesson` to `final LessonDto lesson` on `LessonDetailOrchestrator` and `_CachedPdfLessonViewer`; update all `customBuilder` signatures
- [x] 5.2 `chapter_detail_page.dart` — change `ValueChanged<Lesson>? onLessonClick` to `ValueChanged<LessonDto>?`; update the `chapterAsync` watch to unpack the new `(ChapterDto, String?)` record; pass `courseTitle` from the record to the header widget
- [x] 5.3 Remove `import '../models/course_content.dart'` from both screen files

## 6. Update `widgets/lesson_detail/` widgets

- [x] 6.1 `video_lesson_viewer.dart` — `final Lesson lesson` → `final LessonDto lesson`; remove `course_content.dart` import
- [x] 6.2 `live_stream_viewer.dart` — same
- [x] 6.3 `video_conference_viewer.dart` — same (both the outer widget and the inner `_ConferenceWidget` that holds `final Lesson lesson`)
- [x] 6.4 `fermion_lobby_view.dart` — same
- [x] 6.5 `notes_tab.dart` — same
- [x] 6.6 `ai_tab.dart` — same
- [x] 6.7 `doubt_tab.dart` — same
- [x] 6.8 `transcripts_tab.dart` — same
- [x] 6.9 `chapter_content_item.dart` — `final Lesson lesson` → `final LessonDto lesson`; remove `course_content.dart` import

## 7. Update `downloads_provider`

- [x] 7.1 Change `startPdfLessonDownload(Lesson lesson)` signature to `startPdfLessonDownload(LessonDto lesson)`
- [x] 7.2 Remove `import '../models/course_content.dart'` — all needed types come from `package:core/data/data.dart`

## 8. Delete domain model files

- [x] 8.1 Delete `packages/courses/lib/models/course_content.dart`
- [x] 8.2 Delete `packages/courses/lib/models/course.dart`
- [x] 8.3 Remove the re-exports of `Lesson`, `Chapter`, `Course`, and `VideoLessonTab` from `packages/courses/lib/courses.dart` (the barrel file); keep any other re-exports intact

## 9. Final verification

- [x] 9.1 Run `dart analyze packages/core` — zero errors, zero warnings
- [x] 9.2 Run `dart analyze packages/courses` — zero errors, zero warnings
- [x] 9.3 Run `dart analyze packages/exams` — zero errors (confirm no accidental breakage)
- [x] 9.4 Run `dart analyze app` — zero errors
- [x] 9.5 Manual smoke test: open a video lesson, PDF lesson, live class (Fermion + TpStreams), and video conference — all render correctly
- [x] 9.6 Verify PDF download button works end-to-end (watermarked and non-watermarked)
- [x] 9.7 Confirm the `isComplete` Fermion fix: a Fermion live class with a `contentUrl` should no longer show a loading skeleton
