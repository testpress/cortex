## Why

A polish pass on the Review Analytics screens after exam submission. The header currently shows a generic "Back" label and a chevron icon — replacing the icon with a standard arrow and the text with the actual exam title gives the screen better context. The "Performance Overview" title and the subject-wise section titles are larger than needed and will be brought in line with the rest of the app. The "Explore More Details" section is currently rendered as a single grouped box with two items inside — splitting them into individual standalone cards and pulling the label outside the box improves clarity and visual rhythm. On the Subject-wise Performance screen, the donut chart alignment is also being corrected to center.

## What Changes

- **Performance Overview — Header Title**: Replace the chevron with a standard left arrow and replace the "Back" text in the header with the Exam Title, so the user always knows which exam they're reviewing.
- **Performance Overview — Section Title Size**: Reduce the "Performance Overview" title to the appropriate `AppText` style to match sizing used elsewhere in the app.
- **Performance Overview — Explore More Details**: Pull the "Explore More Details" label out of the card box. The two action items currently grouped inside a single card should each become their own standalone card, displayed separately.
- **Subject-wise Performance — Title Sizes**: Reduce the font size of the "Overall Performance" and "Section Performance" section titles to match standard conventions.
- **Subject-wise Performance — Donut Chart Alignment**: Center-align the donut chart within its parent.

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `exam-review-analytics`: Polish the Review Analytics landing page — update the header to show the exam title, reduce section title sizes, restructure the Explore More Details section into separate standalone cards, and fix title sizes and donut chart alignment on the Subject-wise Performance sub-screen.

## Impact

- `packages/exams/lib/screens/review_analytics/review_analytics_screen.dart`
- `packages/exams/lib/screens/review_analytics/widgets/analytics_header.dart`
- `packages/exams/lib/screens/review_analytics/widgets/explore_details_card.dart`
- `packages/exams/lib/screens/review_analytics/widgets/metrics_grid.dart`
- `packages/exams/lib/screens/review_analytics/review_subject_performance_screen.dart`
- `packages/exams/lib/screens/review_analytics/widgets/overall_performance_card.dart`
- `packages/exams/lib/screens/review_analytics/widgets/section_donut_list.dart`
- `packages/exams/lib/screens/review_analytics/widgets/donut_chart.dart`
