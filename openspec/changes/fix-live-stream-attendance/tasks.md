## 1. Live Stream Viewer Update

- [x] 1.1 Pass `lessonId: lesson.id`, `thumbnailUrl: lesson.image`, and `onComplete: widget.onComplete` to `CustomVideoPlayer` in `packages/courses/lib/widgets/lesson_detail/live_stream_viewer.dart`.

## 2. Test Verification

- [x] 2.1 Add widget tests in `packages/courses/test/widgets/live_stream_viewer_test.dart` asserting `CustomVideoPlayer` receives `lessonId` when rendering TPStreams live streams.
- [x] 2.2 Run courses package test suite to verify tests pass without regression.
