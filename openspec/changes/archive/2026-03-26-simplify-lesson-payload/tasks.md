## 1. Data Layer Refactor (Core & Courses)

- [x] 1.1 Add `syncfusion_flutter_pdfviewer` dependency to `packages/courses/pubspec.yaml`.
- [x] 1.2 Modify `LessonDto` in `packages/core/lib/data/models/lesson_dto.dart` to replace `content` list with a single `String? contentUrl`.
- [x] 1.3 Update `LessonsTable` in `packages/core/lib/data/db/tables/lessons_table.dart` to replace `contentJson` with a `contentUrl` text column.
- [x] 1.4 Update `CourseRepository` mapping logic in `packages/courses/lib/repositories/course_repository.dart` to use the new `contentUrl` field.
- [x] 1.5 Run `build_runner` in the `core` package to regenerate the Drift database mapping.

## 2. Domain & Mock Data Cleanup

- [x] 2.1 Refactor `Lesson` domain model in `packages/courses/lib/models/course_content.dart` to replace `content` list with `contentUrl`.
- [x] 2.2 Delete all `LessonContentItem` domain models and `LessonContentItemDto` rich-text atom definitions.
- [x] 2.3 Update `MockDataSource` in `packages/core/lib/data/sources/mock_data_source.dart` to populate `contentUrl` with sample PDF and Video links.

## 3. UI Implementation (Courses)

- [x] 3.1 Implement a robust `AppPdfViewer` widget in `packages/courses/lib/widgets/lesson_detail/pdf_viewer.dart` using `SfPdfViewer.network`.
- [x] 3.2 Refactor `LessonDetailScreen` to rendered the PDF viewer when `lesson.type` is `pdf`.
- [x] 3.3 Remove deprecated rich-text rendering widgets (Headings, Paragraphs, Lists, Callouts) from `packages/courses/lib/widgets/lesson_detail/content_widgets.dart`.

## 4. Verification

- [x] 4.1 Verify that PDF lessons correctly render the remote document using the new viewer.
- [x] 4.2 Verify that Video lessons correctly load their URL from the flattened `contentUrl` field.
- [x] 4.3 Ensure that sequential navigation between lessons still behaves correctly with the new model.
