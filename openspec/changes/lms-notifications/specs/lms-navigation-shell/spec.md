## MODIFIED Requirements

### Requirement: Sub-routing within Tabs
Each primary tab SHALL support its own stack of push/pop navigation without affecting the other tabs.

#### Scenario: Navigating within Study tab
- **WHEN** the user clicks a course in the "Study" tab to see chapters
- **THEN** the chapter list is pushed onto the study tab's local stack, and the "Back" action returns them to the course list within that same tab

#### Scenario: Navigating to Curriculum with Course ID
- **WHEN** the user selects a course with ID "123"
- **THEN** the system SHALL navigate to the route `/study/course/123/chapters` within the Study tab
- **AND** the navigation shell MUST remain visible

#### Scenario: Navigating from Profile to Notifications
- **WHEN** the user selects "Notifications" from the Profile settings actions
- **THEN** the system SHALL navigate to the Notifications settings route from within the Profile tab flow
- **AND** the system MUST preserve the active shell/tab context while the Notifications screen is open

#### Scenario: Returning from Notifications to Profile
- **WHEN** the user triggers back navigation from the Notifications settings screen
- **THEN** the system SHALL return to the previous Profile screen state
- **AND** the system MUST NOT reset other tab navigation stacks
