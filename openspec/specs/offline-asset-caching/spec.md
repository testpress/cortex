# offline-asset-caching Specification

## Purpose
TBD - created by archiving change offline-exam-support. Update Purpose after archive.
## Requirements
### Requirement: Caching and serving HTML assets
The system SHALL download all referenced images and static assets inside an exam's HTML and serve them locally.

#### Scenario: Rendering an offline exam question
- **WHEN** the user opens an offline exam containing `<img src="...">`
- **THEN** the local HTTP server intercepts the request and serves the cached image from the Application Documents directory.

