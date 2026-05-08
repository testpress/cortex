# Proposal: Optimize Course Sorting and Synchronization

## Objective
Ensure reliable course ordering and data synchronization between the backend and local database, resolving UI discrepancies and performance lag in filtering.

## Problem
1. **Unreliable Sorting**: Synthetic page-based sorting caused courses to appear out of order compared to the backend.
2. **Sync Dependency**: Exam-containing courses were only visible after the Study tab performed a sync because the filtering logic was not robust.
3. **Filtering Lag**: Applying curriculum filters (Videos, Tests) resulted in a 30-second blank screen while the background sync was running.
4. **UI Noise**: Study-specific filters were visible in the Exams tab, leading to a cluttered and confusing user experience.

## What Changes
- Integrate native backend `"order"` field into the database schema (`orderIndex`).
- Update `HttpDataSource` to support multi-parameter tag filtering (`?tags=exams&tags=classes`).
- Implement real-time sync status tracking to show loading indicators during background fetches.
- Refactor `ChaptersListPage` and `ChapterDetailPage` to support conditional filter visibility and dynamic navigation base paths.
- Update `AppRouter` to link real Test and Assessment detail screens in the Exams branch.

## Capabilities

### New Capabilities
- `sync-status-tracking`: Real-time tracking of course synchronization states to provide better UI feedback.
- `recursive-level-sync`: Targeted synchronization of chapter contents to improve immediate visibility of nested materials.

### Modified Capabilities
- `course-sorting`: Transitioned from page-based to native order-based sorting.
- `curriculum-filtering`: Refined filter logic for "Lessons" and tab-specific visibility.

## Impact
- **Database**: Adds `orderIndex` to `CoursesTable` and implements `isSyncing` tracking in `CourseRepository`.
- **API**: Updates `HttpDataSource` and `CourseDto` to handle native ordering and multi-tag queries.
- **UI**: Significant updates to `ChaptersListPage`, `ChapterDetailPage`, and navigation shell.
