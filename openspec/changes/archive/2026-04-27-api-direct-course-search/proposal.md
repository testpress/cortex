## Why

The current course search implementation filters against a local database cache. This is problematic because:
1. The local cache only contains a subset of all available courses (those fetched via pagination).
2. Searching only the local cache fails to find courses that exist on the server but haven't been loaded locally yet (e.g., courses on later pages).
3. Persisting search results into the same local table as regular paginated results disrupts the ordered, incremental pagination flow, leading to "random" or duplicated results when the user continues scrolling.

Moving to direct API search ensures that the user can find any course starting from the first search, regardless of whether it's cached locally.

## What Changes

- **API Layer**: `HttpDataSource` will be updated to support a `search` query parameter in the `getCourses` method.
- **Repository Layer**: `CourseRepository` will differentiate between regular paginated fetching (persisted) and search fetching (non-persisted).
- **State Management**: The `CourseList` provider will manage search state separately. When searching, it will switch from a database-backed stream to an API-driven result set that is held only in memory for the duration of the search.
- **UI**: `StudyScreen` will trigger the new search workflow with an appropriate debounce.

## Capabilities

### New Capabilities
- `api-course-search`: Direct server-side search for courses without local database persistence of search results.

### Modified Capabilities
- `study-curriculum-list`: Update the core course listing capability to support toggling between live DB stream and search result set.

## Impact

- `packages/core/lib/data/sources/data_source.dart`: Interface update for `getCourses`.
- `packages/core/lib/data/sources/http_data_source.dart`: Implementation of `search` parameter.
- `packages/courses/lib/repositories/course_repository.dart`: New logic for non-persistent fetching.
- `packages/courses/lib/providers/course_list_provider.dart`: State management overhaul for search mode.
- `packages/courses/lib/screens/study_screen.dart`: UI integration.
