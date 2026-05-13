## Why

The goal is to transition the Info tab from its initial mock implementation to a fully integrated, production-ready feature using the real Testpress v3 API. This requires enabling support for the full `Chapters -> Lessons` course hierarchy and ensuring the Study and Info tabs maintain strict content separation by fixing a filtering flaw in the repository.

## What Changes

- **Real API Integration**: Transition the Info tab to fetch real data using the `tags=info` parameter.
- **Correct Tab Filtering**: Fix `watchStudyCourses` logic to conditionally exclude Info/Exam courses based on enabled tabs and preserve tab-specific visibility.
- **Hierarchical Content Support**: Update the Info detail screen to display the standard Course -> Chapters -> Lessons hierarchy using existing curriculum widgets.
- **Model Standardization**: Remove legacy `InfoCourse` and `InfoVideo` mock models in favor of standard `CourseDto`, `ChapterDto`, and `LessonDto`.

## Capabilities

### Modified Capabilities
- `info-page`: Transition from static mock content to a dynamic, hierarchical view powered by the real courses API.
- `course-api`: Enhanced repository logic for dedicated Info streams and corrected multi-tab filtering.

## Impact

- `packages/courses`: `CourseRepository` stream logic, `InfoPage` list rendering, and `InfoCourseDetailScreen` curriculum orchestration.
