## 1. Network Layer & Parsing

- [x] 1.1 Update `getAnalyticsData` method signature in `DataSource` and `HttpDataSource` to support `page` and `parentId` parameters.
- [x] 1.2 Implement parsing logic to merge `subjects` metadata and `subject_stats` scores into a unified `PaginatedResponseDto<SubjectAnalyticsDto>`.

## 2. Database & Repository Layer

- [x] 2.1 Update `SubjectAnalyticsRepository` to include `fetchSubjectAnalyticsPage` method supporting pagination and `parentId`.
- [x] 2.2 Implement the delete-and-insert database transaction in the repository for page 1 data refreshes to prevent stale data.
- [x] 2.3 Implement the standard insert/upsert operation in the repository for appending subsequent paginated data (page 2+).

- [x] 3.1 Create `SubjectAnalyticsPaginationNotifier` Riverpod provider to track pagination state (`currentPage`, `hasMorePages`, `isFetchingNextPage`).
- [x] 3.2 Implement `fetchInitial()` method in the notifier to trigger the initial page 1 fetch.
- [x] 3.3 Implement `fetchNextPage()` method in the notifier to fetch subsequent pages safely.

## 4. UI Layer

- [x] 4.1 Update `subject_analytics_screen.dart` to watch the Drift database stream for top-level subjects.
- [x] 4.2 Update `topic_analytics_screen.dart` to watch the Drift database stream for child subjects based on `parentId`.
- [x] 4.3 Wrap the lists in `Skeletonizer` to handle initial loading states.
- [x] 4.4 Add scroll listeners to the UI lists to trigger `fetchNextPage()` when the user reaches the bottom.
- [x] 4.5 Conditionally append `Skeletonizer` loader items at the bottom of the list when `isFetchingNextPage` is true.
