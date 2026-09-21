## Context

In `packages/exams`, the Subject Analytics screen displays performance metrics across subjects:
1. `IndividualReportsView` currently renders both the stats table and donut cards stacked below it.
2. The tab bar is hidden when `widget.parentId != null`, restricting tab toggling to the root level.
3. The default tab is currently `AnalyticsTab.overall` (Graph Reports), and the tab bar places Graph Reports on the left and Table Reports on the right.

## Goals / Non-Goals

**Goals:**
- Set `Table Reports` on the left as the default active tab (`_activeTab = AnalyticsTab.individual`).
- Place `Graph Reports` on the right.
- Ensure the tab bar is always rendered regardless of whether `parentId` is null or non-null.
- Remove the donut cards from `IndividualReportsView`.
- Maintain drill-down navigation into sub-subjects with Table Reports as the default active tab.
- Support direct navigation to Topic Analytics from leaf table rows without showing folder chevrons.
- Display topic names dynamically in detail screen headers.
- Display trailing diagonal drill-down arrows (`↗`) for parent subjects in Graph Reports while reserving space on leaf items for uniform bar widths.

**Non-Goals:**
- Refactor backend API models or queries.

## Decisions

### Decision 1: Tab Order & Default Tab in `SubjectAnalyticsScreen`
- Initialize `_activeTab = AnalyticsTab.individual` (Table Reports).
- Render `_TabButton` for "Table Reports" first (left) and "Graph Reports" second (right).
- In `AppHeader(bottomContent: ...)`, remove the `widget.parentId == null` guard so tabs are shown on all screen levels.

### Decision 2: Remove Donut Cards from `IndividualReportsView`
- In `IndividualReportsView`, remove `_DonutCard` mapping and related scroll layout underneath `_StatsTable`.
- Only render `_StatsTable` wrapped in padding / scroll view.

### Decision 3: Leaf Topic Navigation & Drill-Down Indicators
- In `IndividualReportsView`, configure `onTap` to push the topic breakdown route for leaf subjects without rendering a chevron icon.
- In `BarRow` and `OverallReportsView`, render a diagonal arrow (`LucideIcons.arrowUpRight`) for parent subjects with sub-subjects, and reserve an empty slot of equal width for leaf subjects to maintain uniform bar alignment.
- In `TopicAnalyticsScreen`, render `topic.name` in the app header and remove redundant title text from the body.

