## Context

See [proposal.md](proposal.md) for the motivation of this change.

1. `CourseDto.fromJson` assigns both `totalContents` and `totalLessons` from `'contents_count'`. `totalDuration` is also a deprecated field.
2. In `CoursesTable` (`packages/core/lib/data/db/tables/courses_table.dart`), both `totalDuration` and `totalLessons` exist as columns. Since the app has not been released yet, we can safely delete these columns from the database without a schema migration.
3. In `CourseRepository` (`packages/courses/lib/repositories/course_repository.dart`), `_lessonDtoToCompanion` method uses verbose conditional expressions `val != null ? Value(val) : const Value.absent()` for over 30 nullable fields.

## Goals / Non-Goals

**Goals:**
- Completely remove `totalDuration` and `totalLessons` from `CourseDto` and `CoursesTable`.
- Update UI references in `course_card.dart` and `info_page.dart` to use `totalContents`.
- Regenerate generated drift file `app_database.g.dart` to apply the database schema changes.
- Refactor `_lessonDtoToCompanion` to use `Value.absentIfNull` for all nullable fields to simplify mapping logic.

**Non-Goals:**
- Database schema migration scripts (since this is pre-release code).

## Decisions

### 1. Completely remove `totalDuration` and `totalLessons` columns and fields
We will:
- Delete `totalDuration` and `totalLessons` columns from `CoursesTable` in `courses_table.dart`.
- Delete `totalDuration` and `totalLessons` fields from `CourseDto` in `course_dto.dart`.
- Transition all UI files (`course_card.dart` and `info_page.dart`) and repository mapping helpers to use `totalContents`.
- Regenerate the database files using `dart run build_runner build --delete-conflicting-outputs` in the core package.

### 2. Refactor `_lessonDtoToCompanion` to use `Value.absentIfNull`
For all nullable fields mapped from `LessonDto` to `LessonsTableCompanion` in `packages/courses/lib/repositories/course_repository.dart`, we will replace `dto.field != null ? Value(dto.field) : const Value.absent()` with `Value.absentIfNull(dto.field)`.

## Risks / Trade-offs

- **Risk:** Build runner fails or other packages depend on the removed columns.
  - **Mitigation:** Run `flutter analyze` on the entire monorepo after code generation to resolve any remaining references to `totalLessons` or `totalDuration`.

