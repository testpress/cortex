# Specs: Course Detail API Integration V3

## ADDED Requirements

### Requirement: Course Detail API Integration
The system SHALL provide functionality to fetch comprehensive metadata for a single course via the `/api/v3/courses/{course_id}/` endpoint.

#### Scenario: Successful Metadata Fetch
- **WHEN** a user navigates to a course detail page
- **THEN** the system SHALL call the v3 course detail endpoint
- **AND** the system SHALL map `title`, `description`, `image`, and `contents_count` to the view model

### Requirement: Hierarchical Curriculum Fetching
The system SHALL provide functionality to fetch the structured curriculum (chapters and their contents) via the `/api/v3/courses/{course_id}/chapters/` endpoint.

#### Scenario: Loading Chapter List
- **WHEN** the user views the "All" tab in the curriculum
- **THEN** the system SHALL call the v3 chapters endpoint
- **AND** the system SHALL display each chapter in its correct hierarchy (filtering by `parentId`)
- **AND** the system SHALL support recursive navigation (drilling down) for non-leaf chapters

### Requirement: Local Cache Streaming
The system SHALL prioritize displaying curriculum data from the local database immediately upon page load, while triggering a non-blocking network refresh in the background.

### Requirement: Flat Lesson List Fetching
The system SHALL provide functionality to fetch a flat list of all lessons in a course via the `/api/v3/courses/{course_id}/contents/` endpoint.

#### Scenario: Filtering by Content Type
- **WHEN** the user selects a specific content type tab (e.g., "Videos")
- **THEN** the system SHALL fetch the flat contents list
- **AND** the system SHALL filter the list to show only the selected content type across all chapters

### Requirement: API Endpoint Constants
The system SHALL define the new v3 course endpoints in the `ApiEndpoints` class to ensure centralized endpoint management.

#### Scenario: Updating Endpoint Config
- **WHEN** adding new course endpoints
- **THEN** the `ApiEndpoints` class SHALL be updated with constants or methods for `courseDetail`, `courseChapters`, and `courseContents`
