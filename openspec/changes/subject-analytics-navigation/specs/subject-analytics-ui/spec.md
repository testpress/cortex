## MODIFIED Requirements

### Requirement: Reports Tab Toggling
The system SHALL present two tabs: "Table Reports" on the left (active by default) and "Graph Reports" on the right, permitting the user to switch between views across all subject levels (both root analytics and nested sub-subject views).

#### Scenario: Switching between tabs on root and sub-subject screens
- **WHEN** the user is viewing analytics at any level (root or child sub-subject)
- **THEN** the system SHALL display the "Table Reports" (left) and "Graph Reports" (right) tab toggle buttons
- **AND** "Table Reports" SHALL be selected by default
- **AND** WHEN the user taps the "Table Reports" tab, the system SHALL display the subject stats data table
- **AND** WHEN the user taps the "Graph Reports" tab, the system SHALL display the graphical performance charts for that subject level
- **AND** the active tab button SHALL have a background color of design.colors.primary and contrasting text color of design.colors.onPrimary, while the inactive tab button SHALL have a light background and secondary text color

### Requirement: Table Reports Stats Table
The table reports tab SHALL display a data table showing the subject name, correct count, incorrect count, and unanswered count, and SHALL NOT display redundant donut cards below the data table.

#### Scenario: Displaying subject rows without bottom donut cards
- **WHEN** the "Table Reports" tab is active
- **THEN** the system SHALL render rows showing correct, incorrect, and unanswered counts for each subject
- **AND** the system SHALL NOT render category donut cards below the table

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



