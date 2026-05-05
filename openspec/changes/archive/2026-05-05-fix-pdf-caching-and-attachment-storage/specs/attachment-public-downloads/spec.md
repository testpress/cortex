## ADDED Requirements

### Requirement: Public Downloads Persistence
Attachment files MUST be explicitly downloaded and stored in the public Downloads directory of the device to ensure they are accessible to the user outside of the application.

#### Scenario: Saving attachment to public Downloads
- **WHEN** a user initiates an attachment download
- **THEN** the system MUST display the download progress.
- **AND** upon completion, the file MUST be saved to the system's public Downloads directory.
- **AND** the system SHALL register the file with the media scanner to ensure external visibility.

### Requirement: Storage Permission Handling
The system SHALL request and handle the necessary runtime storage permissions to write to public directories on Android.

#### Scenario: Requesting permissions
- **WHEN** an attachment download is triggered on Android
- **THEN** the system SHALL check and request `WRITE_EXTERNAL_STORAGE` or appropriate media permissions via the centralized FileDownloader.
- **AND** if denied, the download SHALL fail gracefully.
