## Why

The analytics screen currently shows only top-level subjects. Users cannot explore the performance breakdown of a specific subject's child topics, limiting the usefulness of analytics for identifying weak areas at a granular level.

## What Changes

- When viewing a child subject (`parentId != null`), the "Overall/Individual" tabs are hidden and only the Overall Reports view is shown.
- Non-leaf subject rows, which already display a chevron icon, become tappable and navigate to the analytics view scoped to that subject's `parentId`.

## Capabilities

### New Capabilities

- `sub-subject-navigation`: Hierarchical navigation through subject analytics using `parentId` to scope the data shown.

### Modified Capabilities

- `subject-analytics-ui`: UI requirements updated to conditionally hide the Tabs Row and show navigation affordances when viewing a child subject.

## Impact

- `SubjectAnalyticsScreen`
- `OverallReportsView`
- `IndividualReportsView`
- Navigation routes handling `parentId` query arguments.
