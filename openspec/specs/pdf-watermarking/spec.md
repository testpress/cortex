# pdf-watermarking Specification

## Purpose
TBD - created by archiving change add-pdf-watermark. Update Purpose after archive.
## Requirements
### Requirement: Global access to current user profile
The system SHALL expose the current authenticated user's profile globally so that components can read it without making direct database calls.

#### Scenario: User is logged in
- **WHEN** the user is authenticated and viewing content
- **THEN** the system provides immediate access to their profile (username, name)

### Requirement: Secure PDF viewing with watermark
The system MUST display a single watermark text diagonally centered on the screen when viewing a PDF document.

#### Scenario: PDF is loaded
- **WHEN** a user opens a PDF lesson
- **THEN** the system displays the user's username as a semi-transparent, centered background overlay over the document

### Requirement: Unobstructed document interaction
The watermark overlay SHALL NOT block touch events.

#### Scenario: User interacts with watermarked PDF
- **WHEN** the user scrolls or zooms the PDF
- **THEN** the interactions behave normally as if the watermark was not present

