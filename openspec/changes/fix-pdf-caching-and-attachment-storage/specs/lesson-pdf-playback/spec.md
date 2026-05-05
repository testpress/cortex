## MODIFIED Requirements

### Requirement: Remote PDF Rendering
The system SHALL support rendering PDF lessons from a remote URL via a dedicated `PdfLessonDetailScreen`. The system MUST provide a full-screen viewer which supports zooming and basic navigation for the PDF content, isolated from other content types. The system SHALL rely on the internal cache and SHALL NOT show a download progress bar during document initialization.

#### Scenario: Rendering PDF content in isolated screen
- **WHEN** a lesson of type "pdf" is opened via the router-orchestrated `PdfLessonDetailScreen`
- **AND** the `contentUrl` is provided
- **THEN** the system SHALL initialize the `PdfLessonDetailScreen` and display the document in the specialized viewer.
- **AND** the system SHALL NOT show an explicit download progress bar, but only a simple loading state if the file is not yet cached.

## ADDED Requirements

### Requirement: Internal Storage Isolation
PDF lessons SHALL be stored in the internal Application Support directory to prevent them from being visible to the user or other applications.

#### Scenario: Storing PDF on internal storage
- **WHEN** a PDF lesson is downloaded for caching
- **THEN** the system SHALL save it to the `getApplicationSupportDirectory()`.
