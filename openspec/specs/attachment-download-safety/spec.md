# attachment-download-safety Specification

## Purpose
TBD - created by archiving change integrate-lesson-detail-infra. Update Purpose after archive.
## Requirements
### Requirement: Exception-safe Attachment Download Handling
Attachment download failure handling MUST NOT assume a single exception type and MUST avoid crash-prone forced casts.

#### Scenario: Non-Dio exception during download
- **WHEN** Download flow throws an exception that is not `DioException`
- **THEN** The viewer MUST transition to an error state.
- **AND** The viewer MUST NOT crash due to type casting.

#### Scenario: Cancelled download
- **WHEN** Download request is cancelled
- **THEN** Cancellation MUST be detected safely.
- **AND** The viewer MUST NOT treat cancellation as a terminal error.

### Requirement: Scoped-storage-compatible File Persistence
Attachment files MUST be stored in app-scoped directories compatible with modern Android scoped storage.

#### Scenario: Saving attachment on Android
- **WHEN** A download completes on Android
- **THEN** The file MUST be saved to an app-scoped storage directory.
- **AND** The flow MUST NOT require legacy external storage permissions.

### Requirement: External Open Compatibility
Attachment files saved in app-scoped storage MUST remain openable through external viewer apps via a secure URI-sharing contract.

#### Scenario: Open in external viewer
- **WHEN** A user taps to open a downloaded attachment
- **THEN** The app MUST invoke an open/share mechanism that grants temporary read access to the target app.
- **AND** It MUST NOT rely on raw file-path access that can fail with permission-denied on modern Android.

