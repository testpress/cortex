## MODIFIED Requirements

### Requirement: Background Synchronization
The system SHALL synchronize the local database with the active state upon entering the Downloads screen, and actively listen to real-time streams for ongoing SDK downloads.

#### Scenario: Triggering background sync
- **WHEN** the user navigates to the Downloads screen
- **THEN** the system SHALL trigger a background synchronization via `downloadsBootstrapProvider` or equivalent initialization.
- **AND** the system SHALL fetch real (non-mocked) active attachments and verify their file existence to remove orphaned database records.
- **AND** the system SHALL fetch real (non-mocked) active video downloads from `TPStreamsDownloadManager.getAllDownloads()`.

#### Scenario: Real-time synchronization
- **WHEN** the SDK broadcasts an update via `downloadsStream`
- **THEN** the system SHALL map the `DownloadAsset` to a domain `DownloadItem` and update the local database reactively.
