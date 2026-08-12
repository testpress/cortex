## 1. Database & Model Schema

- [x] 1.1 Add `conferenceId`, `password`, and `accessToken` columns to `LessonsTable`
- [x] 1.2 Bump Drift `schemaVersion` to `2` and add migration upgrade path in `app_database.dart`
- [x] 1.3 Run `build_runner` to regenerate Drift database code
- [x] 1.4 Add `conferenceId`, `password`, `accessToken`, and `isZoom` properties/getters to `Lesson` domain model and map in `toDto()`

## 2. API Parsing & Repository Mappings

- [x] 2.1 Map conference JSON properties (`conference_id`, `password`, `access_token`, `state`, `join_url`) in `_parseVideoConferenceLesson`
- [x] 2.2 Map database columns in `rowToLessonDto` and DTO insert/update statements in `course_repository.dart`
- [x] 2.3 Propagate Zoom properties from `LessonDto` to `Lesson` constructor in `lesson_detail_provider.dart` and `chapter_detail_provider.dart`

## 3. Switch Matching & Routing

- [x] 3.1 Match `LessonType.videoConference` case in routing lists (`chapters_list_page.dart`, `study_content_list.dart`)
- [x] 3.2 Add switch cases for theme coloring and icons in list items (`lesson_list_item.dart`, `chapter_content_item.dart`)
- [x] 3.3 Route `LessonType.videoConference` to `VideoConferenceViewer` in `lesson_detail_orchestrator.dart`
- [x] 3.4 Add `videoConference` cases to bookmark items (`bookmark_item.dart`) and the central router (`lesson_router.dart`)

## 4. Lobby UI

- [x] 4.1 Implement `VideoConferenceViewer` containing duration and start datetime information card

## 5. Verification

- [x] 5.1 Run `flutter analyze` and confirm no compile or lint issues exist
