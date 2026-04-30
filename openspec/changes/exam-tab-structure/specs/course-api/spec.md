## MODIFIED Requirements

### Requirement: Real Course API Integration
The system SHALL fetch real course data from the course API and persist it into the local Drift database, including metadata for categorization and device compatibility.

#### Scenario: Fetching courses on Study tab entry
- **WHEN** the user is authenticated and opens the Study tab
- **THEN** the system makes a GET request to `/api/v3/courses/` (or the equivalent version providing tags and device data)
- **AND** the response is mapped to `CourseDto`, including `tags` and `allowed_devices`
- **AND** the data is upserted into the Drift `CoursesTable`
- **AND** the UI observes the Drift stream and reflects the updated data
