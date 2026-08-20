## 1. DTO and Database Column Removal

- [x] 1.1 Delete `totalDuration` and `totalLessons` fields from `CourseDto` (`packages/core/lib/data/models/course_dto.dart`)
- [x] 1.2 Delete `totalDuration` and `totalLessons` columns from `CoursesTable` (`packages/core/lib/data/db/tables/courses_table.dart`)
- [x] 1.3 Update repository mapping helpers (`rowToCourseDto` and `_courseDtoToCompanion` in `course_repository.dart`) to completely omit these removed columns and DTO fields
- [x] 1.4 Run drift code generation (`dart run build_runner build --delete-conflicting-outputs` inside `packages/core`) to regenerate `app_database.g.dart`
- [x] 1.5 Fix `totalLessons` usages and compiler errors in `packages/exams`
- [x] 1.6 Fix `totalDuration` usages and dynamic list return type compiler error in `packages/profile`

## 2. Refactor Companion Mappings

- [x] 2.1 Refactor the 30+ nullable mapping fields in `_lessonDtoToCompanion` inside `packages/courses/lib/repositories/course_repository.dart` to use `Value.absentIfNull`

## 3. Verification

- [x] 3.1 Run static analysis across `packages/courses` and `packages/core` to ensure compilation is clean and all deprecated field usages are resolved
- [x] 3.2 Run test suite in `packages/courses` to verify no regressions are introduced

