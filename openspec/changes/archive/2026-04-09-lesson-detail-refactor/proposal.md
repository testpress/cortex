## Why

The current lesson detail implementation is fragmented. The `LessonDetailScreen` was overloaded with PDF-specific logic while containing placeholders for video, whereas `VideoLessonDetailScreen` exists separately with its own header/footer implementation. We need a clean way to route between different lesson content types (PDF, Video, Test, Assessment) while maintaining consistent data retrieval logic without adding unnecessary "switcher" UI layers.

## What Changes

- **Router Orchestration**: Move content-switching logic from the widget layer into the `app_router.dart`. The router will now act as the single brain for identifying lesson types and pushing to the correct specialized screen.
- **Isolation**: Extract all PDF-specific rendering from the legacy `LessonDetailScreen` into a dedicated `PdfLessonDetailScreen`.
- **Standardization**: Rename `video_lesson_detail_page.dart` to `video_lesson_detail_screen.dart` for naming consistency.
- **Redundancy Removal**: **Delete** the redundant `LessonDetailScreen` entirely to follow the "Direct Destination Screen" pattern.

## Capabilities

### New Capabilities
- `lesson-router-orchestration`: A unified router-based strategy to identify lesson types (PDF, Video, etc.) and delegate rendering directly to specialized screens while sharing common data providers.

### Modified Capabilities
- `lesson-pdf-playback`: Update to reflect that PDF playback now lives in its own isolated `PdfLessonDetailScreen`.

## Impact

- `packages/courses/lib/screens/lesson_detail_screen.dart`: **Deleted** as redundant.
- `packages/courses/lib/screens/pdf_lesson_detail_screen.dart`: New file for isolated PDF rendering.
- `packages/courses/lib/screens/video_lesson_detail_screen.dart`: Standardized naming and isolated custom header.
- `packages/testpress/lib/navigation/app_router.dart`: Updated to map `/lesson/:id` directly to `PdfLessonDetailScreen`.
