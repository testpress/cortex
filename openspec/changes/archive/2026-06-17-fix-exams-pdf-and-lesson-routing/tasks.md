## 1. Implement Exams Tab Lesson Routing

- [x] 1.1 Add required imports to `exams_routes.dart` (`flutter_riverpod.dart` and `material.dart`)
- [x] 1.2 Implement the private `_ExamLessonRedirector` widget class at the bottom of `exams_routes.dart`
- [x] 1.3 Add the `lesson/:id` route under the `/exams` base route in `exams_routes.dart`
- [x] 1.4 Update the `onLessonClick` logic in the `ChapterDetailPage` route configuration to navigate to `/exams/lesson/${lesson.id}` for non-exam lessons

## 2. Verification

- [x] 2.1 Verify that the app builds and there are no compilation or routing configuration errors
- [x] 2.2 Verify that tests pass successfully in packages
