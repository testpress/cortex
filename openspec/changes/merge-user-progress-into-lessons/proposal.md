# Proposal: Merge UserProgress into Lessons

## Why
The current architecture splits lesson data and progress tracking into two separate domains (`LessonsTable` and `UserProgressTable`). This introduces unnecessary complexity:
- **Redundant Files**: Maintaining duplicate DTOs, Repositories, and Tables.
- **Stitching Complexity**: UI and Providers must perform complex joins to associate progress with a lesson.
- **Sync Issues**: Risk of `LessonProgressStatus` (in `LessonsTable`) getting out of sync with `percentComplete` (in `UserProgressTable`).
- **API Mismatch**: The backend API provides a flat structure where progress is a property of the lesson object.

Merging these simplifies the logic, matches the API, and improves developer efficiency.

## What Changes
1.  **Schema Consolidation**: 
    - Add `percentComplete` (Int) and `lastAccessedAt` (DateTime) directly to `LessonsTable`.
    - Deprecate and remove `UserProgressTable`.
2.  **DTO Update**: Update `LessonDto` to include `percentComplete` and `lastAccessedAt`.
3.  **Repository Refactor**: Update `CourseRepository` (and `AppDatabase`) to handle full lesson state persistence in a single pass.
4.  **Provider Updates**: Refactor `recentActivityProvider` (on the Dashboard) to query `LessonsTable` directly, sorted by `lastAccessedAt`.

## Capabilities

### Modified Capabilities
- `packages/data-layer`: Update database schema and repository logic to support merged lesson progress.
- `lms-study-chapters-list`: Update lesson status rendering to use the new fields in `LessonDto`.

## Impact
- **Database**: Requires a migration to add columns to `lessons_table`.
- **Core Library**: Changes to `LessonDto`, `LessonsTable`, and `AppDatabase`.
- **Courses Library**: Changes to `CourseRepository`.
- **Dashboard**: Simplified logic for fetching recent lessons.
