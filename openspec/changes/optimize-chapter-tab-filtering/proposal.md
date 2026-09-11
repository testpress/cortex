## Why

When switching between status filter tabs (All, Running, Upcoming, History) in the chapter detail screen, users and testers may observe a 1–2 second skeleton shimmer "delay" if background status synchronization is in flight.

This happens because `ChapterDetailPage` checks `if (isSyncing && filteredLessons.isEmpty)` to render 5 skeleton cards. If a chapter already has local/cached lessons but none match the selected tab (or before background status flags update), the UI replaces content with skeleton placeholders before snapping back to the real list or empty state. Additionally, `chapterStatusFilterProvider` is not auto-disposed, which can cause tab filter selections to persist across different chapters.

## What Changes

- Decouple skeleton loader rendering from tab-filtered empty states: only show skeleton shimmer if the entire chapter has no lessons loaded (`isSyncing && chapter.lessons.isEmpty`).
- Render empty states immediately when `chapter.lessons.isNotEmpty` but `filteredLessons.isEmpty`.
- Make `chapterStatusFilterProvider` auto-disposed (`StateProvider.autoDispose`) so each chapter navigation resets the active filter to `All`.
- Add unit/widget tests to verify tab filtering and auto-dispose behavior.

## Capabilities

### Modified Capabilities
- `lms-study-chapter-detail`: Update tab filtering behavior to eliminate skeleton flicker when switching tabs on loaded chapters and ensure filter state resets between chapter visits.

## Impact
- `packages/courses/lib/screens/chapter_detail_page.dart`
- `packages/courses/lib/widgets/chapter_status_filter_bar.dart`
- `packages/courses/test/screens/chapter_detail_page_test.dart`
