## Context

The application needs a dedicated Analytics section that allows users to monitor their learning progress. Based on the provided design specifications, the screen must contain a unified top bar with navigation, a tab selection bar for "Overall Reports" and "Individual Reports," and visual cards demonstrating performance. Analytics data is persisted locally via Drift so the screen works offline, and kept fresh by a background API refresh on every screen visit.

## Goals / Non-Goals

**Goals:**
- **Navigation Integration**: Wire the app drawer "Analytics" item to navigate to the new Analytics screen.
- **Unified Analytics Screen**: Create a single screen displaying "Overall Reports" and "Individual Reports" tabs.
- **Stacked Bar Visualization**: Implement custom horizontal stacked bar components showing Strength (green), Weakness (red), and Unanswered (amber) percentages for the "Overall Reports" tab.
- **Individual Stats Layout**: Implement the subject stats table (Subject, Correct, Incorrect, Unanswered) with interactive row navigation, and custom circular donut charts for sub-categories.
- **Design System Adherence**: Exclusively use core primitives and runtime design context from `package:core` (`AppText`, `AppScroll`, `AppCard`, `Design.of(context)`).
- **Custom Inline Header**: Build a custom header row directly inside `SubjectAnalyticsScreen` containing a back button, a left-aligned title, and a filter icon button — without relying on `AppHeader`.
- **Offline-first Data Layer**: Persist subject analytics in a Drift table (`SubjectAnalyticsTable`) and expose a reactive `Stream` so the UI updates automatically. Perform a background API fetch on every visit to keep data fresh (stale-while-revalidate).

**Non-Goals:**
- **Filter Action Sheet Details**: The filter click action is stubbed and won't launch an active filter sheet yet.
- **Nested Drill-down Pages**: Implementing nested screens for Chemistry/Physics subcategories and sub-levels is out of scope for this PR.

## Decisions

- **Custom Painters for Charts**:
  - Instead of importing large external charting libraries, we will use a custom `CustomPainter` to draw the donut charts.
  - The stacked bar charts will be implemented using a flex-based layout within a row of Containers with rounded borders to ensure responsiveness and match the CSS design exactly.
- **Stale-While-Revalidate Caching**:
  - `SubjectAnalyticsRepository` exposes a `watchSubjectAnalytics()` `Stream` from Drift so the UI reacts immediately to local data.
  - On every screen visit `refreshSubjectAnalytics()` is called, which fetches from the `getAnalyticsData` endpoint on the datasource and upserts rows in the Drift table, triggering the stream automatically.
  - Riverpod `StreamProvider`s in `analytics_providers.dart` wire the repository to the UI layer.
- **Database Schema**:
  - `SubjectAnalyticsTable` is registered in `AppDatabase` and the schema version is incremented from 27 → 28 to trigger Drift's migration path and create the new table on existing installs.
- **Navigation Structure**:
  - Define routes in `packages/testpress` router pointing to the new screen, supporting an optional `parentSubjectId` parameter for nested drilling.
- **Custom Inline Header Row**:
  - `SubjectAnalyticsScreen` builds its own `Row`-based header (56 px tall) with a back `AppFocusable` button, an `Expanded(AppText.headline)` title (left-aligned), and a filter `AppFocusable` icon button with an active-filter dot indicator.

## Risks / Trade-offs

- **[Risk] Chart Rendering on Small Screen Heights** → **[Mitigation]** Embed all scrollable content within `AppScroll` so that charts and tables scroll fluidly on smaller devices.
- **[Risk] Text Contrast in Stacked Bars** → **[Mitigation]** Check the segment width before drawing percentages; only draw the label if the segment is wide enough, similar to the web version's check.
- **[Risk] Drift Stream Active During Widget Disposal in Tests** → **[Mitigation]** Override the database with `NativeDatabase.memory()` in tests and explicitly pump a `SizedBox.shrink()` at teardown to drain pending stream timers and avoid "Pending Timers" assertion errors.

