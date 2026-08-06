## Why

Pull-to-refresh is available on all top-level tab screens (Study, Exams, Info) but absent from the subfolder screens users drill into — the chapters list and the chapter detail page. Once a user navigates into a course, there is no standard way to reload the content without backing all the way out and re-entering.

## What Changes

- Add a pull-to-refresh gesture to the Chapters List page (covering both chapters and lessons).
- Add a pull-to-refresh gesture to the Chapter Detail page to sync latest progress.
- Ensure the pull-to-refresh gesture works even when a folder is completely empty or only has a few items.
- The `ExamPrescreen` screen is intentionally excluded, as its state is static and reloading provides no value.

## Capabilities

### New Capabilities

- `subfolder-pull-to-refresh`: Adds manual pull-to-refresh gesture to the chapters list page and the chapter detail page across all sections (Study, Exams, Info) that use these shared screens.

### Modified Capabilities

- `lms-study-chapters-list`: Adding a pull-to-refresh requirement to the `ChaptersListPage` screen.
- `chapter-detail`: Adding a pull-to-refresh requirement to the `ChapterDetailPage` screen.

## Impact

- `packages/courses/lib/screens/chapters_list_page.dart` — wraps content area with `RefreshIndicator`; updates scroll physics; fixes empty state scrollability.
- `packages/courses/lib/screens/chapter_detail_page.dart` — wraps content area with `RefreshIndicator`; updates scroll physics.
- No new providers, APIs, or dependencies introduced. Reuses existing sync methods already called on screen open.
- Change applies automatically to all routes that render these shared screens: `/study/…`, `/exams/…`, `/info/…`.
