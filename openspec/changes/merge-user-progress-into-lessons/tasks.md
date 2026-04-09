## 1. Schema & Models

- [x] 1.1 Update `LessonsTable` in `packages/core/lib/data/db/tables/lessons_table.dart` to include `percentComplete` and `lastAccessedAt`.
- [x] 1.2 Increment `schemaVersion` in `packages/core/lib/data/db/app_database.dart` and add migration step for new columns.
- [x] 1.3 Add `percentComplete` and `lastAccessedAt` to `LessonDto` in `packages/core/lib/data/models/lesson_dto.dart`.
- [x] 1.4 Update JSON mapping logic in `LessonDto` (`fromJson`/`toJson`).

## 2. Repository & Database Implementation

- [x] 2.1 Update mapping helpers `_rowToLessonDto` and `_lessonDtoToCompanion` in `packages/courses/lib/repositories/course_repository.dart`.
- [x] 2.2 Refactor `updateLessonProgress` to accept optional percentage and update `lastAccessedAt` timestamp.
- [x] 2.3 Refactor `recentActivityProvider` to use query the consolidated `LessonsTable` sorted by `lastAccessedAt`.

## 3. Cleanup

- [x] 3.1 Remove `UserProgressTable` from `AppDatabase` definition.
- [x] 3.2 Delete `user_progress_table.dart` and associated files.
- [x] 3.3 Verify all tests and UI components use the new merged lesson state.
