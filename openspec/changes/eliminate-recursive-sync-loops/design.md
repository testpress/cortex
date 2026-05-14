## Context

The current curriculum synchronization logic triggers a full-course synchronization loop. This is extremely inefficient for large courses, as the app serializes dozens of network requests sequentially before showing any results to the user. This "greedy" behavior causes high server load (429 risks) and poor user experience.

## Goals / Non-Goals

**Goals:**
- Transition from "Course-wide sync" to "Level-scoped sync" (Lazy Discovery).
- Implement a cache-first approach (SWR) where local DB data is shown immediately.
- Decouple the Course List metadata from the curriculum content fetching.
- Reduce payload size and network latency by fetching only relevant branches.

**Non-Goals:**
- Implementing the "clever solution" for recursive hierarchical filtering (Deferred to next scope).
- Refactoring the entire database schema (using existing tables).

## Decisions

### 1. Discovery-based Sync Triggering
Instead of a "Master Sync" that crawls the whole tree, syncs are now triggered by navigation.
- **Rationale**: This ensures we only fetch data the user is actually interested in, preventing unnecessary server load.

### 2. Cache-First (SWR) Provider Pattern
Providers like `subChapters` will now yield the local database state **before** triggering a background refresh via the `.ignore()` pattern.
- **Rationale**: This eliminates the "blocking spinner" problem. If the data is cached, it appears instantly.

### 3. Paginated Content Streaming
Refactor `HttpDataSource.getCourseContents` to yield a `Stream<CourseCurriculumDto>` that emits each page as it arrives.
- **Rationale**: Allows the `CourseRepository` to persist data page-by-page, enabling the UI to populate incrementally rather than waiting for the entire loop to finish.

### 4. Background Sync Deduplication
Continue using the `_activeStructuralSyncs` map in `CourseRepository` to prevent multiple identical syncs if a user navigates rapidly between folders.

## Risks / Trade-offs

- **[Risk]**: Temporary loss of recursive filtering functionality at the root level.
- **[Mitigation]**: Intentionally making filtering a no-op for now to allow for a clean architectural redesign in the next scope.
- **[Risk]**: "Flash of old content" if local cache is very stale.
- **[Mitigation]**: The background refresh will update the UI as soon as new data is persisted to the database.
