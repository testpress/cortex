## 1. Database and Core Model Changes

- [x] 1.1 Add `attemptsUrl` and `slug` columns to the `LessonsTable` in `packages/core/lib/data/db/tables/lessons_table.dart`
- [x] 1.2 Regenerate drift database code (`app_database.g.dart`)
- [x] 1.3 Add `attemptsUrl` and `slug` fields to `LessonDto` class and update its constructors, `copyWith`, `merge`, and `fromJson` mapping in `packages/core/lib/data/models/lesson_dto.dart`

## 2. Courses Package Domain and Persistence Changes

- [x] 2.1 Add `attemptsUrl`, `slug`, `chapterId`, and `orderIndex` fields to the `Lesson` domain model and add a `toDto()` conversion helper method in `packages/courses/lib/models/course_content.dart`
- [x] 2.2 Update chapter detail provider mapping in `packages/courses/lib/providers/chapter_detail_provider.dart`
- [x] 2.3 Update lesson detail provider mapping in `packages/courses/lib/providers/lesson_detail_provider.dart`
- [x] 2.4 Update `CourseRepository` database mapping methods (`rowToLessonDto`, `_lessonDtoToCompanion`) in `packages/courses/lib/repositories/course_repository.dart`
- [x] 2.5 Update mock exam lesson fixture with mock `attemptsUrl` in `packages/core/lib/data/sources/mock_data_source.dart`
