## 1. Setup & Navigation

- [x] 1.1 Define analytics models (`SubjectAnalytics`) inside `packages/exams`
- [x] 1.2 Add the `/exams/analytics` route to `packages/testpress/lib/navigation/routes/exams_routes.dart`
- [x] 1.3 Update the "Analytics" drawer button action in `dashboard_drawer.dart` to navigate to `/exams/analytics`

## 2. Data Layer

- [x] 2.1 Create `SubjectAnalyticsTable` Drift table in `packages/core/lib/data/db/`
- [x] 2.2 Register `SubjectAnalyticsTable` in `AppDatabase` and bump schema version to 28
- [x] 2.3 Implement `SubjectAnalyticsRepository` with `watchSubjectAnalytics()` stream and `refreshSubjectAnalytics()` using `getAnalyticsData()` stale-while-revalidate fetch
- [x] 2.4 Expose `subjectAnalyticsRepositoryProvider` and `SubjectAnalytics` stream providers in `analytics_providers.dart`

## 3. Analytics Shell & Header UI

- [x] 3.1 Implement `SubjectAnalyticsScreen` with a custom header row containing a back button, a left-aligned title, and a filter icon button
- [x] 3.2 Implement the tab switcher for "Overall Reports" and "Individual Reports" styled as filled rounded pills side-by-side using the primary color for the active tab

## 4. Overall Reports Implementation

- [x] 4.1 Implement a responsive horizontal stacked bar row using Flex widgets representing correct, incorrect, and unanswered percentages
- [x] 4.2 Add the Strength/Weakness/Unanswered color-coded legend top bar, distributed dynamically for responsiveness
- [x] 4.3 Render the overall reports scrollable list of subjects driven by the Riverpod stream provider
- [x] 4.4 Implement single filter percentage rendering and dynamic single-item legend on the Overall Reports tab

## 5. Individual Reports Implementation

- [x] 5.1 Implement the stats table displaying subject counts (Correct, Incorrect, Unanswered) with dynamic column weights and padding to prevent header wrapping
- [x] 5.2 Implement `DonutChart` using `CustomPainter` for circular progress visualization
- [x] 5.3 Implement `DonutCard` widget and render list below the table, using correct spacing and design tokens without duplicate card padding
- [x] 5.4 Implement table header column widths and cell padding sized to prevent text truncation or clipping across all filter views
- [x] 5.5 Adjust filter dropdown overlay menu vertical offset to 48px to align with the Individual Reports tab button line
- [x] 5.6 Center align CORRECT, INCORRECT, UNANSWERED column headers and count numbers in stats table

## 6. Verification & Tests

- [x] 6.1 Implement widget tests verifying the screen, tab switching, and navigation within `packages/exams`
- [x] 6.2 Override `AppDatabase` with `NativeDatabase.memory()` in widget tests; pump `SizedBox.shrink()` at teardown to drain active Drift stream timers
- [x] 6.3 Verify layout and responsive scaling across mobile and tablet viewports
- [x] 6.4 Refactor subject analytics widgets to strictly use design tokens instead of hardcoded sizes/colors
- [x] 6.5 Refactor subject analytics screen and widgets to adhere to the Newspaper Metaphor and Single Level of Abstraction (SLA) principles


