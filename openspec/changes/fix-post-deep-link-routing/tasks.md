## 1. Data Layer Implementation

- [x] 1.1 Add `postDetail(slug)` endpoint to `packages/core/lib/network/api_endpoints.dart`.
- [x] 1.2 Add `getPost(slug)` to `DataSource`, `HttpDataSource`, and `MockDataSource`.
- [x] 1.3 Add `watchPostBySlug(slug)` and `getPostBySlug(slug)` to `AppDatabase`.
- [x] 1.4 Add `watchPostBySlug(slug)` and `fetchPost(slug)` to `PostsRepository`.
- [x] 1.5 Add `postDetailProvider(slug)` to `packages/core/lib/data/providers/announcements_provider.dart`.

## 2. UI & Navigation Integration

- [x] 2.1 Update `AnnouncementDetailScreen` in `packages/testpress/lib/screens/announcements/announcement_detail_screen.dart` to support loading by `slug`.
- [x] 2.2 Register `/home/posts` and `/home/posts/:slug` in `packages/testpress/lib/navigation/routes/home_routes.dart`.
- [x] 2.3 Update `DeepLinkHandler.rules` in `packages/testpress/lib/navigation/deep_link_handler.dart` to map `/p/:slug` and `/posts/:slug` to `/home/posts/:slug`, and `/p` and `/posts` to `/home/posts`.

## 3. Testing & Verification

- [x] 3.1 Update unit tests in `packages/testpress/test/navigation/deep_link_handler_test.dart` to verify `/p/:slug` and `/posts/:slug` resolve to `/home/posts/:slug`.
- [x] 3.2 Run `flutter test` and `flutter analyze` to ensure all tests pass and static analysis reports 0 issues.
