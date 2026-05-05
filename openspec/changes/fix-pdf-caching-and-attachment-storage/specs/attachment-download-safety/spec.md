## MODIFIED Requirements

### Requirement: Public Downloads Persistence
Attachment files MUST be stored in the public Downloads directory of the device to ensure they are accessible to the user outside of the application.

#### Scenario: Saving attachment to public Downloads
- **WHEN** an attachment download completes
- **THEN** the file MUST be saved to the system's public Downloads directory.
- **AND** the system SHALL register the file with the media scanner to ensure visibility.
