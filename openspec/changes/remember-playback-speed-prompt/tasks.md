## 1. Core Data Layer

- [x] 1.1 Create `PlaybackSpeedPromptDismissed` provider in `packages/core/lib/data/providers/playback_speed_prompt_provider.dart` backed by `SharedPreferences`
- [x] 1.2 Export `playback_speed_prompt_provider.dart` in `packages/core/lib/data/data.dart`
- [x] 1.3 Implement `enableRememberPlaybackSpeedAndSave` and reset hook in `PlaybackSettingsNotifier`
- [x] 1.4 Run code generation for Riverpod provider parts

## 2. Video Player UI Integration

- [x] 2.1 Integrate playback speed change listener and contextual banner prompt in `VideoLessonViewer`
- [x] 2.2 Wire affirmative action ("Yes") to `enableRememberPlaybackSpeedAndSave`
- [x] 2.3 Wire dismissal action ("No") to `PlaybackSpeedPromptDismissed.dismiss()`

## 3. Verification & Testing

- [x] 3.1 Add widget tests in `video_lesson_viewer_test.dart` for prompt rendering, accepting, dismissing, and settings reset
- [x] 3.2 Verify all tests and static analysis pass across `packages/core` and `packages/courses`
