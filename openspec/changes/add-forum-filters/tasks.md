## 1. Data Layer & State Management

- [x] 1.1 Define `ForumActivityFilter` and `ForumSort` enums.
- [x] 1.2 Update `DataSource` interface and `MockDataSource`/`HttpDataSource` to accept primitive query parameters (strings/booleans) for filtering in `getForumThreads`.
- [x] 1.3 Update `ForumRepository.fetchThreads` to translate enums into raw parameters and pass them to `DataSource`.
- [x] 1.4 Update `GlobalForumFeed` Riverpod provider to maintain and accept `activityFilter` and `sortOrder` state.

## 2. UI Component: Activity Filter Bottom Sheet

- [x] 2.1 Create `ForumFilterBottomSheet` widget.
- [x] 2.2 Implement the "Filter by Activity" section with predefined options (e.g., Posted by me, Liked by me).
- [x] 2.3 Add "Clear" action to the bottom sheet to reset selections.

## 3. UI Integration: Main Screen

- [x] 3.1 Introduce a Sorting Segmented Control ("Recent", "Most Liked", "Most Viewed") above the horizontal `_CategoryChips` in `ForumPostsListScreen`.
- [x] 3.2 Connect the Sorting Segmented Control to update the `sortOrder` in `globalForumFeedProvider`.
- [x] 3.3 Add a filter icon to the `ForumPostsListScreen` header or adjacent to the search bar.
- [x] 3.4 Wire the filter icon to open `ForumFilterBottomSheet` via `AppBottomSheet`.
