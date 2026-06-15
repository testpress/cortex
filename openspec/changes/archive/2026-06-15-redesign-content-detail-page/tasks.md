## 1. Content Detail Page Adjustments

- [x] 1.1 Locate the Next and Previous buttons component on the content detail page in `packages/courses`.
- [x] 1.2 Modify the buttons to be smaller and inline, mirroring the exams UI style.
- [x] 1.3 Remove the large footer block that currently surrounds these buttons.
- [x] 1.4 Ensure responsive layout padding is maintained without the footer.

## 2. Lesson Detail Page Adjustments

- [x] 2.1 Locate the header component (`AppHeader` or `AppBar` equivalent) used on the lesson detail page in `packages/courses`.
- [x] 2.2 Adjust or remove the excess left padding on the `leading` back button to align it visually with other application headers.
- [x] 2.3 Refactor `LessonDetailHeader` to use a Container with `design.colors.card` and `safeArea.top + 12` padding (mirroring `CurriculumHeader`).
- [x] 2.4 Update `LessonDetailHeader` to include the `lessonTitle` in a two-line layout.
- [x] 2.5 Refactor `LessonDetailShell`'s header to follow the same unified header layout.
- [x] 2.6 Refactor `VideoLessonDetailScreen`'s header to follow the same unified header layout.
- [x] 2.7 Remove the separate lesson titles from the body of the lesson detail screens since they are now in the header.

## 3. Verification

- [x] 3.1 Verify UI changes for content detail page next/previous buttons visually.
- [x] 3.2 Verify lesson detail page header back button alignment visually.
