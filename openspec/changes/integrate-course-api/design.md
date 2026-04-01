## Context

The Study tab previously showed static mock data. This change replaces it with live data from the Testpress API, using an offline-first pattern: fetch from API → upsert into Drift → UI observes Drift stream.

## Goals / Non-Goals

**Goals:**
- Fetch and display real courses from `https://lmsdemo.testpress.in/api/v3/courses/`.
- Persist fetched courses in local Drift DB as the single source of truth for the UI.
- Support infinite scroll with API-driven pagination.
- Show a full-screen loader only when the local cache is completely empty (first ever visit).
- Display cached data immediately on subsequent tab visits.
- Only fetch data after the user is authenticated.

**Non-Goals:**
- Migrating `totalDuration` to `totalContents` (deferred to a separate change).
- Updating other tabs (Explore, Home) to use live data.

## Decisions

### 1. Centralized Networking
All HTTP communication goes through `NetworkProvider` (in `network_provider.dart`), which encapsulates the underlying `Dio` instance to prevent library leakage. It uses a **list-based interceptor injection** model rather than rigid factories. Real-world features like authentication are enabled by explicitly plugging in an **`AuthInterceptor`** during instantiation. The `AuthInterceptor` accepts a **getToken callback** rather than a direct dependency on local storage, decoupling the networking layer from storage implementation details. It standardizes headers (including `User-Agent` and `Authorization`) and translates errors into `ApiException`.

### 2. Pagination Strategy
The `CourseList` notifier manages session state (`nextPage`, `hasMore`) using a reusable **`PaginationService`**. The service extracts the next page number from the API's `next` field. The UI triggers `loadMore()` via the notifier when the scroll position is within 500px of the list bottom.

### 3. Caching and Loading Behavior
- **First visit with empty cache**: Show `AppLoadingIndicator` while the first page loads.
- **Revisit with cached data**: Render cached courses instantly from Drift. Background sync happens silently.
- **Pagination loader**: A small bottom spinner appears while fetching subsequent pages.
- **Smart Parsing**: `CourseDto` handles both raw API (snake_case) and internal (camelCase) formats, while `PaginatedResponseDto` isolates backend-specific quirks (like nested Testpress result maps).

### 4. Dev Auth
`AuthProvider` accepts the credentials "222"/"222" for development access. Centered on `NetworkProvider`, the authenticated Dio instance includes the `Authorization` header for all requests, enabling authenticated API calls without requiring a full production login flow at this stage.

### 5. Repository Sync Flow
The **`CourseList`** notifier handles the business logic for syncing:
1. Guard against concurrent calls (internal `_activeSync` Future).
2. Call the stateless `CourseRepository.fetchAndPersistCourses(page)`.
3. Repository: Fetches from the API and upserts results into Drift.
4. Notifier: Uses `PaginationService` to update its state (`nextPage`, `hasMore`) based on the API response.

### 6. Domain Isolation
As part of architectural refinement, all course-specific domain models (`CourseDto`, `ChapterDto`, `LessonDto`, etc.) are moved from `package:core` to their respective domain package: `package:courses`. This ensures that `package:core` remains a lean platform SDK (Design System, Networking, etc.) and is not polluted with domain-specific entities.
