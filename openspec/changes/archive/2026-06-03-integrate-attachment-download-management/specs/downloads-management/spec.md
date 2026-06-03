## MODIFIED Requirements

### Requirement: Background Synchronization
The system SHALL synchronize the local database with the active state upon entering the Downloads screen. This includes verifying the physical existence of attachment files on the device.

#### Scenario: Triggering background sync
- **WHEN** the user navigates to the Downloads screen
- **THEN** the system SHALL trigger a background synchronization via `downloadsBootstrapProvider`.
- **AND** the system SHALL fetch real (non-mocked) active attachments and verify their file existence to remove orphaned database records.
