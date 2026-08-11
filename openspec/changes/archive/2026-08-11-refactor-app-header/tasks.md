## 1. Decouple AI Screen

- [x] 1.1 Replace `AppHeader` in `packages/core/lib/screens/ai_screen.dart` with a static hardcoded header mirroring the `StudyScreen` layout.

## 2. Refactor AppHeader

- [x] 2.1 Update `packages/core/lib/widgets/app_header.dart` to use `card` default background color.
- [x] 2.2 Update `AppHeader` title text to use `AppText.title` instead of `AppText.headline`.
- [x] 2.3 Refactor `AppHeader` layout to wrap the internal row in a `Column` and add an optional `bottomContent` widget below the row.

## 3. Migrate Drawer Screens

- [x] 3.1 Replace static sliding header in `packages/core/lib/widgets/app_drawer.dart` with the new `AppHeader`.
- [x] 3.2 Refactor bookmarks screen to use `AppHeader` (and remove `BookmarksHeader` if applicable).
- [x] 3.3 Refactor downloads screen to use `AppHeader` (and remove `DownloadsHeader` if applicable).
- [x] 3.4 Refactor forum/doubts screens to use `AppHeader` (and remove `ForumHeader` if applicable).
- [x] 3.5 Refactor `packages/testpress/lib/screens/announcements/announcements_list_screen.dart` to replace its static container header with `AppHeader`.

- [x] 3.6 Refactor Analytics screens (`packages/exams/lib/screens/subject_analytics/`) to replace their custom container headers with `AppHeader`.
