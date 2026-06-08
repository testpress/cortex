## Why

The application needs a root Analytics screen that allows users to monitor their learning progress with "Overall Reports" and "Individual Reports" tabs, showing performance charts and subject breakdowns. Subject analytics data must be available offline and kept fresh via a stale-while-revalidate caching strategy backed by Drift and the existing API datasource.

## What Changes

- Implement the root `/exams/analytics` route in the router pointing to the Analytics dashboard.
- Implement the `SubjectAnalyticsScreen` with a top header title "Analytics" and a tab bar switcher.
- Implement the "Overall Reports" tab containing a legend and a list of root subjects with horizontal stacked bar charts.
- Implement the "Individual Reports" tab containing a detailed subject stats table and circular donut progress cards.
- Wire the dashboard drawer "Analytics" button to navigate to the new screen.
- Introduce a `SubjectAnalyticsRepository` backed by a Drift table that exposes live `Stream`s and refreshes from the API in the background.

## Capabilities

### New Capabilities
- `subject-analytics-ui`: Custom components and layout for displaying learning progress.
- `subject-analytics-data`: Drift-persisted analytics with stale-while-revalidate caching via Riverpod stream providers.

### Modified Capabilities
- `app-database`: New `SubjectAnalyticsTable` added; schema version bumped to 28.

## Impact

- `packages/exams`: Subject analytics screens, models, repository, widgets, and providers.
- `packages/core`: New `SubjectAnalyticsTable` in `AppDatabase`; `centerTitle` support added to `AppHeader`.
- `packages/testpress`: Navigation routing and dashboard drawer button.
