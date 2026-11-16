## ADDED Requirements

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
