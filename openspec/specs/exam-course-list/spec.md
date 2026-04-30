## ADDED Requirements

### Requirement: Filtering Courses for Exams
The system SHALL filter the list of courses specifically for the Exams tab based on backend tags and device permissions.

#### Scenario: Displaying exam-tagged courses
- **WHEN** the user navigates to the Exams tab
- **THEN** the system retrieves courses from the local database
- **AND** filters the list to include only courses that have the 'exams' tag
- **AND** filters the list to include only courses where 'mobile' is listed in 'allowed_devices'

### Requirement: Exams Screen Layout
The Exams tab SHALL provide a structured layout for browsing exam-related content.

#### Scenario: Viewing the initial exams list
- **WHEN** the user is on the Exams tab
- **THEN** the screen displays a list of filtered courses matching exam criteria
- **AND** each course card displays relevant metadata (title, image, etc.) similar to the Study tab
