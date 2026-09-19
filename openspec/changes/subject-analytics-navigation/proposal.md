## Why

Currently in Subject Analytics:
1. The `IndividualReportsView` (Table Reports) bundles redundant donut cards below the table.
2. The tab buttons (`Table Reports` and `Graph Reports`) are only visible at the root level (`parentId == null`), preventing users from switching between tabular and graphical views within sub-subjects.
3. The tab order has `Graph Reports` first, whereas `Table Reports` should be the primary view on the left and selected by default across all levels.

## What Changes

- **Remove Donut Cards from Table View**: Remove the donut cards section from `IndividualReportsView` so it presents purely the data table.
- **Tabs on Inner Subject Screens**: Always render the tab switcher (`Table Reports` and `Graph Reports`) across all hierarchy levels (root and nested sub-subjects).
- **Tab Ordering & Default**: Set `Table Reports` on the left as the default active tab, and `Graph Reports` on the right.
- **Table Item Navigation**: When drilling down into sub-subjects from a table row, the sub-subject screen opens with `Table Reports` active by default. Tapping a leaf subject opens the Topic Analytics breakdown screen.
- **Topic Analytics Screen Header**: Render dynamic subject/topic names directly in the header app bar.
- **Graph Reports Drill-down Indicators**: Display diagonal arrow (`↗`) indicators for parent subjects in Graph Reports while keeping bar lengths uniformly aligned.

## Capabilities

### Modified Capabilities
- `subject-analytics-ui`: Update tab layout (Table left, Graph right, persistent across sub-subjects), remove bottom donut cards from Table Reports view, support leaf topic navigation, and render drill-down indicators.

## Impact

- Affected files in `packages/exams`:
  - `lib/screens/subject_analytics/subject_analytics_screen.dart`
  - `lib/screens/subject_analytics/topic_analytics_screen.dart`
  - `lib/screens/subject_analytics/widgets/individual_reports_view.dart`
  - `lib/screens/subject_analytics/widgets/overall_reports_view.dart`
  - `lib/screens/subject_analytics/widgets/bar_chart.dart`
  - `test/widgets/subject_analytics_screen_test.dart`

