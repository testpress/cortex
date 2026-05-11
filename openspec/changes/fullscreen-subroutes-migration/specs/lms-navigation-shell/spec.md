## MODIFIED Requirements

### Requirement: Exclusive Full-screen Views
The system SHALL mandate that all deep-dive learning and community activities (lessons, tests, assessments, chapters, forums, doubt details) occupy the entire screen, hiding the navigation shell to ensure immersive focus and proper native resource disposal.

#### Scenario: Opening a lesson
- **WHEN** the user selects a lesson, test, or assessment
- **THEN** the system navigates to a full-screen view via the root navigator where the navigation shell is no longer visible

#### Scenario: Opening a forum or doubt detail
- **WHEN** the user navigates to a forum thread or a doubt detail page
- **THEN** the system navigates to a full-screen view via the root navigator

### Requirement: Sub-routing within Tabs
Each primary tab SHALL support its own stack of push/pop navigation without affecting the other tabs, EXCEPT for deep-dive immersive content which is pushed to the root navigator.

#### Scenario: Navigating within Study tab
- **WHEN** the user clicks a course in the "Study" tab to see chapters
- **THEN** the chapter list is pushed to the root navigator, creating an immersive full-screen view
- **AND** the "Back" action returns them to the course list tab

#### Scenario: Navigating to Curriculum with Course ID
- **WHEN** the user selects a course with ID "123"
- **THEN** the system SHALL navigate to the route `/study/course/123/chapters` using the root navigator
- **AND** the navigation shell MUST NOT be visible

#### Scenario: Navigating from Profile to Notifications
- **WHEN** the user selects "Notifications" from the Profile settings actions
- **THEN** the system SHALL navigate to the Notifications settings route from within the Profile tab flow
- **AND** the system MUST preserve the active shell/tab context while the Notifications screen is open

#### Scenario: Returning from Notifications to Profile
- **WHEN** the user triggers back navigation from the Notifications settings screen
- **THEN** the system SHALL return to the previous Profile screen state
- **AND** the system MUST NOT reset other tab navigation stacks
