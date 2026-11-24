## ADDED Requirements

### Requirement: Attachment State Tracking and Submission
The controller SHALL maintain staged attachment state, upload progress, and pass attachment IDs when dispatching conversation turns.

#### Scenario: Dispatching turn with attachment IDs
- **WHEN** sending turn in a new or existing conversation with staged attachments
- **THEN** controller SHALL include the uploaded `attachment_ids` in `startConversation` or `sendFollowUpMessage` payload.

#### Scenario: Gating staging by policy
- **WHEN** `stageAttachment` is invoked while policy specifies `imageAttachmentsEnabled == false`
- **THEN** the controller SHALL ignore the staging request.

### Requirement: Attachment Deletion and Cleanup Logging
The controller SHALL attempt to delete staged attachments from the server when removed or cleared, logging any deletion failure without breaking local state.

#### Scenario: Failed attachment deletion on remove
- **WHEN** `removeAttachment` or `clearStagedAttachments` fails to delete an attachment on the server
- **THEN** the failure SHALL be logged and the local staged state SHALL still be updated cleanly.

#### Scenario: Clean up in-flight attachment upload cancelled before completion
- **WHEN** an attachment upload completes after `clearStagedAttachments` or `removeAttachment` has removed the item from staged state
- **THEN** the controller SHALL immediately delete the uploaded attachment from the server and log any deletion failure.

### Requirement: Guard Message Send on Upload and Ready State
The controller SHALL block sending messages when any attachment is actively uploading or in an error state, and SHALL only submit attachments with valid server IDs.

#### Scenario: Blocking send while uploading or in error
- **WHEN** `sendMessage` is invoked while any staged attachment has `isUploading == true` or `hasError == true`
- **THEN** the controller SHALL return early without dispatching a network turn.

#### Scenario: Submitting only ready attachments
- **WHEN** all staged attachments are ready (`isUploading == false`, `hasError == false`, and `attachmentId != null`)
- **THEN** only valid `attachmentId` strings SHALL be passed to the turn submission and attached to the message.

### Requirement: Upload Content Type Header
The controller SHALL construct `MultipartFile` using `DioMediaType.parse(mimeType)` so image uploads carry their explicit content type header instead of generic binary stream.

#### Scenario: Setting explicit content type on multipart file
- **WHEN** staging an attachment with a given `mimeType`
- **THEN** the uploaded `MultipartFile` SHALL include `contentType` parsed from the specified `mimeType`.

### Requirement: Attachment Upload Retry
The controller SHALL allow retrying failed staged attachment uploads using stored local bytes and MIME type.

#### Scenario: Retrying failed staged attachment upload
- **WHEN** `retryAttachment` is invoked for a staged attachment with `hasError == true`
- **THEN** the controller SHALL reset the attachment state to `isUploading == true` and `hasError == false`, re-attempt the upload with stored bytes and MIME type, and update the attachment ID upon success.
- **AND** concurrent retry calls while `isUploading == true` SHALL be ignored.

#### Scenario: Retrying failed message with attachments
- **WHEN** `retryLastSend` or `retryGeneration` is invoked for a message containing attachments (including image-only messages)
- **THEN** the controller SHALL preserve and re-dispatch the existing attachments with the request.