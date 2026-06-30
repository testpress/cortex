## 1. UI Implementation

- [x] 1.1 Ensure `DoubtContextBadge` renders the 2-level breadcrumb using a simple `Row` with `Flexible` and `TextOverflow.ellipsis`.
- [x] 1.2 Ensure the top line correctly shows Course Name and Chapter Name separated by a chevron, fixing the bug where it was blank.
- [x] 1.3 Ensure the lesson name continues to render below the breadcrumb inside the distinct Context Pill.

## 2. Data Integration

- [x] 2.1 Update `LessonDto` to parse `chapter_slug` from API responses.
- [x] 2.2 Add `getChapterDetail(slug)` to `DataSource` and `HttpDataSource`.
- [x] 2.3 Update `CourseRepository.refreshLesson` to hydrate missing chapters using a non-blocking background fetch.
- [x] 2.4 In `AskDoubtFormScreen` and `DoubtDetailScreen`, rely cleanly on `CourseRepository.getLessonDetails(lessonId)` for robust local data retrieval.

## 3. Verification

- [x] 3.1 Launch Ask a Doubt from a standard video lesson and verify the simple 2-line rendering.
- [x] 3.2 Verify the breadcrumb renders correctly on the Doubt Detail screen.
