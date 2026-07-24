## ADDED Requirements

### Requirement: Conditional PDF Download Capability
The system SHALL provide the capability to download PDF lessons directly from the viewer if the backend specifically permits it. The system MUST evaluate the `allow_download` flag provided by the backend response to determine if the download action is available to the user. When downloaded, the file MUST be saved to the user's public file system (e.g., Downloads directory) to ensure it is accessible outside the app.

#### Scenario: PDF download is permitted
- **WHEN** a user opens a PDF lesson where `allow_download` is `true`
- **THEN** the system SHALL display a download action button in the viewer's UI.

#### Scenario: PDF download is restricted
- **WHEN** a user opens a PDF lesson where `allow_download` is `false` or missing
- **THEN** the system SHALL hide or disable the download action button in the viewer's UI.

#### Scenario: Saving PDF to public storage on explicit download
- **WHEN** the user taps the download icon
- **THEN** the system SHALL process the watermark and save the resulting file to a public directory (e.g., the user's Downloads folder) where they can access it externally.
