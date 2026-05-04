# api-dashboard-resume Specification

## Purpose
TBD - created by archiving change integrate-dashboard-resume-learning. Update Purpose after archive.
## Requirements
### Requirement: Resume Feed Normalization
The system SHALL normalize the relational `/api/v2.4/resume/` response into a standard list of `DashboardContentDto` items by joining content metadata with user-specific progress.

#### Scenario: Mapping Video Progress
- **WHEN** a lesson in `chapter_contents` is of type "Video" and has a matching entry in `user_videos`
- **THEN** the system SHALL calculate the progress percentage (`watched_duration / duration`) and include it in the normalized item

#### Scenario: Mapping Exam Progress
- **WHEN** a lesson in `chapter_contents` is of type "Exam" and has a matching entry in `assessments`
- **THEN** the system SHALL include the exam state (e.g., "Running") and remaining time in the normalized item

#### Scenario: Filtering Items Without Progress
- **WHEN** a lesson in `chapter_contents` has no corresponding entry in either `user_videos` or `assessments`
- **THEN** the system SHALL exclude that lesson from the "Resume Learning" list

### Requirement: Order Persistence
The system SHALL maintain the display order of items as provided by the API when storing them in the local `DashboardContentsTable`.

#### Scenario: Sequential Display
- **WHEN** multiple items are returned from the resume API
- **THEN** the system SHALL store them with a `displayOrder` that reflects their position in the API response to ensure consistent UI sorting

### Requirement: UI Data Stream
The system SHALL provide a reactive Riverpod provider that streams "Resume Learning" items from the local database and triggers a background refresh from the network.

#### Scenario: Real-time Updates
- **WHEN** the dashboard is loaded or refreshed
- **THEN** the system SHALL immediately yield cached resume items and then update the stream when fresh data is fetched from the API

