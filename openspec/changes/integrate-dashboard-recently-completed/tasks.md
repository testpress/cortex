## 1. API Integration

- [x] 1.1 Add `/api/v2.4/completed/` to `ApiEndpoints`
- [x] 1.2 Implement `getRecentlyCompletedFeed()` in `HttpDataSource`

## 2. Data Mapping & Parsing

- [x] 2.1 Implement `_parseRecentlyCompleted` in `DashboardContentsDto`
- [x] 2.2 Wire the new parsing branch into `DashboardContentsDto.fromJson`

## 3. Repository & Providers

- [x] 3.1 Implement `refreshRecentlyCompletedFeed()` in `DashboardRepository`
- [x] 3.2 Implement `watchRecentlyCompletedFeed()` in `DashboardRepository`
- [x] 3.3 Create `recentlyCompletedFeedProvider` in `dashboard_providers.dart`

## 4. UI Integration

- [x] 4.1 Update `PaidActiveHomeScreen` to use `recentlyCompletedFeedProvider`
- [x] 4.2 Verify progress and badge display for completed items in `LessonCardWidget`
