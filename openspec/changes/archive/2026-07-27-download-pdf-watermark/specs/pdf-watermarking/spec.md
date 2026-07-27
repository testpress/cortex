## MODIFIED Requirements

### Requirement: Secure PDF viewing with watermark
The system MUST display a single watermark text diagonally centered on the screen when viewing a PDF document, regardless of legacy institute configurations. Additionally, if the PDF is downloaded by the user, the system MUST conditionally stamp the watermark onto the downloaded file based on the backend `watermark_before_download` flag.

#### Scenario: PDF is loaded in-app
- **WHEN** a user opens a PDF lesson
- **THEN** the system displays the user's username as a semi-transparent, centered background overlay over the document, without checking any legacy institute configuration flags.

#### Scenario: PDF is downloaded with watermark restriction
- **WHEN** a user downloads a PDF and `watermark_before_download` is `true`
- **THEN** the system permanently stamps the watermark text onto every page of the downloaded PDF file using a background isolate.

#### Scenario: PDF is downloaded without watermark restriction
- **WHEN** a user downloads a PDF and `watermark_before_download` is `false`
- **THEN** the system downloads the raw PDF file directly to public storage without applying any watermarks.
