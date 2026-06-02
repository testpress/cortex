## Context
The dashboard currently displays announcements ("Updates & Announcements") using mock data (`mockPromotionBanners`). We are replacing this mock data with live announcements fetched from the `/api/v3/posts/` endpoint.

## Goals / Non-Goals

**Goals:**
- Fetch live announcement posts from the backend API.
- Cache the categories and posts locally using Drift for offline access and faster loading.
- Display the top 3 most recent announcements on the dashboard.
- Enable navigation to a "View All" screen to see the full list of announcements.

**Non-Goals:**
- We are not redesigning the individual `AnnouncementBanner` UI component, just feeding it real data.
- We are not handling the `short_link` field (used for sharing) in this iteration.

## Decisions

### 1. Data Models (DTOs)
We will introduce new DTOs in `packages/core/lib/data/models/post_dto.dart` to match the `/api/v3/posts/` response:
- `PostDto`: Represents individual posts (`id`, `slug`, `title`, `categoryId`, `summary`, `contentHtml`, `coverImage`, `allowComments`, `publishedDate`, `createdHumanize`).
- `PostCategoryDto`: Represents the post categories (`id`, `name`, `slug`, `isStarred`, `color`, `order`).
- `PostsResponseDto`: Wraps the `count`, `next`, `results: { posts, categories }`.

*Rationale*: We need dedicated models rather than reusing the generic `DashboardBannerDto` since the API response is specifically tailored for posts with categories. We chose to skip the image variations (`cover_image_medium`, etc.) as they are not needed for the current UI.

### 2. Local Database (Drift Tables)
We will create `packages/core/lib/data/db/tables/posts_table.dart` to cache the data:
- `PostCategoriesTable`: Stores categories and their colors.
- `PostsTable`: Stores the posts, with a `categoryId` that references `PostCategoriesTable`.

*Rationale*: Caching ensures that announcements are visible instantly on the dashboard upon subsequent app launches without waiting for a network call.

### 4. UI Skeletons (Loading Placeholders)

We will display a shimmer‑style skeleton while announcements are being fetched:
- **Dashboard:** A horizontal list of 3 skeleton cards matching the height and layout of the real announcement banners.
- **List Page:** A vertical list of skeleton rows (image + two lines of text) matching the final announcement item layout.

*Rationale:* Improves perceived performance and keeps the UI consistent during network latency.

We will use the existing `shimmer` package already declared in `pubspec.yaml`.

- **Risk:** Caching announcements might lead to stale data if the dashboard isn't refreshed.
  **Mitigation:** The provider should fetch from network in the background and update the cache seamlessly on dashboard load.
