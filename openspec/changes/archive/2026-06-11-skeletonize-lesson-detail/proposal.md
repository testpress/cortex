## Why

The lesson detail screen currently displays a generic circular loading indicator (`AppLoadingIndicator`) while content is fetching. To improve perceived performance and create a more polished, modern user experience, we should switch to using skeleton loading screens. This aligns with other areas of the application using `skeletonizer`.

## What Changes

- Replace the `AppLoadingIndicator` in `LessonDetailOrchestrator` with a skeleton loader.
- Create skeleton mock layouts (bones) for specialized lesson types that lack natural text/icon shapes for `skeletonizer` to parse, specifically for PDF viewers, video players, and HTML embeds.
- Introduce a `LessonDetailSkeleton` widget that adapts its skeleton structure based on the `LessonType`.

## Capabilities

### New Capabilities

- `lesson-detail-loading-experience`: Defines the skeleton loader structure and mock bones for different lesson content types (PDF, Video, Embeds) in the lesson detail orchestrator.

### Modified Capabilities

- `lesson-content-orchestration`: Updating the initial loading state requirement to use skeleton screens instead of standard circular progress indicators.

## Impact

- `LessonDetailOrchestrator` (`packages/courses/lib/screens/lesson_detail_orchestrator.dart`)
- New widget: `LessonDetailSkeleton` (likely in `packages/courses/lib/widgets/lesson_detail/`)
- Relies on the existing `skeletonizer` package already used in the workspace.
