# lesson-background-caching Specification

## Purpose
TBD - created by archiving change fix-pdf-caching-and-attachment-storage. Update Purpose after archive.
## Requirements
### Requirement: Centralized File Downloader
The system SHALL utilize a centralized FileDownloader utility to manage all file downloads, path resolution, and storage permissions, isolating UI components from filesystem infrastructure.

#### Scenario: Resolving local paths via centralized utility
- **GIVEN** a remote file URL and a storage category (Internal vs Public)
- **WHEN** the system requests a local storage path
- **THEN** the FileDownloader SHALL return a platform-appropriate directory.
- **AND** it SHALL ensure the directory is created if it does not exist.

