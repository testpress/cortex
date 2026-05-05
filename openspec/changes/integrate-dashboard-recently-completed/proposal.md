## Why

The dashboard currently lacks a dynamic "Recently Completed" section. Implementing this feature using the real backend API (`/api/v2.4/completed/`) will allow users to quickly view and revisit their successfully finished lessons, improving the overall engagement and study tracking experience.

## What Changes

- Implement fetching of completed lessons from the `/api/v2.4/completed/` endpoint.
- Add a dedicated parser `_parseRecentlyCompleted` in `DashboardContentsDto` to map the relational response (contents and chapters).
- Integrate the completed lessons feed into the `DashboardRepository` and provide it via a Riverpod stream.
- Update the UI to display real data in the "Recently Completed" section instead of dummy values.

## Capabilities

### New Capabilities
- `dashboard-recently-completed`: Fetch and display the list of lessons recently finished by the user.

### Modified Capabilities
- `dashboard-feed`: Update the core dashboard feed logic to include the new section type.

## Impact

- `DashboardContentsDto`: New parsing branch for `recentlyCompleted`.
- `DashboardRepository`: New watch and refresh methods for completed lessons.
- `HttpDataSource`: New API endpoint integration.
- `PaidActiveHomeScreen`: Replaced dummy data with the new `recentlyCompletedFeedProvider`.
