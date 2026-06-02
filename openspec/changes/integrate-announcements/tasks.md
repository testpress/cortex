## 1. Data Models and API Integration

- [x] 1.1 Create `PostDto`, `PostCategoryDto`, and `PostsResponseDto` in `packages/core/lib/data/models/post_dto.dart`
- [x] 1.2 Add `/api/v3/posts/` endpoint to `packages/core/lib/network/api_endpoints.dart`
- [x] 1.3 Add fetch method `getPosts` in `packages/core/lib/data/sources/http_data_source.dart`

## 2. Local Database Integration

- [x] 2.1 Create `PostCategoriesTable` and `PostsTable` in `packages/core/lib/data/db/tables/posts_table.dart`
- [x] 2.2 Register the new tables in the main Drift AppDatabase
- [x] 2.3 Implement caching logic in the repository to store and retrieve posts from the local database

## 3. State Management and UI

- [x] 3.1 Rename `promotionBannersProvider` to `announcementsProvider` (or `postsProvider`) in `dashboard_providers.dart` and update all references.
- [x] 3.2 Update the renamed provider to fetch data, use the cache, and return only the top 3 latest posts for the dashboard.
- [x] 3.3 Ensure `PaidActiveHomeScreen` maps the new data correctly to `AnnouncementBanner` widgets.

## 4. Announcements List Page (View All)
- [x] 4.1 Create `AnnouncementsListScreen` in `packages/courses/lib/screens/announcements_list_screen.dart`.
- [x] 4.2 Create a state provider to fetch and paginate `PostDto`s using `PostsRepository`.
- [x] 4.3 Implement a shimmer-style skeleton loader for the list page.
- [x] 4.4 Build the UI using standard list view, rendering the `PostDto`s as cards.
- [x] 4.5 Wire up `PaidActiveHomeScreen`'s `onViewAll` callback to navigate to `AnnouncementsListScreen`.

## 5. Announcement Detail Screen
- [x] 5.1 Create `AnnouncementDetailScreen` in `packages/testpress/lib/screens/announcements/announcement_detail_screen.dart`.
- [x] 5.2 Implement `AppHtmlV2` to render the announcement HTML content without webview elasticity.
- [x] 5.3 Enhance `AppHtmlV2` to show `Skeletonizer` placeholders for loading images instead of standard circular loaders.
- [x] 5.4 Display "Comments are disabled for this post" warning as a sticky footer if comments are disabled.
- [x] 5.5 Wire up dashboard `PromotionalBanners` cards to navigate to `AnnouncementDetailScreen`.
- [x] 5.6 Wire up list screen `AnnouncementListItem` cards to navigate to `AnnouncementDetailScreen`.
