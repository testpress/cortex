# Subject Analytics UI

## Purpose
Subject Analytics UI capability provides the components, layout, and visualization to allow users to monitor their learning progress.
## Requirements
### Requirement: Navigation and Header UI
The system SHALL render a sticky top header containing a back navigation button, a title "Analytics", and a filter icon button.

#### Scenario: Navigating back from the screen
- **WHEN** the user taps the back button in the header
- **THEN** the system SHALL pop the current route to return to the previous screen

#### Scenario: Filter Dropdown Menu Placement
- **WHEN** the user taps the filter icon in the header
- **THEN** the system SHALL open the filter overlay menu slightly below the filter button (offset vertically by 48px / design.spacing.xxl) so that it does not overlap or obscure the filter icon
- **AND** the top of the menu SHALL start aligned so that the first item ("All") is horizontally on the same line as the "Individual Reports" tab button.

### Requirement: Reports Tab Toggling
The system SHALL present two tabs: "Table Reports" on the left (active by default) and "Graph Reports" on the right, permitting the user to switch between views across all subject levels (both root analytics and nested sub-subject views).

#### Scenario: Switching between tabs on root and sub-subject screens
- **WHEN** the user is viewing analytics at any level (root or child sub-subject)
- **THEN** the system SHALL display the "Table Reports" (left) and "Graph Reports" (right) tab toggle buttons
- **AND** "Table Reports" SHALL be selected by default
- **AND** WHEN the user taps the "Table Reports" tab, the system SHALL display the subject stats data table
- **AND** WHEN the user taps the "Graph Reports" tab, the system SHALL display the graphical performance charts for that subject level
- **AND** the active tab button SHALL have a background color of design.colors.primary and contrasting text color of design.colors.onPrimary, while the inactive tab button SHALL have a light background and secondary text color

### Requirement: Graph Reports Performance Charts
The graph reports tab SHALL display a list of root subjects, each visualizing its correct, incorrect, and unanswered counts as a percentage-based stacked horizontal bar.

#### Scenario: Rendering the stacked bar row
- **WHEN** the graph reports tab is active
- **THEN** the system SHALL render a horizontal stacked bar for each subject where green represents strength (correct), red represents weakness (incorrect), and amber represents unanswered questions
- **AND** the legend bar SHALL display Strength, Weakness, and Unanswered items in a single horizontal row using design system success, error, and warning colors respectively
- **AND** the legend items SHALL be distributed dynamically to avoid compression on tablet screens (occupying approximately half to three-quarters of the screen width on wider layouts) while gracefully wrapping or adjusting on mobile viewports.

#### Scenario: Single Filter Percentage Labels
- **WHEN** a single filter is active (e.g. Correct, Incorrect, Unanswered) on the Graph Reports tab
- **THEN** the system SHALL render percentage labels for all subjects, even those with small percentages (including <= 10%)
- **AND** the percentage text SHALL be drawn inside the colored bar segment if it is wide enough (>= 30%), or outside the segment in the light tint background area if the segment is too narrow (< 30%)
- **AND** the legend bar SHALL dynamically display only the single dot and label representing the active filter state (e.g. "Strength / Correct", "Weakness / Incorrect", or "Unanswered").

### Requirement: Table Reports Stats Table
The table reports tab SHALL display a data table showing the subject name, correct count, incorrect count, and unanswered count, and SHALL NOT display redundant donut cards below the data table.

#### Scenario: Displaying subject rows without bottom donut cards
- **WHEN** the "Table Reports" tab is active
- **THEN** the system SHALL render rows showing correct, incorrect, and unanswered counts for each subject
- **AND** the system SHALL NOT render category donut cards below the table

### Requirement: Category Donut Progress Cards
The table reports view SHALL render category cards below the main table, displaying a circular donut chart visualizing the relative percentages of correct, incorrect, and unanswered questions.

#### Scenario: Rendering donut cards
- **WHEN** the table reports view is scrolled below the table
- **THEN** the system SHALL display cards containing circular donut visualizations with correct, incorrect, and unanswered percentage slices.

### Requirement: Analytics Cleanup Refactoring Guidelines
The system SHALL adhere to the analytics cleanup refactoring guidelines to improve codebase clarity and consistency.

**Overview**
Refactor analytics codebase to improve clarity and consistency by:
1. Clarifying UI naming to use "Analytics" instead of generic "Subject" where analytics context is intended
2. Renaming table and DTO fields for clarity (`leaf` → `isLeaf`, `analyticsUrl` removal)
3. Standardizing button and text sizing across analytics screens

#### Scenario: Table & DTO Field Naming Conventions
- **THEN** Always use boolean flags prefixed with `is` (e.g., `isLeaf` instead of `leaf`).
- **AND** Avoid storing derived fields like `analyticsUrl` in the database; these should be constructed dynamically based on ID in the Data Source or Repository.
- **AND** Match DTO variable names with Database Column names.

