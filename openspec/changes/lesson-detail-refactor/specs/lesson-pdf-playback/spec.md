## MODIFIED Requirements

### Requirement: Remote PDF Rendering
The system SHALL support rendering PDF lessons from a remote URL via a dedicated `PdfLessonDetailScreen`. The system MUST provide a full-screen viewer which supports zooming and basic navigation for the PDF content, isolated from other content types.

#### Scenario: Rendering PDF content in isolated screen
- **WHEN** a lesson of type "pdf" is opened via the unified `LessonDetailScreen`
- **AND** the `contentUrl` is provided
- **THEN** the system SHALL initialize the `PdfLessonDetailScreen` and display the document in the specialized viewer.
