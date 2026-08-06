## 1. ChaptersListPage — Pull-to-Refresh

- [x] 1.1 Use `AppRefreshIndicator` from the shared components in `chapters_list_page.dart`
- [x] 1.2 Wrap the `Expanded` content area in `chaptersAsync.when(data: ...)` with an `AppRefreshIndicator`
- [x] 1.3 In the `onRefresh` callback: await `repo.refreshChapters` when in chapter-list mode, and await `filteredLessonsProvider(...).notifier.refresh()` when in lesson-list mode, preserving local cache
- [x] 1.4 Add `physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics())` to the chapters `AppScroll` and to all `ListView.builder` instances inside the `AppRefreshIndicator`
- [x] 1.5 Replace the empty-state `Center` widget (in the `filteredLessons.isEmpty` branch) with a `CustomScrollView` using `SliverFillRemaining(hasScrollBody: false)` so the pull gesture works on empty lists

## 2. ChapterDetailPage — Pull-to-Refresh

- [x] 2.1 Use `AppRefreshIndicator` from the shared components in `chapter_detail_page.dart`
- [x] 2.2 Wrap the `Expanded` `AppScroll` (in the `chapterAsync.hasValue` branch) with an `AppRefreshIndicator`
- [x] 2.3 In the `onRefresh` callback: call `chapterDetailControllerProvider.notifier.refresh(courseId, chapterId)` which handles the network calls and UI loading states safely
- [x] 2.4 Add `physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics())` to the `AppScroll` inside the `AppRefreshIndicator`


## 3. Legacy Migration

- [x] 3.1 Replace `CupertinoSliverRefreshControl` with `AppRefreshIndicator` in `forum_posts_list_screen.dart`
- [x] 3.2 Replace `CupertinoSliverRefreshControl` with `AppRefreshIndicator` in `doubts_list_screen.dart`
- [x] 3.3 Replace `CupertinoSliverRefreshControl` with `AppRefreshIndicator` in `announcements_list_screen.dart`

## 4. Verification

- [x] 4.1 Open a course in Study → chapters list loads → pull down → chapter list refreshes with indicator visible
- [x] 4.2 Tap a filter tab (e.g., Videos) → pull down → filtered lesson list refreshes
- [x] 4.3 Tap on a chapter → chapter detail opens → pull down → lesson list re-syncs (existing content stays visible, no skeleton)
- [x] 4.4 Verify the same refresh behaviour on an Exams course subfolder and an Info course subfolder (same components, different routes)
- [x] 4.5 Test with an empty filtered list — confirm pull gesture is recognised and the refresh indicator appears
