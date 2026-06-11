## 1. Create Skeleton Components

- [x] 1.1 Create `LessonDetailSkeleton` widget in `packages/courses/lib/widgets/lesson_detail/lesson_detail_skeleton.dart`.
- [x] 1.2 Implement a mock full-screen container bone for `LessonType.pdf` inside `LessonDetailSkeleton`.
- [x] 1.3 Implement a 16:9 mock container bone for `LessonType.video` and `LessonType.liveStream` inside `LessonDetailSkeleton`.
- [x] 1.4 Implement a generic skeleton layout (header + large content box) as the fallback for unknown or other types.

## 2. Integration with Orchestrator

- [x] 2.1 Import `LessonDetailSkeleton` and `skeletonizer` in `packages/courses/lib/screens/lesson_detail_orchestrator.dart`.
- [x] 2.2 Replace the `AppLoadingIndicator` returned when `!lesson.isComplete` with a `Skeletonizer` widget wrapping the `LessonDetailSkeleton`.
- [x] 2.3 Pass `lesson.type` to `LessonDetailSkeleton` to render the correct bones.
