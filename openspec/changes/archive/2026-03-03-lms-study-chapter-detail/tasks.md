## 1. Data Models and Providers

- [x] 1.1 Ensure `Lesson` and `Chapter` models in `packages/courses` support `type`, `secondaryLabel`, and `duration`.
- [x] 1.2 Create a mock data provider for chapter content with varied lesson types and statuses.

## 2. UI Components

- [x] 2.1 Implement `ChapterDetailPage` with a sticky header containing the back button, chapter title, and stats.
- [x] 2.2 Implement status filter pills (`Running`, `Upcoming`, `History`) using a `StateProvider`.
- [x] 2.3 Create `ChapterContentItem` component to display individual lessons with consistent typography and shadows.
- [x] 2.4 Add dynamic icons (PlayCircle, FileText, etc.) for content types using `design.colors`.

## 3. Navigation and Integration

- [x] 3.1 Define the `/study/chapter/:chapterId` route in the application's router.
- [x] 3.2 Implement navigation callbacks to handle Lesson click and Back button.
- [x] 3.3 Update `ChapterCurriculumItem` in `packages/courses` to trigger navigation to the detailed view.
