## 1. Core Implementation

- [x] 1.1 Modify `ExamPrescreen` in `packages/exams/lib/screens/exam_prescreen.dart` to wrap the options column with a unified `Skeletonizer` controlled by `isMetadataLoading`
- [x] 1.2 Disable "Start Exam Online" click interaction inside the `onTap` callback when `isMetadataLoading` is true
- [x] 1.3 Add `chapterTitle` placeholder to `_skeletonLessons` in `packages/courses/lib/screens/chapters_list_page.dart`
- [x] 1.4 Update `LessonListItem` in `packages/courses/lib/widgets/lesson_list_item.dart` to hide duration completely


## 2. Verification

- [x] 2.1 Run `flutter analyze` in the repository to ensure there are no compilation errors or lints introduced

