## Context

Currently, the Exams tab displays a generic `AppLoadingIndicator` when loading exam courses or fetching more data. We need to implement a premium shimmer loading state using `Skeletonizer` and `CourseCard` to align with the design and layout of the Study tab.

## Goals / Non-Goals

**Goals:**
- Implement shimmer skeletons for exam courses loading state matching the study tab's course list.
- Use `Skeletonizer` and `CourseCard` with a local `_skeletonCourses` mock list to generate premium skeletons.
- Support smooth pagination shimmer at the bottom of the list when fetching more exam courses.

**Non-Goals:**
- Changing how `CourseCard` operates or is styled.
- Adding skeletonization to screens other than `ExamsScreen` (e.g. detailed exam players or reviews, which already have their own designs).

## Decisions

### Decision 1: UI-Local Skeleton Courses Helper
We will define a local list of mock courses (`_skeletonCourses`) inside `packages/exams/lib/screens/exams_screen.dart`.
- **Why**: Keeps skeleton data localized to the UI layer, matching the pattern used in the Study tab.

### Decision 2: Sliver-Based Shimmer Skeletons
We will map `_skeletonCourses` inside the `loading:` branch and conditional initial sync branches to render the `CourseCard` list in a `SliverList`.
- **Why**: Ensures that the skeleton occupies the same layout structure (slivers, scroll controller, padding) as the actual course cards, ensuring zero-height prevention and layout parity.

## Risks / Trade-offs

- **[Risk]**: Skeleton remaining visible forever if a sync hangs.
- **[Mitigation]**: The skeleton state is strictly bound to `isSyncing` and `loading:` states. When sync ends or an error occurs, it transitions correctly to the final state.
