## 1. Data Layer & Models

- [x] 1.1 Refactor `ForumThreadDto` and `ForumCommentDto` to use generic author fields and social metadata.
- [x] 1.2 Update `ForumThreadsTable` and `ForumCommentsTable` in Drift for schema v8.
- [x] 1.3 Update table registration in `AppDatabase` and handle migration logic.
- [x] 1.4 Introduce `packages/forum` and implement `ForumRepository` inside it to keep API calls decoupled from `core`.
- [x] 1.5 Populate `MockDataSource` with fresh discussion thread data.

## 2. Navigation & Localization

- [x] 2.1 Add forum-specific localization keys to `app_en.arb`.
- [x] 2.2 Register forum routes in `app_router.dart`.
- [x] 2.3 Connect `DashboardDrawer` to the `/forum` route.

## 3. UI Implementation (Skeletons)

- [x] 3.1 Implement `ForumCourseSelectionScreen` inside `packages/forum` using `AppHeader` and `AppCard`.
- [x] 3.2 Implement `ForumPostsListScreen` inside `packages/forum` with discussion thread items and status badges.
- [x] 3.3 Verify design system compliance and remove any lingering Material dependencies.
