## Why

The current loading screens for the course chapter list and the chapter's lesson list use a standard circular loading indicator. Replacing these generic indicators with customized, high-fidelity structural shimmer skeletons powered by `Skeletonizer` will improve the visual continuity, aesthetics, and perceived loading performance of the learning curriculum pages.

## What Changes

*   Introduce skeleton placeholder structures for chapters and lessons that mirror their final rendered layout.
*   Update the chapter list screen (`ChaptersListPage`) to replace the initial central spinner with an aesthetic skeleton list during initial load/sync.
*   Update the chapter detail screen (`ChapterDetailPage`) to replace its initial central spinner with skeletonized items.
*   Refactor `ChapterCurriculumItem`, `LessonListItem`, and `ChapterContentItem` to support skeletonization via local `Skeletonizer` configuration using customized Design tokens.
*   Generate appropriate mock DTO lists (`_skeletonChapters`, `_skeletonLessons`) populated with natural title lengths to avoid layout shifts.

## Capabilities

### New Capabilities

### Modified Capabilities
- `shimmer-loading-infrastructure`: Standardized loading representation and layout behavior for curriculum structures.

## Impact

*   `packages/courses/lib/screens/chapters_list_page.dart`: Replace loading indicator with skeleton chapter list.
*   `packages/courses/lib/screens/chapter_detail_page.dart`: Replace loading indicator with skeleton lesson/content list.
*   `packages/courses/lib/widgets/chapter_curriculum_item.dart`: Integrate local `Skeletonizer` config using `design.colors.skeleton`/`onSkeleton`.
*   `packages/courses/lib/widgets/lesson_list_item.dart`: Integrate local `Skeletonizer` config using `design.colors.skeleton`/`onSkeleton`.
*   `packages/courses/lib/widgets/chapter_content_item.dart`: Integrate local `Skeletonizer` config using `design.colors.skeleton`/`onSkeleton`.
