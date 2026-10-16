## ADDED Requirements

### Requirement: Progressive Streamed Turn Lifecycle
The system SHALL stream assistant answers progressively on Android and iOS while keeping the JSON turn path on Web.

#### Scenario: Immediate user message and provisional assistant message
- **WHEN** the user submits a message with streaming enabled
- **THEN** the user message SHALL appear immediately in a sending state, and on `accepted` the controller SHALL save `chat_id`, title, and `user_message_id` and insert a provisional assistant message in a streaming state.

#### Scenario: Appending deltas
- **WHEN** `delta` events arrive
- **THEN** the controller SHALL append each `text` piece to the provisional assistant message in arrival order.

#### Scenario: Completion replaces provisional text
- **WHEN** a `done` event arrives with status `completed`
- **THEN** the controller SHALL replace the provisional text with `done.answer`, assign the persisted assistant message ID, update the title, and clear the generating state without duplicating content.

#### Scenario: Completion with generation failure
- **WHEN** a `done` event arrives with status `failed`
- **THEN** the controller SHALL discard the provisional text, show the generation failure card with `error_message`, and keep the user's message visible.

#### Scenario: Completion still processing
- **WHEN** a `done` event arrives with status `processing`
- **THEN** the controller SHALL start conversation status polling and reconcile messages from history on completion.

#### Scenario: Web keeps JSON behavior
- **WHEN** the app runs on Web
- **THEN** the controller SHALL use the existing JSON turn routes and behavior without change.

### Requirement: Streamed Failure Recovery
The system SHALL recover uncertain streamed submissions without creating duplicate messages or new request IDs.

#### Scenario: Error event or disconnect with known conversation
- **WHEN** the stream emits `error`, ends without `done`, or fails with a timeout or connection error after `chat_id` is known
- **THEN** the controller SHALL read conversation status and reconcile from message history, show the failure card on `failed`, or start polling on `processing`.

#### Scenario: Uncertain outcome without a conversation ID
- **WHEN** the stream fails before `chat_id` is known or the recovery read fails
- **THEN** the controller SHALL mark the user message as a send error, preserve its original `request_id`, and NOT automatically resubmit.

#### Scenario: Retry keeps the original route
- **WHEN** the user retries an uncertain first-message submission after its `chat_id` was learned
- **THEN** the controller SHALL replay with the same `request_id` on the first-message route rather than the follow-up route.

#### Scenario: Pre-stream rejection
- **WHEN** the streaming route rejects the request before streaming starts (401, 409, 422, 429)
- **THEN** the controller SHALL apply the existing send-error and quota handling without exposing raw exceptions.

### Requirement: Stream Isolation Across Conversations
The system SHALL ensure streamed events cannot modify a conversation other than the one that started them.

#### Scenario: Switching conversation mid-stream
- **WHEN** the user selects another conversation or starts a new chat while a stream is active
- **THEN** subsequent events from the old stream SHALL be ignored and SHALL NOT alter the new conversation state.

#### Scenario: Duplicate submission guard
- **WHEN** a stream is active for the current conversation
- **THEN** further submissions SHALL be ignored until the stream completes or fails.
