## Why

To support exam lessons being launched from course chapters, lessons need to store their API attempts URL and exam slug. Currently, these fields are missing from the `LessonsTable` and `LessonDto` models, preventing offline persistence and offline-first retrieval of exam launcher metadata.

## What Changes

- Update `LessonsTable` schema to add `attemptsUrl` and `slug` columns.
- Update `LessonDto` data model to support these new fields, and adjust JSON parsing in `_parseExamLesson`.
- Update `Lesson` domain model in the `courses` package to include `attemptsUrl` and `slug`, along with a helper `toDto()` method to facilitate cross-package mapping.
- Update `CourseRepository` and the detail providers (`chapter_detail_provider`, `lesson_detail_provider`) to map and persist these new fields.

## Capabilities

### New Capabilities
- `lesson-exam-metadata`: Ability to store, map, and retrieve attempts URLs and slugs for exam lessons from the database and DTO models.

### Modified Capabilities

## Impact

- `packages/core`: `LessonsTable` schema, `AppDatabase` regenerated, `LessonDto` model.
- `packages/courses`: `Lesson` domain model, `CourseRepository` database mapping, chapter and lesson detail providers.
- `packages/core/lib/data/sources/mock_data_source.dart`: Update mock fixtures with mock attempts URL.
