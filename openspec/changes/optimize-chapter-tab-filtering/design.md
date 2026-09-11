# Design: Optimize Chapter Tab Filtering UX

## Context
In `ChapterDetailPage`, content status filtering allows users to toggle between `All`, `Running`, `Upcoming`, and `History`. While `initialSync` is updating lesson status flags in the background, filtering currently displays a skeleton shimmer whenever `filteredLessons.isEmpty`.

## Technical Strategy

1. **Rendering Condition in `ChapterDetailPage`**:
   - Change `isSyncing && filteredLessons.isEmpty` to `isSyncing && chapter.lessons.isEmpty`.
   - When `chapter.lessons.isNotEmpty`, the list directly renders `filteredLessons`. If `filteredLessons.isEmpty`, render `l10n.chapterNoContent` immediately.
   - When background status sync finishes, Drift/Riverpod stream emits updated `LessonDto`s with new status flags, seamlessly repopulating the filtered list without UI blocking.

2. **Provider Scope in `chapter_status_filter_bar.dart`**:
   - Update `chapterStatusFilterProvider` to `StateProvider.autoDispose<ChapterStatusFilter>`.
   - Ensures filter selection resets upon exiting/navigating across chapters.

3. **Testing**:
   - Add widget tests covering tab switching without skeleton flicker and verifying filter reset on navigation.
