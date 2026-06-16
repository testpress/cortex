## MODIFIED Requirements

### Requirement: Real Course API Integration
The system SHALL fetch real course data from the course API and persist it into the local Drift database, including metadata for categorization, device compatibility, and user course completion statistics.

#### Scenario: Fetching courses on Study tab entry
- **WHEN** the user is authenticated and opens the Study tab
- **THEN** the system makes a GET request to `/api/v3/courses/`
- **AND** the response is mapped to `CourseDto`, including `tags`, `tag_ids`, `exams_count`, `allowed_devices`, and progress/completion metrics from `user_course_credits` (`course_completion_percentage` and `total_unique_attempts` mapped by `course_id`)
- **AND** the data is upserted into the Drift `CoursesTable`
- **AND** the UI observes the Drift stream and reflects the updated data including course completion percentage and lessons progress ratio
