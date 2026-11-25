# generic-ai-chat-controller Specification

## Purpose
TBD - created by archiving change wire-generic-ai-chat-ui. Update Purpose after archive.
## Requirements
### Requirement: Live Conversation Lifecycle & Turn Dispatch
The system SHALL manage conversational state in Riverpod, coordinating query dispatch, turn creation, and follow-up messaging with `LearnLensRepository`.

#### Scenario: Starting a new conversation
- **WHEN** the user submits a message with no active conversation ID
- **THEN** the controller SHALL generate a unique RFC 4122 v4 UUID request ID, call `repository.startConversation`, save the returned `chat_id`, and update the conversation title and messages.

#### Scenario: Sending a follow-up in an existing conversation
- **WHEN** the user submits a message while a conversation ID is active
- **THEN** the controller SHALL generate a unique request ID, call `repository.sendFollowUpMessage` targeting the active `chat_id`, and append the assistant turn upon completion.

#### Scenario: Optimistic message rendering
- **WHEN** the user initiates a message send
- **THEN** the controller SHALL immediately append the user message to the UI message list in an `isSending: true` state before the network call completes.

### Requirement: In-Flight Status Polling
The system SHALL poll the backend conversation status whenever a submitted turn returns in a `processing` state.

#### Scenario: Poll until completion
- **WHEN** an initial or follow-up response returns with `generation.status == 'processing'`
- **THEN** the controller SHALL periodically poll `repository.getConversationStatus(chatId)` until the status transitions to `completed` and load the reconciled assistant message.

#### Scenario: Handle terminal generation failure
- **WHEN** a polled generation transitions to status `failed`
- **THEN** the controller SHALL halt polling, update the turn to a failure state, and display the returned error message.

#### Scenario: Cancel polling on controller disposal
- **WHEN** the chat controller or screen is disposed while polling is active
- **THEN** all polling timers SHALL be cancelled immediately.

### Requirement: Error Recovery & Idempotent Resubmission
The system SHALL support recovery from send failures, generation failures, and quota exhaustion.

#### Scenario: Send error retry with preserved request ID
- **WHEN** a message submission fails due to a network connection error
- **THEN** the controller SHALL preserve the original `requestId` on the user message and resubmit using the exact same `requestId` upon user retry.

#### Scenario: Generation failure retry
- **WHEN** generation fails and the user taps retry on the assistant failure card
- **THEN** the controller SHALL resubmit the preceding user prompt with a new request ID.

#### Scenario: Quota limit exhaustion handling
- **WHEN** the API returns an HTTP 429 rate limit or quota error
- **THEN** the controller SHALL surface the retry timestamp (`retry_at`) and disable query submissions until the quota window expires.

### Requirement: Canonical State Synchronization
The system SHALL synchronize conversation state with LearnLens to refresh generation status and message history without duplicate turn creation.

#### Scenario: Sync canonical state on resume
- **WHEN** canonical synchronization is requested for an active conversation
- **THEN** the controller SHALL fetch conversation status and message history, update the in-memory message list, and resume status polling if generation is still processing.

#### Scenario: Preserve uncommitted and failed local messages during resume sync
- **WHEN** canonical synchronization completes while local messages with send errors exist
- **THEN** the controller SHALL deduplicate local messages against server messages by `requestId` and append any uncommitted failed messages so that the user retains the ability to retry.

### Requirement: AI Chat Policy Capabilities
The system SHALL parse and expose learner-level access policy capabilities from the backend session.

#### Scenario: Policy exposes generation permission
- **WHEN** the session policy is parsed
- **THEN** `AiChatPolicyDto` SHALL expose `canGenerate` reflecting whether the student is authorized to send queries.

#### Scenario: Mid-session access revocation during send
- **WHEN** a message submission fails with a 403 or student restricted error
- **THEN** the controller SHALL set `hasAccessDenied: true` to surface the access restriction notice and lock the composer.

#### Scenario: Policy re-evaluation on resume
- **WHEN** canonical synchronization runs on application resume
- **THEN** the controller SHALL re-evaluate `policy.canGenerate` and map 403 response errors to `hasAccessDenied: true`.

### Requirement: Conversation Deletion Management
The controller SHALL coordinate with `LearnLensRepository` to delete conversations and reconcile in-memory state.

#### Scenario: Successfully delete conversation
- **WHEN** `deleteConversation(chatId)` is called
- **THEN** the controller SHALL invoke `repository.deleteConversation(chatId)` and remove the conversation from `state.conversations`.

#### Scenario: Deleting active conversation resets canvas
- **WHEN** the deleted conversation matches `state.activeConversationId`
- **THEN** the controller SHALL reset `activeConversationId` to null, clear loaded messages, and reset the state to a clean new chat.

#### Scenario: Deleting inactive conversation preserves active canvas
- **WHEN** the deleted conversation does not match `state.activeConversationId`
- **THEN** the controller SHALL remove the item from history while leaving the currently active conversation and messages intact.

#### Scenario: In-flight generation conflict handling
- **WHEN** conversation deletion is attempted while an AI response is actively generating for that conversation
- **THEN** the system SHALL reject the deletion attempt and prevent data inconsistencies.

#### Scenario: In-flight deletion concurrency guard
- **WHEN** `deleteConversation` is called while another deletion is already in-flight (`isDeletingConversation == true`)
- **THEN** the controller SHALL immediately return `false` without making redundant network calls.

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

