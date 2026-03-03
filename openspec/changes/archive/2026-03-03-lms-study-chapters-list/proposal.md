## Why

Currently, the study experience in the Cortex app only supports a top-level course list and a flat, filtered lesson view. As courses grow in complexity, students need a hierarchical view (the curriculum) to navigate through chapters and lessons systematically. This change introduces the `ChaptersListPage` to provide that structural navigation.

## What Changes

- **Curriculum View**: Implement a new `ChaptersListPage` that displays the full list of chapters for a selected course.
- **Chapter Navigation**: Update `CourseCard` to navigate to the `ChaptersListPage` upon being tapped.
- **Content Filtering**: Implement a tab-based filtering system (All, Lessons, Videos, Assessments, Tests) within the chapter list, matching the reference implementation.
- **Progress Tracking**: Show visual indicators for chapter and lesson completion status (Completed, In Progress, Locked).
- **Back Navigation**: Ensure seamless return navigation from the chapter list back to the main study screen.

## Capabilities

### New Capabilities
- `lms-study-chapters-list`: Implementation of the chapter-based curriculum navigation and content filtering interface.

### Modified Capabilities
- `lms-navigation-shell`: Update the router to support the new curriculum route with course parameters.

## Impact

- **`packages/courses`**: New screen (`ChaptersListPage`) and supporting widgets (accordion items, status chips).
- **`packages/testpress`**: Updates to `app_router.dart` for the new route.
- **`packages/data`**: Use existing `enrollmentProvider` and potentially new providers for chapter-specific details if needed.
