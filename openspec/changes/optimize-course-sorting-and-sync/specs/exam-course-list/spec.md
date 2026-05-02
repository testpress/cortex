## MODIFIED Requirements

### Requirement: Filtering Courses for Exams
The system SHALL filter the list of courses specifically for the Exams tab based on backend tags and device permissions. The system MUST perform a server-side fetch with explicit tags to ensure data completeness regardless of the Study tab's state.

#### Scenario: Displaying exam-tagged courses
- **WHEN** the user navigates to the Exams tab
- **THEN** the system SHALL perform a network request with `?tags=exams&tags=classes`
- **AND** retrieve courses from the local database
- **AND** filter the list to include courses that have the 'exams' tag OR have no tags but non-zero `examsCount`
- **AND** filters the list to include only courses where 'mobile' is listed in 'allowed_devices'

### Requirement: Exams Screen Layout
The Exams tab SHALL provide a structured layout for browsing exam-related content. Sorting MUST follow the backend's native ordering.

#### Scenario: Viewing the initial exams list
- **WHEN** the user is on the Exams tab
- **THEN** the screen displays a list of filtered courses matching exam criteria
- **AND** the list SHALL be sorted by the backend's `order` field in ascending order
