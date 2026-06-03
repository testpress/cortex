## ADDED Requirements

### Requirement: Validate Attachment File Existence
The system SHALL validate the physical existence of downloaded attachment files against the local database during background synchronization.

#### Scenario: File exists
- **WHEN** the background synchronization runs
- **THEN** the system SHALL check if the file exists at the expected local path
- **AND** if it exists, the record SHALL be retained in the active downloads list.

#### Scenario: File deleted from OS
- **WHEN** the background synchronization runs
- **THEN** the system SHALL check if the file exists at the expected local path
- **AND** if the physical file is missing, the system SHALL omit the record from the active list
- **AND** the repository synchronization SHALL subsequently delete the orphaned record from the local database.
