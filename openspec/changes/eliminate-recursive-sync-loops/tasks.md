## 1. Data Layer Enhancements

- [x] 1.1 Update `DataSource.getCourseContents` to return a `Stream<CourseCurriculumDto>` to support paginated streaming.
- [x] 1.2 Modify `HttpDataSource.getCourseContents` to yield each page incrementally instead of using a blocking `while` loop.
- [x] 1.3 Ensure `getRunningContents`, `getUpcomingContents`, and `getContentAttempts` in `HttpDataSource` properly utilize the `chapterId` filter.

## 2. Repository Logic Optimization

- [x] 2.1 Refactor `CourseRepository.watchCourseCurriculum` to yield current database state before initiating network synchronization.
- [x] 2.2 Update `CourseRepository.refreshCourseContents` to process the paginated stream and persist pages incrementally.
- [x] 2.3 Refactor `CourseRepository.refreshChapters` to support lazy level-by-level synchronization with `isChaptersSynced` tracking.

## 3. Provider & UI Refinement

- [x] 3.1 Update `subChapters` provider in `course_detail_provider.dart` to implement the SWR pattern (cache-first + background refresh).
- [x] 3.2 Remove the `_syncCurrentLevelRecursive` and recursive `addDescendants` logic from `ChaptersListPage`.
- [x] 3.3 Decouple `CourseListProvider` from curriculum-level syncs to prevent redundant background traffic when browsing the library.
- [x] 3.4 Temporarily make `CurriculumFilter` in `ChaptersListPage` a no-op to clear the way for the next architectural scope.

## 4. Verification

- [x] 4.1 Verify that opening a course list does NOT trigger lesson-level API calls.
- [x] 4.2 Verify that navigating into a chapter folder triggers a background refresh only for that folder.
- [x] 4.3 Verify that cached curriculum data is displayed instantly upon navigation.
- [x] 4.4 Verify that the 10+ sequential pagination loop is replaced by incremental, non-blocking updates.
