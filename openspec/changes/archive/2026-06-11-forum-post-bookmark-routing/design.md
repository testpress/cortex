## Context

Bookmarks currently store a reference to a forum post or discussion using its `slug`, but the `globalForumThreadDetailProvider` only reads from the local SQLite database. If a user has not recently opened the main forum feed, the thread does not exist locally, causing the bookmark routing to fail with a "Not Found" error. With the backend newly providing `GET /api/v2.5/discussions/<slug>/`, we can now resolve this by fetching missing threads on demand.

## Goals / Non-Goals

**Goals:**
- Enable seamless navigation from a bookmark directly to a `ForumPostDetailScreen`.
- Download and cache the forum thread if it does not exist locally.
- Maintain the offline-first resilience of the forum providers.
- Improve visual clarity of community posts in the bookmarks feed.

**Non-Goals:**
- Fetching thread comments dynamically (this is already handled by `globalForumCommentsProvider`).
- Adding a detail screen for `notice` or `post` types (these remain no-ops for now).

## Decisions

1. **Provider Background Fetching:**
   Instead of bypassing the local database entirely, `globalForumThreadDetailProvider` will be updated to check the initial state of the local DB (`watchThreadBySlug(slug).first`). If it is `null`, it `await`s the network fetch, causing the UI to show a skeleton loader. If it is not `null`, it calls `.ignore()` on the fetch, triggering a background stale-while-revalidate update.
2. **Network Error Swallowing:**
   If the network fetch fails (e.g., user is offline), the provider catches and swallows the error before yielding the local stream. This prevents the provider stream from crashing and allows the UI to gracefully handle the empty/offline state.
3. **Routing Strategy:**
   `bookmarks_screen.dart` will push `/home/discussions/forum/posts/${bookmark.slug}` directly via `GoRouter` for bookmarks of type `forumpost`. Types like `post` and `notice` will safely fall through as no-ops.
4. **UI Taxonomy:**
   `BookmarkItem` will map `forumpost`, `post`, `question`, and `notice` to distinct Lucide icons and colors from `design.shortcutPalette`, replacing the generic video/pdf fallback colors.

## Risks / Trade-offs

- **Risk:** Rapidly clicking multiple uncached bookmarks could trigger multiple network requests.
- **Mitigation:** The `upsertForumThreads` database transaction ensures that subsequent duplicate fetches will safely overwrite the row without conflict.
