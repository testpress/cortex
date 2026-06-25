# Design: Fix Chapter Folder Flash

## Root Cause Analysis

Three interlocking bugs caused the chapter folder flash:

### Bug 1 — `isChaptersSynced` gate in `subChaptersProvider`
The original provider checked `isChaptersSynced` before deciding to block on the network.
If the flag was true but the local DB was empty, it yielded `[]` immediately, causing the
UI to misidentify a folder as a leaf.

### Bug 2 — `keepAlive` provider + pull-to-refresh race condition
`subChaptersProvider` is `keepAlive: true`. Once its async generator completes the initial
fetch and enters a `yield*` passthrough, it has no memory of having emitted non-empty data.
When `refreshCourses` (triggered by pull-to-refresh) deletes chapters as part of its
page-1 cache invalidation, the `watchChapters` stream emits `[]`. The provider blindly
yields this empty state with `isLoading: false`, causing the UI to flip to lesson mode.

### Bug 3 — Flawed `showLessons` heuristic in `ChaptersListPage`
```dart
// WRONG — fires on any empty chapters state, including external DB purges
final showLessons = widget.isLeaf || activeFilter != null || (chapters.isEmpty && !chaptersAsync.isLoading);
```
The third condition cannot distinguish between "confirmed leaf folder" and "chapters
temporarily deleted by a background sync".

## Implementation Details

### `subChaptersProvider` (`course_detail_provider.dart`)
- If `localChapters.isEmpty`: always `await repo.refreshChapters()` before streaming.
- If `localChapters.isNotEmpty`: refresh in background (`.ignore()`), stream immediately.
- Replace `yield*` with a resilient `await for` loop:
  - Track `hasEmittedNonEmpty`.
  - If `chapters.isEmpty && hasEmittedNonEmpty`: chapters were externally purged → silently
    `await refreshChapters()` and wait for the next DB event. **Do not yield the empty state.**
  - Otherwise: yield normally and update `hasEmittedNonEmpty`.

### `ChaptersListPage` (`chapters_list_page.dart`)
```dart
// CORRECT — only the route/API decides if this is a leaf
final showLessons = widget.isLeaf || activeFilter != null;
final showChapters = !showLessons;
```
`widget.isLeaf` is set by the navigation layer based on `chapter.isLeaf` from the API
(parsed from the `leaf` JSON field). If a folder is genuinely a leaf, the navigation
sets `isLeaf: true` on the route. The UI should trust that — not infer it from an
empty list.

## Testing
- Navigate to a course never visited → should show skeleton, then chapters.
- Navigate to a course from cache → should show chapters instantly.
- Pull-to-refresh on course list → open same course → should recover chapters, never show lesson list.
- Navigate to a genuine leaf chapter → should show lesson list correctly.
