# Design: Optimize Course Sorting and Synchronization

## Context
The application currently uses a page-based ordering system for courses, which is inconsistent with the backend's native ordering. Additionally, synchronization logic for the Exams tab and curriculum filtering is inefficient, causing UI lag and missing data.

## Goals / Non-Goals

**Goals:**
- Implement deterministic sorting based on the backend's `"order"` field.
- Remove dependencies between the Study and Exams tabs for synchronization.
- Eliminate the 30-second blank screen when filtering curriculum items.
- Ensure proper navigation within tab branches.

**Non-Goals:**
- Redesigning the entire curriculum UI.
- Migrating the entire backend to a recursive API (handled via client-side UX optimization).

## Decisions

### 1. Database Schema Extension
- **Decision**: Add `orderIndex` column to `CoursesTable`.
- **Rationale**: Persisting the native order allows for stable sorting even when offline or during partial syncs.
- **Alternative**: Relying on the order of insertion into the DB (unreliable due to parallel syncs).

### 2. Multi-Tag Query Support
- **Decision**: Update `HttpDataSource` to pass `tags` as a list of query parameters.
- **Rationale**: The backend requires `?tags=exams&tags=classes` to perform an OR filter. Comma-joining tags was previously causing the backend to return an empty set.

### 3. Real-Time Sync Status Tracking
- **Decision**: Implement `activeSyncsStream` in `CourseRepository` using a `StreamController`.
- **Rationale**: Allows the UI to distinguish between "No data available" and "Sync in progress," providing a better loading state.

### 4. Targeted Recursive Sync
- **Decision**: Trigger content syncs for the current chapter AND its immediate sub-chapters when entering a folder or changing a filter.
- **Rationale**: Hides the latency of the full course sync by prioritizing the content the user is likely to view next.

## Risks / Trade-offs

- **Risk**: Increased API requests due to recursive syncing.
- **Mitigation**: Limit recursion to one level deep and rely on the background Master Sync for the rest.

- **Risk**: Database migration complexity for `orderIndex`.
- **Mitigation**: Use Drift's versioned migration system to ensure existing data is preserved.
