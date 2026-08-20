## Why

1. `CourseDto.fromJson` contains a dead assignment where both `totalContents` and `totalLessons` are parsed from `json['contents_count']`. Because `totalLessons` is deprecated and redundant with `totalContents`, it should be completely removed, alongside the old deprecated `totalDuration` field.
2. The app is not released yet, so we can clean up the database columns `totalDuration` and `totalLessons` in `CoursesTable` directly without needing schema migrations.
3. `_lessonDtoToCompanion` in `CourseRepository` contains over 30 lines of verbose conditional checks for nullable fields (`dto.field != null ? Value(dto.field) : const Value.absent()`). These can be simplified using Drift's native `Value.absentIfNull` constructor to improve readability.

## What Changes

- Remove `totalDuration` and `totalLessons` fields completely from `CourseDto`.
- Remove `totalDuration` and `totalLessons` columns from `CoursesTable` in `courses_table.dart`, and regenerate drift schema.
- Update repository mapping functions (`rowToCourseDto` and `_courseDtoToCompanion`) to omit removed fields.
- Refactor the 30+ field mappings in `_lessonDtoToCompanion` to use `Value.absentIfNull`.

## Capabilities

### New Capabilities
<!-- None — this is a pure refactor change with no requirement/behavior changes -->

### Modified Capabilities
<!-- None — this is a pure refactor change with no requirement/behavior changes -->

> **Note:** This is a pure refactor / code cleanup. No spec-level behaviour changes.
> `skip_specs: true` has been set in `.openspec.yaml`.

## Impact

- **Files:** 
  - `packages/core/lib/data/models/course_dto.dart`
  - `packages/core/lib/data/db/tables/courses_table.dart`
  - `packages/courses/lib/repositories/course_repository.dart`
- **Scope:** Cleanups of JSON deserialization, database schema, and DB companion mapping.
- **Risk:** Medium (requires regenerating code and checking all usages of these fields/columns).
