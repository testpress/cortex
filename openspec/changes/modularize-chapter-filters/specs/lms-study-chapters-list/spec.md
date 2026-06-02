## MODIFIED Requirements

### Requirement: Content Type Tabs
The system SHALL provide a horizontal scrollable tab bar to filter the curriculum content by type. The visibility of specific content filter tabs (specifically Assessments and Tests) SHALL be controlled dynamically based on client configurations. If the "Exam" tab is enabled in the client configuration, the Assessments and Tests tabs SHALL be hidden from the tab bar.

#### Scenario: Switching to Videos Tab
- **WHEN** the user is on the "All" tab and taps the "Videos" tab
- **THEN** the system SHALL hide the chapter list
- **AND** the system SHALL display a flat list of all video lessons across all chapters in that course

#### Scenario: Exam Tab Enabled Hides Assessment and Test Chips
- **WHEN** the ChaptersListPage is loaded with client configuration having showExamTab set to true
- **THEN** the ChaptersFilterTabBar SHALL NOT display the Assessments or Tests filter tabs
- **AND** only the All, Lessons, and Videos tabs SHALL be visible
