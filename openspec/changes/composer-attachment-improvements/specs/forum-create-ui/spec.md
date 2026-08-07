## MODIFIED Requirements

### Requirement: Image Attachment UI
**Renamed to**: File Attachment UI
The system SHALL allow users to attach up to 3 files (images, PDFs, doc, docx, txt) to the post.
- Each attachment MUST display a preview chip or pill with a remove action.
- Image files MUST display an image preview thumbnail. Non-image files (like PDFs) MUST display a file type icon representation instead.
- The attachment action MUST be disabled once the limit of 3 files is reached.

#### Scenario: Attaching an image
- **WHEN** user picks an image from the gallery/picker
- **THEN** the image SHALL appear in the attachment preview section with a remove (X) button

#### Scenario: Attaching a document file
- **WHEN** user picks a PDF or text file from the file picker
- **THEN** the file SHALL appear in the attachment preview section showing a document icon and a remove (X) button
