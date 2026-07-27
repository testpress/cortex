## MODIFIED Requirements

### Requirement: Remote PDF Rendering
The system SHALL support rendering PDF lessons from a remote URL via a dedicated `LessonDetailOrchestrator`. The system MUST provide a full-screen viewer which supports zooming and basic navigation for the PDF content, isolated from other content types. The system SHALL rely on the internal cache and SHALL NOT show a download progress bar during document initialization. The system SHALL conditionally present a download button to the user to save the PDF to their public device storage if `allow_download` is permitted.

#### Scenario: Rendering PDF content in isolated screen
- **WHEN** a lesson of type "pdf" is opened via the router-orchestrated `LessonDetailOrchestrator`
- **AND** the `contentUrl` is provided
- **THEN** the system SHALL initialize the `LessonDetailOrchestrator` and display the document in the specialized viewer.
- **AND** the system SHALL NOT show an explicit download progress bar, but only a simple loading state if the file is not yet cached.

#### Scenario: Rendering download action based on permission
- **WHEN** the `LessonDetailOrchestrator` is initialized
- **AND** the lesson metadata indicates `allow_download` is true
- **THEN** the system SHALL display a download button in the header.
