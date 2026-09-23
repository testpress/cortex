# assignment-lesson-support Specification

## Purpose
Provides parsing, local persistence, dynamic SSO URL construction using institute domain settings, and protected WebView rendering for Assignment chapter contents.
## Requirements
### Requirement: Assignment Lesson Type Identification
The system SHALL identify content items with content type "Assignment" (or "assignment") as `LessonType.assignment`.

#### Scenario: Identify Assignment from API payload
- **WHEN** raw JSON contains `content_type: "Assignment"`
- **THEN** `LessonDto.fromJson` assigns type `LessonType.assignment`

### Requirement: Safe Merge with Incomplete Detail Responses
The system SHALL preserve assignment type, title, and content URL when an existing assignment lesson is merged with a partial detail response lacking metadata.

#### Scenario: Preserve assignment type on detail merge
- **WHEN** an assignment lesson DTO is merged with a detail DTO having `type: LessonType.unknown`
- **THEN** the merged DTO retains `type: LessonType.assignment`

#### Scenario: Preserve title and contentUrl on detail merge
- **WHEN** an assignment lesson DTO is merged with a detail DTO having empty title or null `contentUrl`
- **THEN** the merged DTO preserves the existing `title` and `contentUrl`

### Requirement: Dynamic Domain and SSO URL Construction
The system SHALL construct the authenticated assignment web URL using dynamic `InstituteSettings.domainUrl` and `UserRepository.getPresignedSsoUrl()` with target destination `/chapters/<chapter_slug>/<content_id>/`.

#### Scenario: Construct assignment SSO URL
- **WHEN** an assignment lesson is launched
- **THEN** the system resolves the formatted `domainUrl` from `InstituteSettings`
- **AND** requests a presigned SSO path from `UserRepository`
- **AND** combines them with `next=/chapters/<chapter_slug>/<content_id>/`

### Requirement: Protected In-App WebView Viewer
The system SHALL display the assignment within an in-app WebView that protects against unauthorized out-of-bounds navigation.

#### Scenario: Allow assignment interaction and block external navigation
- **WHEN** a link or redirect occurs inside the assignment WebView
- **THEN** navigation within the assignment workflow and initial SSO redirection is allowed
- **AND** navigation to unrelated web portal pages or external destinations is prevented

### Requirement: Assignment Local Database Persistence
The system SHALL support storing and retrieving assignment lessons in `LessonsTable`.

#### Scenario: Save and retrieve assignment lesson
- **WHEN** an assignment lesson is saved to `LessonsTable`
- **THEN** `CourseRepository` restores the lesson with `LessonType.assignment` and its `contentUrl`

