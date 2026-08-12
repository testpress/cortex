## 1. LessonDto (packages/core)
- [x] 1.1 Add `uuid` field (field, constructor, copyWith, merge, toJson)
- [x] 1.2 Add `uuid: json['uuid']` to `_parseBase` — inherited by all parsers
- [x] 1.3 Change `_parseVideoLesson` to set `contentUrl: null`
- [x] 1.4 Add `uuid` column to DB lessons table
- [x] 1.5 Run build_runner to regenerate app_database.g.dart

## 2. Lesson domain model (packages/courses)
- [x] 2.1 Add `uuid` field to `Lesson` and propagate through `toDto()`

## 3. Mapping layer
- [x] 3.1 Pass `uuid` in `lesson_detail_provider.dart`
- [x] 3.2 Pass `uuid` in `chapter_detail_provider.dart`
- [x] 3.3 Read/write `uuid` in `course_repository.dart`

## 4. UI consumers
- [x] 4.1 `video_lesson_viewer.dart` — `assetId: lesson.uuid`
- [x] 4.2 `live_stream_viewer.dart` — `assetId: lesson.uuid`
- [x] 4.3 `ai_tab.dart` — `lesson.uuid`
- [x] 4.4 `video_mcq_tab.dart` — `lesson.uuid`

## 5. Verify
- [x] 5.1 `flutter analyze` passes
- [x] 5.2 Video and live stream lessons load on device
- [x] 5.3 Tests pass
