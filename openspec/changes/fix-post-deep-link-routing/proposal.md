## Why

When users tap on a blog post or announcement push notification (`/p/:slug` or `/posts/:slug`), Cortex currently resolves the URL to `/home/discussions/forum/posts/:slug` and launches `ForumPostDetailScreen`.

Because `ForumPostDetailScreen` queries the Discussions Forum API (`/api/v2.5/discussions/<slug>/`), and announcements are stored under the Posts API (`/api/v3/posts/`), the backend returns a `404 Not Found`, displaying a broken "Discussion Not found" screen.

In native Android, post links navigate directly to the Post/Announcement detail view (`PostActivity`). Cortex already contains `AnnouncementDetailScreen` backed by `PostsRepository`, but lacks a registered GoRoute and a single-post fetch query by slug.

## What Changes

1. **Endpoint & Data Source Integration**:
   - Add `postDetail(slug) => '/api/v3/posts/$slug/'` to `ApiEndpoints` supporting both slug and short_link (`?short_link=true`).
   - Add `getPost(slug)` to `DataSource`, `HttpDataSource`, and `MockDataSource`.
2. **Database & Repository Support**:
   - Add `watchPostBySlug(slug)` and `getPostBySlug(slug)` to `AppDatabase`.
   - Add `watchPostBySlug(slug)` and `fetchPost(slug)` to `PostsRepository`.
3. **Provider Layer**:
   - Introduce `postDetailProvider(slug)` in `announcements_provider.dart` to fetch and watch a single post reactively.
4. **UI Adaptation**:
   - Update `AnnouncementDetailScreen` to accept an optional `slug` alongside `post`, reactively loading the post when opened via deep link.
5. **Route Registration**:
   - Register `/home/posts` and `/home/posts/:slug` in `HomeRoutes`.
6. **Deep Link Normalization**:
   - Update `DeepLinkHandler.rules` to map `/p/:slug` and `/posts/:slug` to `/home/posts/:slug`, and `/p` and `/posts` to `/home/posts`.
7. **Automated Unit Tests**:
   - Update `deep_link_handler_test.dart` and add tests for post detail routing and slug extraction.

## Capabilities

### Modified Capabilities
- `deep-link-resolution`: Routes `/p/:slug` and `/posts/:slug` to `/home/posts/:slug` instead of discussions.
- `dashboard-announcements`: Adds single-post lookup by slug to support direct navigation from notifications.

## Impact
- `packages/core/lib/network/api_endpoints.dart`: Adds `postDetail(slug)` endpoint.
- `packages/core/lib/data/sources/`: Adds `getPost(slug)` in `DataSource`, `HttpDataSource`, and `MockDataSource`.
- `packages/core/lib/data/db/app_database.dart`: Adds slug query for posts.
- `packages/core/lib/data/repositories/posts_repository.dart`: Adds `watchPostBySlug` and `fetchPost`.
- `packages/core/lib/data/providers/announcements_provider.dart`: Exposes `postDetailProvider(slug)`.
- `packages/testpress/lib/screens/announcements/announcement_detail_screen.dart`: Supports slug-based loading.
- `packages/testpress/lib/navigation/routes/home_routes.dart`: Registers post routes.
- `packages/testpress/lib/navigation/deep_link_handler.dart`: Updates rules for post paths.
