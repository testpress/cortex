## 1. Implement AutoPlay Logic

- [x] 1.1 Locate the video completion handler (e.g., in `CustomVideoPlayer` or `LessonOrchestrator`).
- [x] 1.2 Update the handler to read the `autoPlayNext` setting from `SettingsProvider`.
- [x] 1.3 If the setting is enabled, trigger the same sequential navigation action as the "Next" button.
- [x] 1.4 Ensure edge cases (like the last lesson in a chapter) are handled gracefully (e.g., skip auto-navigation if no next lesson exists).
