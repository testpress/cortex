## ADDED Requirements

### Requirement: Open Ask Doubt Form from Lesson Detail
The system SHALL display an "Ask Doubt" floating action button (FAB) in the `LessonDetailOrchestrator` when a supported lesson is rendered and completed loading. Tapping the FAB SHALL open the `AskDoubtFormScreen`, passing the current lesson's ID and title as context.

#### Scenario: User opens the doubt form
- **WHEN** the user taps the "Ask Doubt" FAB
- **THEN** the system navigates to the AskDoubtFormScreen and displays the lesson title in a contextual badge at the top of the form

### Requirement: Submit Doubt Associated with Lesson
The system SHALL submit the doubt with the associated lesson's ID as `chapter_content` in the API payload. Upon successful submission, the system SHALL navigate the user back to the lesson detail screen and show a success toast.

#### Scenario: User submits a doubt successfully
- **WHEN** the user submits the form with valid input
- **THEN** the doubt is created via `POST /api/v3/helpdesk/` with `chapter_content` set to the lesson ID
- **THEN** the user is navigated back to the lesson detail view
- **THEN** a success toast is displayed
- **THEN** the FAB remains visible to allow further doubts
