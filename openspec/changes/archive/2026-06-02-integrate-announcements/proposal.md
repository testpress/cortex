## Why
The dashboard currently displays announcements ("Updates & Announcements") using hardcoded mock data (`mockPromotionBanners`). To provide real-time news and updates to learners, we need to integrate the actual backend system (the `/api/v3/posts/` endpoint) and display dynamic announcement posts directly on the dashboard.

## What Changes
- Introduce a new data model (`PostDto`) to parse the `/api/v3/posts/` API response (which includes fields like `id`, `title`, `summary`, `cover_image`, `published_date`, etc.).
- Add the `/api/v3/posts/` endpoint to `ApiEndpoints` and implement the corresponding fetch method in the network layer (`HttpDataSource`).
- Update the `promotionBannersProvider` to fetch data from the live endpoint instead of returning the local mock data.
- Adjust the UI mapping in `PaidActiveHomeScreen` to display only the top 3 latest announcements on the dashboard.
- Implement a "View All" screen (or connect an existing one) to display the complete list of announcements when the user taps "View All".

## Capabilities

### New Capabilities
- `dashboard-announcements`: Integration of the `/api/v3/posts/` API to fetch and display dynamic announcements in the dashboard's "Updates & Announcements" section.

### Modified Capabilities


## Impact
- **Network Layer:** Addition of new endpoint and fetch logic (`api_endpoints.dart`, `http_data_source.dart`).
- **Data Models:** Creation of `post_dto.dart` (or additions to `dashboard_dto.dart`).
- **UI & State:** Modifications to `dashboard_providers.dart` and `paid_active_home_screen.dart` to consume and display the real data.
