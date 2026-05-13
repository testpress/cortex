## MODIFIED Requirements

### Requirement: Info Resource Catalog
The system SHALL provide an Info landing page that lists curated learning-resource courses fetched dynamically from the API using the `tags=info` filter.

#### Scenario: Displaying the Info landing page
- **WHEN** an enabled client opens the Info tab
- **THEN** the system MUST fetch courses using `GET /api/v3/courses/?tags=info`
- **AND** render a resource list screen titled `Learning Resources`
- **AND** each resource card MUST show a thumbnail and course title (using standard `CourseDto` data)
- **AND** the list MUST support pagination and scroll-to-refresh.

### Requirement: Course Video Drill-In
The system SHALL let users open a course-specific curriculum list (Chapters -> Lessons) from the Info landing page.

#### Scenario: Opening a resource course
- **WHEN** the user selects a course card from the Info landing page
- **THEN** the system MUST navigate to the standard hierarchical course-detail view
- **AND** the detail view MUST display the course chapters and lessons using existing curriculum widgets.

### Requirement: Inline Hierarchical Playback
The system SHALL support inline playback of Info lessons within the app using the standard curriculum infrastructure, replacing the legacy external launch behavior.

#### Scenario: Playing an Info lesson
- **WHEN** the user selects a lesson from the Info course detail view
- **THEN** the system MUST open the lesson in the standard `LessonDetailOrchestrator`
- **AND** support all standard lesson types (Video, PDF, HTML) with native playback.
