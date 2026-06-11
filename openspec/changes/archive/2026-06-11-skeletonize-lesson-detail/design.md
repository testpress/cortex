## Context

Currently, the `LessonDetailOrchestrator` displays a simple `AppLoadingIndicator` when the `lesson` object is not fully populated (`!lesson.isComplete`). This doesn't provide a smooth loading experience, especially when navigating between lessons. The rest of the app relies heavily on `skeletonizer` for polished loading states.

## Goals / Non-Goals

**Goals:**
- Replace the `AppLoadingIndicator` with a skeleton layout.
- Create a reusable `LessonDetailSkeleton` widget that produces mock "bones" based on the `LessonType`.
- Handle complex viewers (PDF, Video, LiveStream, Embeds) which cannot automatically generate bones from real text/icons, by rendering large mock `Container` widgets wrapped with `Skeleton.replace` or `Bone` elements.

**Non-Goals:**
- Altering the actual viewer implementations (`AppPdfViewer`, `VideoLessonViewer`, etc.).
- Changing how lesson metadata is fetched.
- **The skeleton layout must explicitly NOT be scrollable.** It will rely on static layouts (`Column`, `Expanded`, `SizedBox`) to fill the viewport securely.

## Decisions

- **Dedicated Skeleton Widget:** We will create `LessonDetailSkeleton` inside `packages/courses/lib/widgets/lesson_detail/lesson_detail_skeleton.dart`. This widget will handle deciding the shape of the skeleton.
- **Handling Complex Media:** Since `skeletonizer` primarily relies on textual elements, we will use mock containers (e.g., `Bone.container` or simple grey `Container` elements) to represent video players and PDF viewers. For example, a 16:9 box for a video player, and a full-screen box for a PDF. 
- **Type-Aware Skeletons:** `LessonDetailSkeleton` will accept an optional `LessonType?`. If known, it will return the specific layout. If unknown or not provided, it will return a generic layout (e.g., just a header and a large content box).

## Risks / Trade-offs

- **Risk:** Maintaining skeleton layouts. Whenever the `LessonDetailShell` or viewers change visually, the mock bones might drift from the real UI layout. 
  - *Mitigation:* Keep the skeleton layouts as generic as possible (e.g., just a single large bounding box for content rather than intricately copying player controls).
