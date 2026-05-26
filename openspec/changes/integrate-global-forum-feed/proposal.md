## Why

The old forum flow forced users to select a course before seeing discussions. Backend data shows most threads are generic (`course_id: null`), so the course-first entry point hid the most active conversations.

## What Changes

- **BREAKING**: Remove course-selection-first forum navigation.
- Use a single global `ForumPostsListScreen` as the default forum entry.
- Fetch global threads from `GET /api/v2.5/discussions/` with optional category filter.
- Fetch categories from `GET /api/v2.3/forum/categories/` and render chips on the feed.
- Use lazy loading with `next` pagination metadata.
- Cache feed threads in Drift for fast initial render.
- Open thread detail by slug route, but resolve detail data from feed/local cache (no dedicated detail endpoint in current scope).
- Fetch comments by numeric thread id using `GET /api/v2.5/discussions/<id>/comments/`.

## Capabilities

### New Capabilities
- `global-forum-feed`: Unified feed, pagination, cache, and global entry flow.
- `forum-category-filter`: Dynamic category chips and filtered feed query.

### Modified Capabilities
- `forum-post`: Primary thread browsing is global instead of course-isolated.

## Impact

- **UI/UX**: Forum opens directly to global feed.
- **Routing**: `/home/discussions/forum` -> feed, `/home/discussions/forum/posts/:slug` -> detail.
- **API**: Feed and comments endpoints are core; no mandatory thread-detail endpoint in this scope.
- **Data**: Drift thread schema supports global data (`courseId` nullable, `categorySlug` nullable, numeric `threadId`).
