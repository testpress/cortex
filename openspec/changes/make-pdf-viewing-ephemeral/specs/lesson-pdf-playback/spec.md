## MODIFIED Requirements

### Requirement: Remote PDF Rendering
The system SHALL support rendering PDF lessons directly from a remote URL via `SfPdfViewer.network` in `LessonDetailOrchestrator` without downloading files to local disk. The system MUST provide a viewer which supports zooming and navigation for the PDF content. The system SHALL conditionally present a download button to the user in the header bar for PDF lessons if `allow_download` is permitted and the content is not already downloaded. For attachments, the download action SHALL be presented within the attachment viewer body and suppressed from the header.

#### Scenario: Rendering PDF content in isolated screen
- **WHEN** a lesson of type "pdf" is opened via the router-orchestrated `LessonDetailOrchestrator`
- **AND** the `contentUrl` is provided
- **THEN** the system SHALL stream and display the document directly from the remote URL using `SfPdfViewer.network`.
- **AND** the system SHALL show a loading state while the document is loading over the network.

#### Scenario: Stable rendering when pre-signed query parameters refresh
- **WHEN** an online PDF lesson is loaded or loading
- **AND** the lesson detail provider updates with refreshed pre-signed URL query parameters (expiration or signature) for the same file path
- **THEN** the PDF viewer SHALL continue playback without restarting the document or flickering.

#### Scenario: Rendering download action based on permission and content type
- **WHEN** the `LessonDetailOrchestrator` is initialized for a PDF lesson
- **AND** the lesson metadata indicates `allow_download` is true and the item is not yet downloaded
- **THEN** the system SHALL display a download button in the header.
- **AND** for attachment lessons, the download action SHALL be presented exclusively within `AttachmentViewer`.

### Requirement: Internal Storage Isolation
Explicitly downloaded PDF lessons SHALL be stored in the internal Application Support directory (or platform-appropriate private app storage) to preserve offline availability without polluting public device storage unless explicitly exported.

#### Scenario: Storing PDF on internal storage
- **WHEN** a PDF lesson is explicitly downloaded by the user
- **THEN** the system SHALL save it to the persistent downloads directory and register it in the downloads database with thumbnail and file type metadata.
