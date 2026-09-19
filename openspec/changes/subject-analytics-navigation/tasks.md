## 1. Subject Analytics Screen & Tab Updates

- [x] 1.1 Update `SubjectAnalyticsScreen` to set `Table Reports` (`AnalyticsTab.individual`) as the default active tab
- [x] 1.2 Reorder tab buttons in `SubjectAnalyticsScreen` so `Table Reports` is on the left and `Graph Reports` is on the right
- [x] 1.3 Ensure tab buttons are always rendered across all hierarchy levels (root and sub-subjects)
- [x] 1.4 Update `TopicAnalyticsScreen` to display topic name in the header and remove static "Sub Category" and redundant body name
- [x] 1.5 Update `BarRow` / `OverallReportsView` to display a trailing diagonal arrow indicator (`↗`) for non-leaf subjects with sub-subjects while maintaining uniform bar alignment

## 2. Table Reports Updates (`IndividualReportsView`)

- [x] 2.1 Remove category donut progress cards from `IndividualReportsView` so it purely renders the data table
- [x] 2.2 Update table rows in `IndividualReportsView` so leaf topics navigate to `TopicAnalyticsScreen` without folder chevrons

## 3. Verification & Testing

- [x] 3.1 Update and run widget tests in `packages/exams` for tab default, tab ordering, table-only display, topic analytics header title, and drill-down navigation
- [x] 3.2 Run `flutter analyze packages/exams` to verify no issues

