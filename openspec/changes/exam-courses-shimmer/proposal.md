## Why

Currently, the Exams tab displays a generic `AppLoadingIndicator` when loading exam courses or fetching more data. This lacks the premium, high-fidelity shimmer-based structural loading experience used in the Study tab.

## What Changes

- Replace the generic circular progress loading indicator in the Exams screen with beautiful shimmer skeleton placeholders using `Skeletonizer`.
- Render a list of 6 skeleton course cards during the initial database load or initial syncing in the Exams screen.
- Render a single skeleton course card at the bottom of the list when more exam courses are being loaded via pagination.

## Capabilities

### New Capabilities

<!-- None -->

### Modified Capabilities

- `shimmer-loading-infrastructure`: Extend structural skeleton shimmer loading support to the Exams screen course list to match the Study tab course list experience.

## Impact

- `packages/exams/lib/screens/exams_screen.dart`: Update `ExamsScreen` state rendering to utilize `CourseCard` with skeletonization enabled and `_skeletonCourses` placeholders.
