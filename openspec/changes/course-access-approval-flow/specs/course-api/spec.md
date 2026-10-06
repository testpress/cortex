## MODIFIED Requirements

### Real Course API Integration
The system SHALL fetch real course data from the course API and persist it into the local Drift database, including metadata for categorization, device compatibility, access approval links/labels, and user course completion statistics.

#### Scenario: Fetching courses on Study tab entry
- **WHEN** the user is authenticated and opens the Study tab
- **THEN** the system makes a GET request to `/api/v2.4/courses/` (or paginated catalog endpoints)
- **AND** the response is mapped to `CourseDto`, including `tags`, `tag_ids`, `exams_count`, `allowed_devices`, `external_content_link`, `external_link_label`, and progress/completion metrics from `user_course_credits`
- **AND** the data is upserted into the Drift `CoursesTable` including `externalContentLink` and `externalLinkLabel`
- **AND** the UI observes the Drift stream and reflects the updated data including course registration status and action button labels
