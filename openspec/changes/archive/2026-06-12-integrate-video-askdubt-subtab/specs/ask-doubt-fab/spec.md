## MODIFIED Requirements

### Requirement: Open Ask Doubt Form from Lesson Detail
The system SHALL display an "Ask Doubt" floating action button (FAB). For non-video completed lessons (`LessonDetailOrchestrator`), it SHALL be displayed globally in the shell. For video lessons (`VideoLessonDetailScreen` / `VideoLessonViewer`), it SHALL be constrained within the "Ask Doubt" subtab itself to avoid obstructing other subtab content. Tapping the FAB SHALL open the `AskDoubtFormScreen`, passing the current lesson's ID and title as context.

#### Scenario: User opens the doubt form from non-video lesson
- **WHEN** the user is viewing a supported non-video lesson (e.g., pdf, notes) that is completed
- **THEN** the system displays the "Ask Doubt" FAB globally at the bottom right of the screen
- **WHEN** the user taps the FAB
- **THEN** the system navigates to the AskDoubtFormScreen

#### Scenario: User opens the doubt form from a video lesson
- **WHEN** the user is viewing a video lesson and has selected the "Ask Doubt" subtab
- **THEN** the system displays the "Ask Doubt" FAB constrained within the Doubt Tab's scroll view
- **WHEN** the user taps the FAB
- **THEN** the system navigates to the AskDoubtFormScreen
