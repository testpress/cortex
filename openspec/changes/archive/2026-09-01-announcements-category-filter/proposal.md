## Why

Clients with Quick Links enabled need to organize announcements into categories (such as events, notices, exams) and access them directly from dashboard quick links. Currently, the announcements feed only loads a single monolithic stream of posts into the local Drift SQLite database with no category segmentation. We need to support category filtering for these clients while keeping filtered streams isolated from the persistent offline announcement cache.

## What Changes

- Add category filtering to the announcements list screen, gated by the `showQuickLinks` feature configuration.
- Implement a filter action button on the announcement header that opens a floating bottom sheet modal to select a category or view all posts.
- Display an active category badge with a clear button when a category filter is applied.
- Add `fetchPostsOnlineOnly` to `PostsRepository` and a `CategoryPosts` provider to fetch server-side filtered posts without corrupting the local database cache of all announcements.
- Add pull-to-refresh support on empty announcement state views.
- Add a Quick Links horizontal section to the dashboard home screen linking directly to category-filtered announcements.

## Capabilities

### New Capabilities
- `announcements-category-filter`: Support category-based filtering for announcements, including header filter action, instant category selection bottom sheet, active filter pill with one-tap clear, and in-memory filtered pagination.

### Modified Capabilities

## Impact

- `packages/core`: Add `fetchPostsOnlineOnly` in `PostsRepository`, `CategoryPosts` and `CategoryPostsFetchingPage` providers in `announcements_provider.dart`, and `ColorUtils` helper.
- `packages/testpress`: Update `AnnouncementsListScreen`, create `AnnouncementFilterBar` and `AnnouncementFilterSheet`, and create `QuickLinksSectionWidget` on dashboard.
