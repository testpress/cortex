## MODIFIED Requirements

### Requirement: Secure PDF viewing with watermark
The system MUST display a single watermark text diagonally centered on the screen when viewing a PDF document, regardless of backend configuration. Additionally, if the PDF is downloaded by the user, the system MUST permanently stamp the watermark onto the downloaded file unconditionally.

#### Scenario: PDF is loaded in-app
- **WHEN** a user opens a PDF lesson
- **THEN** the system displays the user's username as a semi-transparent, centered background overlay over the document, without checking any institute configuration flags.

#### Scenario: PDF is downloaded
- **WHEN** a user downloads a PDF
- **THEN** the system permanently stamps the watermark text onto every page of the downloaded PDF file unconditionally.
