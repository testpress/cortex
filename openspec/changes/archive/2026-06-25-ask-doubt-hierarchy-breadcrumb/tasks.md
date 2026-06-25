## 1. UI Implementation

- [x] 1.1 Implement `DoubtContextBadge` using a simple `Row` with `Flexible` and `TextOverflow.ellipsis`.
- [x] 1.2 Ensure Line 1 shows Course Name and Chapter Name separated by a chevron.
- [x] 1.3 Ensure Line 2 shows the appropriate content-type icon and the Topic Name.

## 2. Data Integration

- [x] 2.1 In `AskDoubtFormScreen`, pass the `chapterTitle` from the lesson data, and use `courseDetailProvider(courseId)` to get the course title.
- [x] 2.2 In `DoubtDetailScreen`, use the `CourseRepository.getLessonDetails(lessonId)` helper to populate the badge.

## 3. Verification

- [x] 3.1 Launch Ask a Doubt from a standard video lesson and verify the simple 2-line rendering.
- [x] 3.2 Verify the breadcrumb renders correctly on the Doubt Detail screen.
