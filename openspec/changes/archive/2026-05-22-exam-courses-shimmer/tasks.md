## 1. Core Implementation

- [x] 1.1 Define `_skeletonCourses` mock list in `packages/exams/lib/screens/exams_screen.dart`.
- [x] 1.2 Update the `loading:` branch of `examCoursesState.when` in `ExamsScreen` to render `_skeletonCourses` list with `isSkeleton: true`.
- [x] 1.3 Update the `data:` branch of `examCoursesState.when` in `ExamsScreen` to render skeleton cards when `isSyncing` is true and data is empty.
- [x] 1.4 Update the `isSyncingMore` pagination indicator in `ExamsScreen` to render a trailing shimmer `CourseCard`.

## 2. Verification

- [x] 2.1 Verify that the exams screen compiles and runs.
