## Context

The current `CourseList` implementation uses a reactive DB stream for the Study tab. While this works well for browsing "All Courses", it fails for search because:
1. Local filtering only sees what's already fetched.
2. Saving search results to the same table pollutes the paginated sequence, as search results might arrive in an order inconsistent with the "main" course listing.

## Goals / Non-Goals

**Goals:**
- Implement server-side search integrated into the existing `CourseList` provider.
- Ensure search results are NOT saved to the local database.
- Maintain smooth pagination for both "All Courses" and search results.
- Keep the single source of truth (DB) for regular browsing.

**Non-Goals:**
- Refactoring the entire database schema.
- Implementing offline search.

## Decisions

### 1. Repository Method Differentiation
The `CourseRepository` will be updated to include a clear distinction between persistent and non-persistent fetching:
- `fetchAndPersistCourses(int page)`: Fetches from API and upserts to DB. Used for regular browsing.
- `searchCourses(int page, String query)`: Fetches from API but DOES NOT save to DB. Returns the results directly to the caller.

### 2. Provider Mode Switching
The `CourseList` provider will manage its internal mode based on the presence of a `searchQuery`:
- **Mode: Browse (No Query)**: Returns a `Stream` from `repo.watchCourses()`. `loadMore` calls `fetchAndPersistCourses`.
- **Mode: Search (Active Query)**: Returns internal results fetched from `repo.searchCourses`. `loadMore` calls `searchCourses` and appends to results.

### 3. Transitioning from Stream to Static List for Search
To accommodate search results that aren't in the DB, the `CourseList` build method will use a `ref.watch` on the repository stream ONLY when no query exists. When a query is present, it will yield the results directly. Since `Stream` is returned, it will be managed as a stream that emits the current search result set.

### 4. Debouncing and Resetting
The search triggered from the UI will have a debounce (500ms) to prevent fluttering the API and to allow for query resets without triggering unnecessary network calls.

## Risks / Trade-offs

- **Memory Usage**: Search results are held in memory. For extremely large search result sets, this could use more RAM than DB-backed streams, but for course listings (dozens to hundreds), it is negligible.
- **Complexity in `CourseList`**: Handling two different modes of operation in one provider requires careful state management to avoid race conditions during "load more".
- **Pagination Sync**: If the user browses, then searches, then clears search, the "browse" pagination state MUST be preserved or correctly reset to avoid skipping pages.
