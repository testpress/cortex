## Context

The `CourseCard` currently displays `totalDuration` (e.g., "180 hrs") as part of its metadata. The Testpress API version 3 provides a more accurate metric, `total_contents`, which counts all learning items including lessons, tests, and assessments. This design outlines the migration to show this new metric.

## Goals / Non-Goals

**Goals:**
- Update the domain model and remote parser to include `totalContents`.
- Persist `totalContents` in the local Drift database.
- Update the UI to display "X contents" instead of "Y hrs".
- Ensure backward compatibility and smooth database migration.

**Non-Goals:**
- Removing `totalDuration` entirely from the codebase in this PR (marked as deprecated).
- Changing the layout of the `CourseCard` beyond the metadata text.

## Decisions

### 1. Data Model Update
Add `totalContents` as an `int` to `CourseDto`.
- Mapping: `total_contents` (API) -> `totalContents` (DTO).
- Deprecation: Mark `totalDuration` as `@Deprecated` to signal its replacement.

### 2. Database Schema (v8)
Add an `IntColumn` for `totalContents` in `CoursesTable`.
- Rationale: Storing it as an integer allows for future sorting/filtering by content volume.
- Migration: Use `m.addColumn(coursesTable, coursesTable.totalContents)` in `AppDatabase.onUpgrade`.

### 3. Localization
Add `labelContentsPlural` to `app_en.arb` (and other languages) to handle the "contents" suffix.
- Value: `"contents"` (English).

### 4. Mock Data
Update `MockDataSource` to provide `totalContents` values. For existing mock data, we will use a base value (e.g., 100) or calculate it if feasible.

## Risks / Trade-offs

- **[Risk]** Missing `total_contents` in some API responses.
  - **Mitigation**: Use a default value of 0 in `RemoteCourseDto.fromJson` and the database column.
- **[Risk]** Database migration overhead.
  - **Mitigation**: `addColumn` is an O(1) operation in SQLite and won't block the UI significantly.
