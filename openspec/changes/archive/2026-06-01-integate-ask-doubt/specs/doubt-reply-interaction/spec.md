## ADDED Requirements

### Requirement: Attachment File Upload in Reply
The reply composer SHALL support uploading image attachments to `/api/v3/upload-image/` with `uploaded_for: "doubts"` and `uploaded_for_object_id` set to the ticket's ID.
- **Embedding**: On successful upload, the returned URL SHALL be formatted as an HTML `<img>` tag and appended to the reply body.

#### Scenario: Attaching image to reply
- **GIVEN** the student adds an image to a reply
- **WHEN** the upload succeeds
- **THEN** the image tag is inserted into the reply text body

## MODIFIED Requirements

### Requirement: Persistent Reply Composer
The system SHALL anchor a reply composer at the bottom of the doubt detail thread if the status is not `"Closed"`.
- **Closed Status**: If the doubt's status is `"Closed"`, the composer SHALL be hidden or disabled, displaying a read-only locked message instead.

#### Scenario: Replying to a closed doubt
- **GIVEN** the student opens a doubt with status "Closed"
- **WHEN** they look at the bottom of the screen
- **THEN** the reply input field is disabled or hidden and a locked thread notification is shown

### Requirement: Reply Submission and Feedback
The system SHALL post follow-up comments to the backend `/api/v3/helpdesk/<pk>/followup/` endpoint.
- **Status Change**: Posting a reply to a doubt that is currently `"Resolved"` SHALL automatically revert the doubt's local and remote status back to `"Active"`.

#### Scenario: Replying to a resolved doubt
- **GIVEN** a doubt's status is "Resolved"
- **WHEN** the student posts a reply
- **THEN** the comment is saved and the status transitions to "Active"
