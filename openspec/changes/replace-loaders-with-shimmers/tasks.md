## 1. Core Library Preparation

- [x] 1.1 Verify `Skeletonizer` availability in `courses`, `exams`, and `testpress` package pubspecs (add if missing).
- [x] 1.2 Define generic `_skeleton` constant instances for standard domain models (Course, Chapter, Lesson, Banner) to govern text length simulations.

## 2. Explore Section Migration

- [x] 2.1 Replace `AppLoadingIndicator` and empty spacing in `FeaturedCarousel` with `Skeletonizer` wrappers.
- [x] 2.2 Refactor `CourseDiscoveryList` and other Explore feed lists to handle empty-state loading by spawning 3-4 generic skeleton widgets instead of returning `SizedBox.shrink()`.
- [x] 2.3 Update `ShortLessonsSection` & `PopularTestsSection` in the Explore feed to support skeleton visualization.

## 3. Main Course View Updates

- [x] 3.1 Implement shimmering logic in `CourseListPage` / `StudyContentList` components.
- [x] 3.2 Ensure vertical grids render minimum 6 shimmer placeholder blocks until live streams emit initialized state.
