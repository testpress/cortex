# Proposal: Integrate Course List API

Integrate the real course list API into the Study tab, replacing mock data with an offline-first repository implementation.

## Motivation

The Study tab was displaying static mock data. This change wires up the real Testpress backend (`https://lmsdemo.testpress.in/api/v3/courses/`) while preserving the offline-first architecture (Drift/SQLite cache).

## What Changes

1. **Networking**: Introduce `ApiClient` and `ApiException` in `packages/core/data/network` to centralize all HTTP logic. `HttpDataSource.getCourses` uses these to fetch paginated data from the Testpress API.
2. **Authentication**: A dev-only login path accepts the credentials "222"/"222" and transitions the app to authenticated state. All API requests include an `Authorization` header via `ApiClient`.
3. **Pagination**: `CourseRepository.refreshCourses` tracks `_nextPage` and `_hasMore` using the API's `next` field. The UI triggers the next fetch when the user scrolls near the bottom of the list.
4. **Caching**: The Study tab shows cached courses from Drift immediately on revisit. A full-screen loader only appears on the very first visit when the local database is empty.

## Scoped Out

- `totalDuration` → `totalContents` field migration is deferred to a separate change.
- Other tabs (Explore, Home) are not wired to live data in this change.

## Impact

- `packages/core`: `HttpDataSource`, `ApiClient`, `ApiException`, `PaginatedResponseDto`, `AuthProvider`.
- `packages/courses`: `CourseRepository`, `StudyScreen`, `course_list_provider`.
