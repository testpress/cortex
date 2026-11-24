## ADDED Requirements

### Requirement: Attachment State Tracking and Submission
The controller SHALL maintain staged attachment state, upload progress, and pass attachment IDs when dispatching conversation turns.

#### Scenario: Dispatching turn with attachment IDs
- **WHEN** sending turn in a new or existing conversation with staged attachments
- **THEN** controller SHALL include the uploaded `attachment_ids` in `startConversation` or `sendFollowUpMessage` payload.

### Requirement: Attachment Deletion and Cleanup Logging
The controller SHALL attempt to delete staged attachments from the server when removed or cleared, logging any deletion failure without breaking local state.

#### Scenario: Failed attachment deletion on remove
- **WHEN** `removeAttachment` or `clearStagedAttachments` fails to delete an attachment on the server
- **THEN** the failure SHALL be logged and the local staged state SHALL still be updated cleanly.

### Requirement: Guard Message Send on Upload and Ready State
The controller SHALL block sending messages when any attachment is actively uploading or in an error state, and SHALL only submit attachments with valid server IDs.

#### Scenario: Blocking send while uploading or in error
- **WHEN** `sendMessage` is invoked while any staged attachment has `isUploading == true` or `hasError == true`
- **THEN** the controller SHALL return early without dispatching a network turn.

#### Scenario: Submitting only ready attachments
- **WHEN** all staged attachments are ready (`isUploading == false`, `hasError == false`, and `attachmentId != null`)
- **THEN** only valid `attachmentId` strings SHALL be passed to the turn submission and attached to the message.


