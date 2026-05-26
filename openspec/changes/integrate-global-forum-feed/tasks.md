## 1. Phase 1: Global Forum Thread Feed & Categories

- [x] 1.1 Normalize forum DTO contracts for global flow (`threadId`, `slug`, nullable `courseId`, `categorySlug`, `summary`, `contentHtml`).
- [x] 1.2 Add forum endpoint constants for categories, threads, and comments.
- [x] 1.3 Implement real data source calls for categories and paginated threads (`/discussions/`) and comments (`/discussions/<id>/comments/`).
- [x] 1.4 Migrate Drift forum threads schema for global feed support (`courseId` nullable, `categorySlug` nullable, persisted `threadId`).
- [x] 1.5 Implement global providers (`globalForumCategoriesProvider`, `globalForumFeedProvider`) with pagination + dedup.
- [x] 1.6 Use `ForumPostsListScreen` as the single global forum feed UI with category chips + load-more.
- [x] 1.7 Update routing to `/home/discussions/forum` and `/home/discussions/forum/posts/:slug`.
- [x] 1.8 Remove legacy course-first forum artifacts from active implementation (course-selection screen flow, deprecated course-scoped providers/screens).

## 2. Phase 2: Thread Details & Comments

- [x] 2.1 Finalize `ForumPostDetailScreen` around slug route + cached/list thread resolution.
- [x] 2.2 Ensure comments state is loaded using numeric `threadId` from thread model.
- [x] 2.3 Render rich content safely in detail (`contentHtml`) with fallback behavior when empty.
- [x] 2.4 Implement comments list UX details (empty state, loading/error states).
- [x] 2.5 Add explicit refresh behavior between list and detail where needed.

## 3. Phase 3: Thread & Comment Creation Flow

- [x] 3.1 Implement POST methods for thread and comment creation.
- [x] 3.2 Reintroduce/create compose UI aligned with global categories provider (submit `categorySlug`).
- [x] 3.3 Add entry action (FAB/button) from global feed to composer.
- [x] 3.4 Add reply composer in detail screen.
- [x] 3.5 Invalidate/refresh feed and comments providers after successful mutations.
