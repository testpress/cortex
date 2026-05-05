## 1. Data Model & Repository

- [x] 1.1 Add `orderIndex` to `CoursesTable` in `AppDatabase` and handle migrations.
- [x] 1.2 Update `CourseDto` to parse native `"order"` from backend JSON.
- [x] 1.3 Implement `isSyncing` tracking in `CourseRepository` using standard Dart streams.
- [x] 1.4 Update `HttpDataSource` to support multi-parameter tag queries (`?tags=exams&tags=classes`).

## 2. Synchronization Logic

- [x] 2.1 Implement `courseSyncStatusProvider` to track real-time sync states.
- [x] 2.2 Add targeted recursive sync in `ChaptersListPage` to improve nested content visibility.
- [x] 2.3 Defer Master Sync in root `ChaptersListPage` until a specific content filter is selected.

## 3. UI & Routing

- [x] 3.1 Add `showFilters` and `basePath` parameters to `ChaptersListPage` and `ChapterDetailPage`.
- [x] 3.2 Implement smart loading indicators in `ChaptersListPage` that respect background sync states.
- [x] 3.3 Link real `TestDetailScreen` and `AssessmentDetailScreen` in `AppRouter` for the Exams branch.
- [x] 3.4 Refine "Lessons" filter logic to show all general content while excluding specialized categories.

## 4. Maintenance & Bug Fixes

- [x] 4.1 Fix missing `smooth_page_indicator` dependency in `packages/core`.
- [x] 4.2 Resolve duplicated `onTap` argument in `ChaptersListPage`.
- [x] 4.3 Synchronize dependencies for the `app` consumer shell.

## 5. Tag-based Filtering & Tab Logic

- [x] 5.1 Update `CourseList` to use tag ID `1` (Study) for API requests.
- [x] 5.2 Update `ExamList` to use tag ID `2` (Tests) for API requests.
- [x] 5.3 Refactor `CourseRepository` filtering to use tag IDs (`1`, `2`, `81`) instead of hardcoded strings.
