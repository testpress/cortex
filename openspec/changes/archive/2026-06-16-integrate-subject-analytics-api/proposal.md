## Why

The application currently lacks real-time, paginated analytics for subjects. This change integrates the Subject Analytics API to fetch performance metrics across any level of the subject tree. By implementing an offline-first architecture with background syncing, the app will ensure instant load times and offline accessibility while keeping data gracefully up-to-date.

## What Changes

- **API Integration**: Integrate paginated `GET /api/v3/analytics/overall-subject-analytics/` endpoints (by passing parent IDs).
- **Data Parsing**: Introduce a custom parser to merge the split response arrays (`subjects` metadata and `subject_stats` scores) into unified `SubjectAnalyticsDto` instances based on matching IDs.
- **Offline-First Caching**: 
  - Cache API responses to the local Drift database.
  - Use reactive Drift Streams as the single source of truth for Riverpod providers.
  - Implement a delete-and-insert database transaction for page 1 refreshes to remove stale data without UI flashing.
- **UI/UX**: Implement `Skeletonizer` loaders for initial screen loads and for lazy pagination at the bottom of the list.

## Capabilities

### New Capabilities
- `subject-analytics`: Handles fetching, parsing, caching, and displaying of subject analytics data and recursive child subjects.

### Modified Capabilities
- (None)

## Impact

- **Data Models**: Updates parsing logic for `SubjectAnalyticsDto`.
- **Data Sources**: Modifies `getAnalyticsData` signature in `DataSource` and `HttpDataSource`.
- **Repositories**: Updates `SubjectAnalyticsRepository` to handle the delete-and-replace transactional logic and pagination.
- **Providers**: Adds a `SubjectAnalyticsPaginationNotifier` to manage pagination state.
- **UI**: Updates `subject_analytics_screen.dart` and `topic_analytics_screen.dart` to use `Skeletonizer` and scroll listeners for lazy loading.
