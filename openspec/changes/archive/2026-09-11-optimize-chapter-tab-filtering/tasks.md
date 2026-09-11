# Implementation Tasks

- [x] 1. Update `chapterStatusFilterProvider` in `packages/courses/lib/widgets/chapter_status_filter_bar.dart` to use `StateProvider.autoDispose`.
- [x] 2. Update `ChapterDetailPage` in `packages/courses/lib/screens/chapter_detail_page.dart` to only show skeleton loaders when `chapter.lessons.isEmpty` during syncing.
- [x] 3. Create widget tests in `packages/courses/test/screens/chapter_detail_page_test.dart` to verify tab switching and autoDispose behavior.
- [x] 4. Run tests and verify all tests pass.
