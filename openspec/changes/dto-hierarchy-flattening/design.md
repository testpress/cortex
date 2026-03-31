## Context

The current `CourseDto` and `ChapterDto` models were originally scaffolded with nested collections (`List<ChapterDto>` and `List<LessonDto>`). However, the backend API for this project is strictly flat (using separate endpoints for chapters and lessons). Keeping these nested fields in the DTO layer creates architectural confusion and deviates from the "Single Source of Truth" in the local Drift database, which is also flat.

## Goals / Non-Goals

**Goals:**
- Remove all nested collection fields from `CourseDto` and `ChapterDto`.
- Simplify `fromJson` and `toJson` methods to focus on flat property mapping.
- Update `MockDataSource` to provide flat, non-nested objects for courses and chapters.

**Non-Goals:**
- Modifying the underlying Drift database schema (it is already flat).
- Changing the `CourseRepository` stream logic (it already uses ID-based filtering for chapters and lessons).

## Decisions

### Decision 1: Complete Removal of Nested Fields
We will completely remove the `chapters` and `lessons` fields from the DTO constructors and properties rather than making them nullable. 
- **Rationale**: If we made them nullable, developers might still be tempted to use them, leading to null-pointer bugs or empty UI states. Total removal enforces the correct use of the `DataSource` methods (`getChapters`, `getLessons`).
- **Alternative**: Keeping them as optional. Rejected because it maintains the "False Expectation" trap.

### Decision 2: Tolerant JSON Parsing
The `fromJson` methods will be updated to purely map properties from the JSON map without iterating over nested results.
- **Rationale**: If the backend happens to send nested data (e.g., during a transitional phase), the DTO will simply ignore those keys, preventing parsing errors while maintaining its own internal consistency.

## Risks / Trade-offs

- **Risk: Breaking UI (Compile-time)**: Any UI code that was previously accessing `course.chapters` will fail to compile.
- **Mitigation**: This is desirable as it forces the UI to use the `Repository` streams (`watchChapters`), which is the correct pattern.
