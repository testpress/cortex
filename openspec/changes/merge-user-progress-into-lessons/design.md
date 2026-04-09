# Design Document: Merge UserProgress into Lessons

## Context
The application currently maintains a `UserProgressTable` to track `percentComplete` and `lastAccessedAt` for individual lessons. This separation from the `LessonsTable` (which also tracks `progressStatus`) requires manual joining in the UI layer and introduces potential synchronization bugs. 

## Goals / Non-Goals

**Goals:**
- Eliminate the need for `UserProgressTable` and its related logic.
- Store all lesson-specific user progress state directly in the `LessonsTable`.
- Surface `lastAccessedAt` in the `LessonDto` to power the "Continue Learning" dashboard feature.
- Maintain support for granular `percentComplete` for future video resume functionality.

**Non-Goals:**
- Supporting multiple local users without a data wipe (current policy is wipe-on-logout).
- Refactoring the entire `CourseRepository` into smaller domain units (outside of the progress logic).

## Decisions

### 1. Unified Lessons Schema
We will add `percentComplete` and `lastAccessedAt` to `LessonsTable` in `packages/core`. 
- **Rationale**: Progress is inherently part of the lesson state in this single-user local context. This matches the backend's flat API response.

### 2. DTO and Database Mapping
`LessonDto` in `packages/core` will be updated with these fields. Serialization (`fromJson`/`toJson`) and database mapping (`_rowToLessonDto` / `_lessonDtoToCompanion`) in `CourseRepository` will also be updated to handle this change in a single database pass.

### 3. Progressive Migration
The `AppDatabase` `schemaVersion` will be incremented, and an `onUpgrade` step will add the two new columns to `lessons_table` using `m.addColumn`. The `UserProgressTable` will be removed once the migration is confirmed.

### 4. Recent Activity Query
The `recentActivityProvider` in `packages/courses` will be refactored to query `LessonsTable` filtered by `progressStatus != notStarted` and ordered by `lastAccessedAt DESC`.

## Risks / Trade-offs

### Write Overhead
- **Risk**: Updating a lesson row when progress increments is technically slower than updating a lightweight `UserProgress` row.
- **Trade-off**: For the project's scale (flat database, single user), the consistency and code simplicity gained far outweigh the milliseconds of overhead.
