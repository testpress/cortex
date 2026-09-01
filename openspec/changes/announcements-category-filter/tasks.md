## 1. Core Providers & Data Flow

- [x] 1.1 Implement `fetchPostsOnlineOnly` in `PostsRepository` and `CategoryPosts` family provider in `packages/core` to fetch paginated category-filtered posts via `PostsRepository`.
- [x] 1.2 Implement `CategoryPostsFetchingPage` boolean provider in `packages/core` for tracking pagination state.
- [x] 1.3 Run `build_runner` to generate Riverpod providers in `packages/core`.

## 2. Announcements UI & Filter Modal

- [x] 2.1 Update `AppHeader` in `AnnouncementsListScreen` to include a filter icon action with an active filter badge dot and `showDivider: false`.
- [x] 2.2 Implement `AnnouncementFilterSheet` as a floating modal bottom sheet with instant tap-to-select for categories and "All Posts".
- [x] 2.3 Implement `AnnouncementFilterBar` to display an active category badge pill with a one-tap clear button when filtered.
- [x] 2.4 Update `AnnouncementsListScreen` empty state to support pull-to-refresh with `AppRefreshIndicator` and `CustomScrollView`.

## 3. Dashboard Integration

- [x] 3.1 Implement `QuickLinksSectionWidget` on the dashboard to display category chips styled with backend colors.
- [x] 3.2 Add navigation from quick link chips to `AnnouncementsListScreen` with the selected category pre-filtered.

## 4. Verification

- [x] 4.1 Run `dart analyze` across `packages/core` and `packages/testpress` to verify zero issues.
- [x] 4.2 Verify category filtering, instant bottom sheet selection, active pill dismissal, and pull-to-refresh on empty state.
