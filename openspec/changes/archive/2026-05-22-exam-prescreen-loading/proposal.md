## Why

Currently, when entering the exam pre-screen, we show a shimmer skeleton only for the question count, duration, and marks. While the metadata is still loading in the background, the user can still click the "Start Exam Online" button. This can cause issues or errors because the actual exam details have not finished loading yet.

## What Changes

- Show a unified shimmer skeleton using `Skeletonizer` for the entire options and details card area (including Title, details row, and the action button) while detailed metadata is still loading (`isMetadataLoading` is true).
- Disable/block the "Start Exam Online" option button's tap interaction while `isMetadataLoading` is true, preventing premature clicks and potential player launch failures.
- Align lesson filtered list shimmer skeleton cards with high-fidelity chapter cards by ensuring `_skeletonLessons` includes placeholder `chapterTitle` content, which prevents layout/height changes and maintains structural alignment.
- Hide duration metadata inside `LessonListItem` so that duration is not shown in the filtered view.

## Capabilities

### New Capabilities

<!-- None -->

### Modified Capabilities

- `shimmer-loading-infrastructure`: Enhance the loading state of the exam pre-screen by displaying a beautiful skeleton shimmer over the entire options/details container when metadata is fetching.

## Impact

- `packages/exams/lib/screens/exam_prescreen.dart`: Update `ExamPrescreen` to render a card-wide `Skeletonizer` shimmer when `isMetadataLoading` is true and disable interactions.
- `packages/courses/lib/screens/chapters_list_page.dart`: Update `_skeletonLessons` to include `chapterTitle` placeholder content.
- `packages/courses/lib/widgets/lesson_list_item.dart`: Update `LessonListItem` to hide duration completely.



