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

