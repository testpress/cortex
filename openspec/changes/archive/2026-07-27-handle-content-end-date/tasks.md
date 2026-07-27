## 1. Model Updates

- [x] 1.1 Update `LessonDto` in `package:core` to add `end` (String) and `hasEnded` (bool) properties.
- [x] 1.2 Update `Lesson` domain model in `package:courses` to add `end` (String) and `hasEnded` (bool) properties.
- [x] 1.3 Update `LessonsTable` in `package:core/lib/data/db/tables/lessons_table.dart` to include `end` and `hasEnded` columns.
- [x] 1.4 Run drift generator `dart run build_runner build -d` to generate database schema.
- [x] 1.5 Update `LessonDto._parseBase` in `package:core/lib/data/models/lesson_dto.dart` to parse `end` and `has_ended` from the API response JSON.

## 2. Access Control Implementation

- [x] 2.1 Identify the widget handling content selection/clicks (e.g., `study_content_list.dart` or `chapter_content_item.dart`).
- [x] 2.2 Add logic to check if `lesson.hasEnded` is true before navigating.
- [x] 2.3 Show a toast message ("Your access to this content has ended!") and abort navigation when `hasEnded` is true.

## 3. UI Representation

- [x] 3.1 Update the list item widget (e.g., `ChapterContentItem`) to conditionally render a lock icon when `lesson.hasEnded` is true.
- [x] 3.2 Parse the `end` date string into a readable format and display "Access expired on <end_date>" alongside the lock icon.
