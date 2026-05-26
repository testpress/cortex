## Context

Forum browsing is now feed-first. Users land on a global thread list immediately, with category chips for filtering. The old course-selection entry path and course-scoped provider flow are removed from active navigation.

## Goals / Non-Goals

**Goals:**
- Use one global forum list screen (`ForumPostsListScreen`).
- Load categories and feed independently.
- Support pagination using backend `next`.
- Cache threads locally with Drift for fast initial paint.
- Route to thread detail by slug.
- Resolve detail data from list/cache and fetch comments by numeric thread id.

**Non-Goals:**
- Reintroducing course-first entry flow.
- Dedicated thread-detail API dependency for Phase 1/2 baseline.
- Offline mutations.

## Decisions

### 1. Single Feed Screen
We keep one list screen (`ForumPostsListScreen`) and avoid a duplicate global-feed screen.

### 2. Independent Providers
`globalForumCategoriesProvider` and `globalForumFeedProvider` run independently so chips do not block thread list rendering.

### 3. Pagination Contract
`globalForumFeedProvider` stores `items`, `nextPage`, `hasMore`, and `isLoadingMore`, and deduplicates by `threadId`.

### 4. Cache Strategy
Repository upserts feed results into Drift. UI can resolve thread detail by slug from local cache/list context.

### 5. Detail Resolution
Detail route uses slug (`/posts/:slug`), while comments use numeric thread id from the thread model.

## Risks / Trade-offs

- **Risk: stale detail when resolved from cache/list**
  - **Mitigation**: feed refresh on entry/pull-to-refresh keeps thread records fresh.
- **Risk: pagination duplication**
  - **Mitigation**: strict dedup by `threadId` before append.
