## Why

The analytics screens show a hierarchical list of subjects, allowing users to navigate from root subjects into their children. When a user reaches a leaf subject (one with no children), tapping it currently does nothing. This change makes leaf subject rows actionable by navigating to a dedicated topic analytics screen that shows performance metrics specific to that topic.

## What Changes

- When a user taps a leaf subject row in either the Overall Reports tab or the Individual Reports tab, the app SHALL navigate to a dedicated topic analytics screen showing correct, incorrect, and unanswered breakdowns for that topic.
- A new dedicated screen SHALL be introduced to present topic-level analytics when a leaf subject is tapped.

## Capabilities

### New Capabilities
- `topic-analytics-breakdown`: Dedicated screen and data binding for displaying analytics for a specific leaf-level topic, entered by tapping a leaf subject row from any analytics tab.

### Modified Capabilities
- `subject-analytics-ui`: Tap handling on leaf subject rows in both the Overall Reports and Individual Reports tabs SHALL navigate to the topic analytics screen instead of being a no-op.

## Impact

- `packages/exams/lib/screens/subject_analytics/widgets/individual_reports_view.dart`: Update `isLeaf` tap guard to navigate to the topic analytics screen.
- `packages/exams/lib/screens/subject_analytics/widgets/overall_reports_view.dart`: Update `isLeaf` tap guard to navigate to the topic analytics screen.
- `packages/testpress/lib/navigation/routes/exams_routes.dart`: Add a nested route to handle the topic analytics screen.
- `packages/exams/lib/screens/subject_analytics/` (new file): New dedicated screen for topic-level analytics, co-located with the subject analytics screens.
