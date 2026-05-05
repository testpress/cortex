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

### Requirement: Silent Background Caching for PDFs
The system SHALL support silent pre-fetching and caching of PDF lesson content in the background to ensure sub-second viewing.

#### Scenario: Background pre-fetch success
- **WHEN** a PDF lesson's metadata is fetched from the network
- **THEN** the system SHALL initiate a background download of the content if not already cached.
- **AND** it SHALL save the file to an internal, app-scoped cache directory.
- **AND** it SHALL NOT show a progress bar to the user during this background process.

