## ADDED Requirements

### Requirement: Decoupled Attachment Download Execution
The system SHALL manage attachment downloads independently of the UI lifecycle to ensure background completion and database accuracy.

#### Scenario: Download survives UI destruction
- **WHEN** user initiates an attachment download and subsequently closes the attachment viewer screen
- **THEN** the system SHALL continue to download the file in the background
- **AND** the system SHALL update the database with the 'completed' state and file size upon successful download
- **AND** the Downloads dashboard SHALL accurately reflect this completed state without requiring a manual refresh

### Requirement: Centralized Download Services
The system SHALL use a centralized service layer for orchestrating downloads to avoid duplicating network logic in UI components.

#### Scenario: Starting a download via Service
- **WHEN** the user taps the download button on an attachment
- **THEN** the UI SHALL delegate the download tracking and execution to `DownloadsService`
- **AND** `DownloadsService` SHALL push progress updates to `DownloadsRepository` natively
