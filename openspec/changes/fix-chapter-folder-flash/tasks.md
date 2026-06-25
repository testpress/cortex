## 1. Provider Layer

- [x] 1.1 Remove `isSynced` check in `subChaptersProvider` — always `await repo.refreshChapters()` when `localChapters` is empty
- [x] 1.2 Replace `yield*` passthrough with a resilient `await for` loop
- [x] 1.3 Track `hasEmittedNonEmpty` to detect external DB purges (`non-empty → empty` transitions)
- [x] 1.4 Silently re-fetch via `refreshChapters()` on empty transition instead of yielding the empty state

## 2. UI Layer

- [x] 2.1 Remove `(chapters.isEmpty && !chaptersAsync.isLoading)` fallback from `showLessons` in `ChaptersListPage`
- [x] 2.2 Gate `showLessons` exclusively on `widget.isLeaf || activeFilter != null`
- [x] 2.3 Simplify `showChapters = !showLessons`
- [x] 2.4 Show `_skeletonChapters` when `chapters.isEmpty && chaptersAsync.isLoading` inside the `data:` block
