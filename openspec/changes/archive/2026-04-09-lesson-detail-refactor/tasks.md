## 1. Standardize Naming

- [x] 1.1 Rename `video_lesson_detail_page.dart` to `video_lesson_detail_screen.dart`.
- [x] 1.2 Update imports and router definitions in `packages/testpress/lib/navigation/app_router.dart` for the renamed video screen.

## 2. Isolate PDF Content

- [x] 2.1 Create `pdf_lesson_detail_screen.dart` with state management for PDF rendering and reading progress.
- [x] 2.2 Move PDF-specific logic (AppPdfViewer) to the new screen.
- [x] 2.3 Ensure PDF screen handles its own subject-specific theme and custom header.

## 3. Implement Router-First Orchestration

- [x] 3.1 Update `app_router.dart` builders to map `/lesson/:id` directly to `PdfLessonDetailScreen`.
- [x] 3.2 Update `app_router.dart` to share the `lessonDetailProvider` loading logic across all lesson types.
- [x] 3.3 Revert shared UI components: ensure `VideoLessonDetailScreen` keeps its own custom header.
- [x] 3.4 **Delete** the redundant `LessonDetailScreen` switcher entirely.

## 4. Verification & Testing

- [x] 4.1 Verify that `/study/lesson/thermo-1` triggers the new `PdfLessonDetailScreen` directly.
- [x] 4.2 Verify that `/study/video/thermo-2` triggers the refactored `VideoLessonDetailScreen` directly.
