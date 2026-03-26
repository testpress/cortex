## ADDED Requirements

### Requirement: Remote PDF Rendering
The system SHALL support rendering PDF lessons from a remote URL. The system MUST provide a full-screen viewer which supports zooming and basic navigation for the PDF content.

#### Scenario: Rendering PDF content from URL
- **WHEN** a lesson of type "pdf" is opened
- **AND** the `contentUrl` is provided
- **THEN** the system SHALL initialize the PDF viewer and display the document