#### Scenario: UI Screen/Component Naming
- **THEN** For Analytics screens, headers should clearly define the context (e.g., "Subject Analytics" instead of generic "Analytics" when looking at a specific subject).
- **AND** Section headers must be fully descriptive (e.g., "Subject Performance").
- **AND** Standard filter labels: "Correct", "Incorrect", "Unanswered".

#### Scenario: Text & Button Sizing Standardization
- **THEN** The global `ForumHeader` alignment standard must be applied to the Subject Analytics screen header:
  - Back arrows must use optical alignment: `Padding(top: 2)`
  - Titles must use `AppText.title` with `design.colors.textPrimary`.
- **AND** Filter icon buttons must be sized to `48x48` for accessibility tap targets, with an inner container of `36x36`.
- **AND** Tab buttons in views must use a `minHeight: 48.0` for accessibility standards.

**Affected Components**
- `packages/core/lib/data/db/tables/subject_analytics_table.dart`
- `packages/core/lib/data/models/review_models.dart`
- `packages/exams/lib/screens/subject_analytics/subject_analytics_screen.dart`

### Requirement: Subject Row Interactions
The system SHALL provide interactive navigation for subject rows across all tabs in the analytics UI.

#### Scenario: Tapping a non-leaf subject row
- **WHEN** the user taps a subject row that is NOT a leaf node
- **THEN** the system SHALL navigate deeper into that subject's children analytics view

#### Scenario: Tapping a leaf subject row
- **WHEN** the user taps a subject row that is a leaf node
- **THEN** the system SHALL navigate to the dedicated topic analytics screen to display its specific breakdown

### Requirement: API Integration and Offline-First State
The system SHALL integrate with the backend API to fetch paginated analytics data and persist the results locally using Drift for an offline-first architecture.

#### Scenario: Preserving Pagination State
- **WHEN** the user toggles between "Graph Reports" and "Table Reports", or navigates away and back
- **THEN** the system SHALL NOT discard the existing pagination state or refetch the initial page of data from the network
- **AND** the system SHALL utilize `@Riverpod(keepAlive: true)` to preserve offline data states and render the UI instantly.

### Requirement: Structural Skeleton Loading States
The system SHALL use the `skeletonizer` package to render visually consistent, non-intrusive loading states during API network requests.

#### Scenario: Rendering Chart Skeletons
- **WHEN** the API data is loading
- **THEN** the system SHALL render solid, structural grey (`surfaceVariant`) blocks for the Graph bar charts and Table donut charts
- **AND** the system SHALL NOT render fragmented black text-bone artifacts inside the charts
- **AND** the system SHALL permit surrounding text elements (such as subject titles) to correctly shimmer in tandem with the layout.

### Requirement: Subject Row Navigation
The system SHALL navigate to the sub-subject analytics view when a non-leaf parent subject row is tapped, and navigate to the topic analytics view when a leaf subject row is tapped.

#### Scenario: Opening sub-subject from table
- **WHEN** the user taps a non-leaf subject row in the Table Reports view
- **THEN** the system SHALL navigate to that subject's child analytics view
- **AND** the child analytics view SHALL open with the "Table Reports" tab active by default

#### Scenario: Opening leaf topic analytics from table
- **WHEN** the user taps a leaf subject row in the Table Reports view
- **THEN** the system SHALL navigate to the topic analytics view (`/exams/analytics/topic/:id`) with the topic's analytics data
- **AND** the table row for leaf subjects SHALL NOT display a folder chevron icon

### Requirement: Topic Analytics Screen Header Title
The topic analytics screen SHALL display the topic name directly in the header (app bar) and SHALL NOT display the static "Sub Category" title or redundant topic name in the body.

#### Scenario: Displaying topic details screen
- **WHEN** the user is on the topic/sub-category analytics detail screen
- **THEN** the header SHALL display the topic name as the title
- **AND** the header SHALL NOT display the static "Sub Category" title
- **AND** the body SHALL render the performance bar chart and statistics without a duplicate topic name above the chart

### Requirement: Graph Reports Row Indicator
The Graph Reports view SHALL display a diagonal arrow (`↗`) drill-down indicator at the end of each subject bar row that has sub-subjects (`isLeaf == false`), and SHALL reserve equal trailing space for leaf-level subjects to maintain uniform bar lengths.

#### Scenario: Displaying subject rows in Graph Reports
- **WHEN** the "Graph Reports" tab is active
- **THEN** subjects with sub-subjects (`isLeaf == false`) SHALL display a trailing diagonal arrow icon (`LucideIcons.arrowUpRight`)
- **AND** leaf-level subjects (`isLeaf == true`) SHALL NOT display an arrow icon but SHALL reserve equivalent trailing width so all bar charts are uniform in length

