## 1. Lesson Viewers initial position reset

- [x] 1.1 In `video_lesson_viewer.dart`, reset `initialPos` to `0.0` if `widget.lesson.progressStatus == LessonProgressStatus.completed`.
- [x] 1.2 In `video_lesson_detail_screen.dart`, reset `initialPos` to `0.0` if `widget.lesson.progressStatus == LessonProgressStatus.completed`.

## 2. CustomVideoPlayer initial completion guard

- [x] 2.1 In `custom_video_player.dart`, define the `_shouldIgnoreInitialCompletion` flag in `CustomVideoPlayerState`.
- [x] 2.2 In `custom_video_player.dart`, refactor the `_hasSeekedToInitial` logic to safely set `_hasSeekedToInitial = true` when duration is loaded, and set `_shouldIgnoreInitialCompletion = true` if `targetSeek` is near the end.
- [x] 2.3 In `custom_video_player.dart` controller listener, reset `_shouldIgnoreInitialCompletion` to `false` when `currentPos < duration - 2.0`.
- [x] 2.4 In `custom_video_player.dart` controller listener, guard `widget.onComplete?.call()` to only run when `!_shouldIgnoreInitialCompletion`.
