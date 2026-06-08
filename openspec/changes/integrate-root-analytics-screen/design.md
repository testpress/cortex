## Context

The application needs a dedicated Analytics section that allows users to monitor their learning progress. Based on the provided design specifications, the screen must contain a unified top bar with navigation, a tab selection bar for "Overall Reports" and "Individual Reports," and visual cards demonstrating performance.

## Goals / Non-Goals

**Goals:**
- **Navigation Integration**: Wire the app drawer "Analytics" item to navigate to the new Analytics screen.
- **Unified Analytics Screen**: Create a single screen displaying "Overall Reports" and "Individual Reports" tabs.
- **Stacked Bar Visualization**: Implement custom horizontal stacked bar components showing Strength (green), Weakness (red), and Unanswered (amber) percentages for the "Overall Reports" tab.
- **Individual Stats Layout**: Implement the subject stats table (Subject, Correct, Incorrect, Unanswered) with interactive row navigation, and custom circular donut charts for sub-categories.
- **Design System Adherence**: Exclusively use core primitives and runtime design context from `package:core` (`AppText`, `AppScroll`, `AppCard`, `Design.of(context)`).
- **Header Title Centering**: Add support for centering the header title and subtitle.

**Non-Goals:**
- **Real Backend Integration**: Real network requests are out of scope for this UI-only phase; mock data will be used.
- **Filter Action Sheet Details**: The filter click action is stubbed and won't launch an active filter sheet yet.
- **Nested Drill-down Pages**: Implementing nested screens for Chemistry/Physics subcategories and sub-levels is out of scope for this PR.

## Decisions

- **Custom Painters for Charts**:
  - Instead of importing large external charting libraries, we will use a custom `CustomPainter` to draw the donut charts.
  - The stacked bar charts will be implemented using a flex-based layout within a row of Containers with rounded borders to ensure responsiveness and match the CSS design exactly.
- **Mock State Management**:
  - We will introduce a Riverpod state provider with mock data corresponding to the Figma design's subjects (Biology, Botany, Chemistry, Mathematics, Physics, Zoology).
- **Navigation Structure**:
  - Define routes in `packages/testpress` router pointing to the new screen, supporting an optional `parentSubjectId` parameter for nested drilling.
- **Header Title Centering**:
  - Add a `centerTitle` parameter to `AppHeader` in `package:core` to allow centered title and subtitle layouts, satisfying the visual alignment requirement on the Analytics screen.

## Risks / Trade-offs

- **[Risk] Chart Rendering on Small Screen Heights** → **[Mitigation]** Embed all scrollable content within `AppScroll` so that charts and tables scroll fluidly on smaller devices.
- **[Risk] Text Contrast in Stacked Bars** → **[Mitigation]** Check the segment width before drawing percentages; only draw the label if the segment is wide enough, similar to the web version's check.
