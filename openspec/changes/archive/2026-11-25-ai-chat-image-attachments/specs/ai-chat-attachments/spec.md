## ADDED Requirements

### Requirement: Image Attachment Upload and Staging
The system SHALL allow users to select images from device camera or gallery, crop them with `AppImageCropper`, automatically upload them to the LearnLens attachments API, and stage them for turn submission.

#### Scenario: Staging an image attachment
- **WHEN** user selects and crops an image from camera or gallery
- **THEN** system uploads the image via `POST /generic/attachments/`, assigns an `attachment_id`, and stages the preview in the composer.

#### Scenario: Deleting an unsent image attachment
- **WHEN** user taps the remove button on a staged image chip in the composer
- **THEN** system removes the chip from state and calls `DELETE /generic/attachments/{attachment_id}/` to clean up the backend resource.

#### Scenario: Submitting turn with attachments
- **WHEN** user submits a message with staged attachments
- **THEN** system includes the array of `attachment_ids` in the turn payload and resets the staged attachments list upon send.
