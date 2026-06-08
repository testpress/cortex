## Why

The application needs a root Analytics screen that allows users to monitor their learning progress with "Overall Reports" and "Individual Reports" tabs, showing performance charts and subject breakdowns.

## What Changes

- Implement the root `/exams/analytics` route in the router pointing to the Analytics dashboard.
- Implement the `SubjectAnalyticsScreen` with a top header title "Analytics" and a tab bar switcher.
- Implement the "Overall Reports" tab containing a legend and a list of root subjects with horizontal stacked bar charts.
- Implement the "Individual Reports" tab containing a detailed subject stats table and circular donut progress cards.
- Wire the dashboard drawer "Analytics" button to navigate to the new screen.

## Capabilities

### New Capabilities
- `subject-analytics-ui`: Custom components and layout for displaying learning progress.

### Modified Capabilities

## Impact

- `packages/exams`: Subject analytics screens, models, widgets, and mock data.
- `packages/testpress`: Navigation routing and dashboard drawer button.
