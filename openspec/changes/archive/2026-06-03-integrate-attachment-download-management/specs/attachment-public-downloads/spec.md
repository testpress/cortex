## MODIFIED Requirements

### Requirement: Public Downloads Persistence
Attachment files MUST be explicitly downloaded and stored in the public Downloads directory of the device to ensure they are accessible to the user outside of the application. The download MUST be registered with the central `DownloadsRepository`.

#### Scenario: Saving attachment to public Downloads
- **WHEN** a user initiates an attachment download
- **THEN** the system MUST display the download progress.
- **AND** the system SHALL register the download with the central `DownloadsRepository` to track its progress and metadata.
- **AND** upon completion, the file MUST be saved to the system's public Downloads directory.
- **AND** the system SHALL register the file with the media scanner to ensure external visibility.
