## Context

In the Store section of the app, courses are rendered inside `ProductExpandableCourseCard`. When a user expands a course, it watches `storeCourseChaptersProvider`, which delegates to `StoreRepository.fetchCourseChapters` and calls `HttpDataSource.getCourseChapters`.

Previously, `HttpDataSource.getCourseChapters` called `GET /api/v3/courses/{id}/chapters/` without query parameters. Because Testpress's v3 chapters endpoint requires `parent_id=null` to retrieve root chapters, omitting `parent_id` caused the backend to return an empty chapter list `[]`. Consequently, `ProductExpandableCourseCard` fell back to rendering count summary badges (e.g. "1 Chapter, 1 Exam") instead of rendering `StoreChapterTile` and its nested contents.

## Goals / Non-Goals

**Goals:**
- Provide complete hierarchical chapter retrieval in `HttpDataSource.getCourseChapters` by recursively fetching root chapters (`parent_id=null`) and child chapters (`parent_id={chapter.id}` for any chapter where `!chapter.isLeaf`).
- Reuse the existing, proven `getChapters` method to handle network requests and response parsing.
- Ensure `StoreChapterTile` and nested `StoreContentTile` components correctly receive and render chapters, sub-chapters, and free preview contents.

**Non-Goals:**
- Modifying offline Drift database sync in `CourseRepository` (store preview courses remain in-memory via `StoreRepository`).
- Modifying backend API contracts or endpoints.
- Modifying checkout or payment flows.

## Decisions

### Decision 1: Recursive Chapter Fetching in `HttpDataSource.getCourseChapters`
- **Choice**: Implement recursive chapter fetching starting from root chapters (`parentId: null`), matching the pattern in `MockDataSource._getAllChaptersRecursively`, and using `Future.wait` across sibling non-leaf folders to avoid sequential N+1 round trips.
- **Rationale**: `ProductExpandableCourseCard` builds an in-memory parent-to-child map (`StoreChapterTile.buildChildrenMap(allChapters)`) and expects the entire course tree to be available upon course expansion. Reusing `getChapters` ensures consistent query parameters (`parent_id=null` / `parent_id={id}`) and response parsing. Firing sibling fetches concurrently keeps initial load times minimal.
- **Alternative Considered**: Modifying `StoreChapterTile` to lazily fetch child chapters via a new Riverpod provider — rejected to avoid unnecessary state management changes, skeleton flashes, and complex tile caching when all chapters are already small enough to fetch and cache in-memory.

## Risks / Trade-offs

- **[Risk] Multiple network requests for courses with nested sub-chapters** → *Mitigation*: Sibling sub-chapters are fetched concurrently via `Future.wait`, eliminating serial network request queuing. In addition, `StoreRepository` caches the full chapter list in memory so each course is fetched at most once per session or until explicitly cleared.
- **[Risk] Infinite recursion if backend data has circular references** → *Mitigation*: Track visited chapter IDs synchronously during recursion before dispatching asynchronous child fetches to prevent infinite loops even if data contains cyclical parent relationships.
- **[Trade-off] Fail-fast vs. partial results on nested chapter retrieval** → *Rationale*: If any child chapter request fails, `Future.wait` rejects the entire batch. This fail-fast behavior is intentional to prevent caching an incomplete chapter tree in `StoreRepository`, ensuring students never see silently truncated curricula and allowing clean retries.

