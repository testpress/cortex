## 1. Setup & Navigation

- [x] 1.1 Define mock analytics models and repository inside `packages/exams`
- [x] 1.2 Add the `/exams/analytics` route to `packages/testpress/lib/navigation/routes/exams_routes.dart`
- [x] 1.3 Update the "Analytics" drawer button action in `dashboard_drawer.dart` to navigate to `/exams/analytics`

## 2. Analytics Shell & Header UI

- [x] 2.1 Add `centerTitle` support to `AppHeader` in `packages/core`
- [x] 2.2 Implement `SubjectAnalyticsScreen` layout containing AppHeader with centered title and Tab bar switcher
- [x] 2.3 Implement the tab switcher for "Overall Reports" and "Individual Reports" styled as filled rounded pills side-by-side using the primary color for the active tab

## 3. Overall Reports Implementation

- [x] 3.1 Implement a responsive horizontal stacked bar row using Flex widgets representing correct, incorrect, and unanswered percentages
- [x] 3.2 Add the Strength/Weakness/Unanswered color-coded legend top bar, distributed dynamically for responsiveness
- [x] 3.3 Render the overall reports scrollable list of subjects

## 4. Individual Reports Implementation

- [x] 4.1 Implement the stats table displaying subject counts (Correct, Incorrect, Unanswered) with dynamic column weights and padding to prevent header wrapping
- [x] 4.2 Implement `DonutChart` using `CustomPainter` for circular progress visualization
- [x] 4.3 Implement `DonutCard` widget and render list below the table, using correct spacing and design tokens without duplicate card padding
- [x] 4.4 Fix table header column widths and cell padding to prevent last letter truncation/clipping on all filter views
- [x] 4.5 Adjust filter dropdown overlay menu vertical offset to 44px to start slightly below the filter button
- [x] 4.6 Implement single filter percentage rendering and dynamic single-item legend on the Overall Reports tab
- [x] 4.7 Align filter dropdown overlay vertically by 48px to match Individual Reports tab button line
- [x] 4.8 Center align CORRECT, INCORRECT, UNANSWERED column headers and count numbers in stats table




## 5. Verification & Tests

- [x] 5.1 Implement widget tests verifying the screen, tab switching, and navigation within `packages/exams`
- [x] 5.2 Verify layout and responsive scaling across mobile and tablet viewports
- [x] 5.3 Refactor subject analytics widgets to strictly use design tokens instead of hardcoded sizes/colors (e.g., 12, 16, manual Hex colors)
- [x] 5.4 Refactor subject analytics screen and widgets to adhere to the Newspaper Metaphor and Single Level of Abstraction (SLA) principles

