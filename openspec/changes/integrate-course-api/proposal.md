# Proposal: Integrate Course List API

Integrate the real course list API into the Study tab, replacing mock data with an offline-first repository implementation.

## Motivation

The Study tab was displaying static mock data. This change wires up the real Testpress backend (`https://lmsdemo.testpress.in/api/v3/courses/`) while preserving the offline-first architecture (Drift/SQLite cache).

## What Changes

1. **Networking Alignment**: Align all network request orchestration via `performNetworkRequest`. Consistent error handling is ensured via `ApiException.fromDioException`.
2. **UI Decomposition**: To maintain maintainability and stay below the 250-line file limit, the following new widgets were created:
   - `StudyFilterBar`: Specialized widget for complex, animated content type filters.
   - `StudyContentList`: Handles the switching between course and lesson lists, including search and pagination states.

## Scoped Out

- `totalDuration` → `totalContents` field migration is deferred to a separate change.
- Other tabs (Explore, Home) are not wired to live data in this change.

## Impact

- `packages/core`: `HttpDataSource`, `NetworkProvider`, `ApiException`, `PaginatedResponseDto`, `AuthProvider`, `AuthException`.
- `packages/courses`: `CourseRepository`, `StudyScreen`, `CourseList` provider, `lesson_detail_provider`.
- `packages/courses/widgets`: `StudyFilterBar`, `StudyContentList`, `LessonListItem`.
