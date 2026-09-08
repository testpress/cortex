## 1. Core Model Data Sync Fix

- [x] 1.1 Update `LessonDto.mergeWith` in `packages/core/lib/data/models/lesson_dto.dart` so that `isDetailFetched` makes `isScheduled` and `scheduledMessage` from `this` authoritative over cached `other` values.
- [x] 1.2 Add unit tests for `LessonDto.mergeWith` in `packages/core/test/data/models/lesson_dto_test.dart` testing merging of scheduled to active states.

## 2. Scheduled Live Stream Auto-Refresh

- [x] 2.1 Update `LiveStreamViewer` in `packages/courses/lib/widgets/lesson_detail/live_stream_viewer.dart` to run a 5-second periodic polling timer while `isScheduled == true`.
- [x] 2.2 Add/update widget tests for `LiveStreamViewer` in `packages/courses/test/widgets/live_stream_viewer_test.dart` verifying polling and state update transitions.
