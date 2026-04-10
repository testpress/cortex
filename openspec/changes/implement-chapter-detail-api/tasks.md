## 1. API Integration

- [x] 1.1 Add `refreshCourseContents` method to `CourseRepository`.
- [x] 1.2 Implement the `/api/v3/courses/{id}/contents/` network call in `CourseRepository`.
- [x] 1.3 Implement network calls for `/running_contents/`, `/upcoming_contents/`, and `/content_attempts/`.
- [x] 1.4 Add database upsert logic to store all fetched contents and their statuses into `lessonsTable`.

## 2. Filtering Logic

- [x] 2.1 Update `chapterDetailProvider` to fetch and intersect chapter contents with Running/Upcoming/History API data.
- [x] 2.2 Update `ChapterDetailPage` to display the specific Running, Upcoming, and History status chips.
- [x] 2.3 Ensure filter selection reactively updates the displayed contents for the current leaf chapter.

## 3. Verification

- [x] 3.1 Verify that clicking a leaf chapter shows the "Running", "Upcoming", and "History" filters.
- [x] 3.2 Verify that the content list correctly reflects data from the `/running_contents/`, `/upcoming_contents/`, and `/content_attempts/` APIs.

## 4. Bug Fixes (Cross-Chapter Leakage)

- [x] 4.1 Update `LessonDto.fromJson` to handle nested `chapter` objects correctly.
- [x] 4.2 Fix `HttpDataSource._mapLessons` to ignore curriculum items of type `chapter`.
- [x] 4.3 Ensure `getLessons(chapterId)` enforces the chapter ID on returned lessons if missing.
- [x] 4.4 Refactor `CourseRepository.refreshCourseContents` to prioritize existing chapter associations.
