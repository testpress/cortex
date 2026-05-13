## Context

The Info tab (Learning Resources) is being transitioned from a mock-data implementation to a live, production-ready feature. This involves updating the domain logic and UI within `packages/courses`.

## Goals / Non-Goals

**Goals:**
- Enable real API data fetching with tag-based filtering.
- Modify `PaginatedResponseDto` to handle Testpress root-level tag mapping.
- Remove redundant `tagIds` field from `CoursesTable` to simplify the schema.
- Support full `Chapters -> Lessons` hierarchy for Info resources.
- Fix logic leaks in multi-tab course filtering.

**Non-Goals:**
- Redesigning the core `CourseDetailScreen`.

## Decisions

### 1. Reactive Filtering in `CourseRepository`
We will add a dedicated `watchInfoCourses()` stream.
- **Logic**: It will listen to the main courses table and filter for the `info` tag in the stream's `map` function.
**Rationale**: Keeps the local database as the single source of truth while providing clean, tab-specific streams to the UI.

### 2. Fixing Study Tab "Leakage"
We will update `watchStudyCourses()` to always exclude courses with the `info` tag.
**Rationale**: Prevents Info resources from cluttering the Study tab when the Exam tab is disabled.

### 3. Curriculum UI Reuse
We will refactor `InfoCourseDetailScreen` to leverage the existing `CourseDetail` logic instead of the custom, flat video list.
**Rationale**: Reduces code duplication and ensures a consistent user experience across all course types.

### 4. Structural Tag Mapping in `PaginatedResponseDto`
We will update the core `PaginatedResponseDto` parser to handle the case where tags are provided at the root of the `results` object instead of within each item.
**Rationale**: This ensures that `tag_ids` are correctly mapped to their string display names (`info`, `exams`) before the items are persisted to the database. This is a clean, structural fix that enables the `CourseRepository` filters to work without "magic" tenant IDs or manual repository hacks.

### 5. Skeletonized Loading States
The Info landing page will use the `Skeletonizer` package to provide high-fidelity loading states during initial sync and pagination.
**Rationale**: Improves perceived performance and provides a more polished user experience compared to simple progress indicators.

## Risks / Trade-offs

- **[Trade-off]** In-memory filtering vs SQL filtering → **[Mitigation]** Since the number of courses is typically small (<200), in-memory filtering is highly efficient and easier to maintain.
