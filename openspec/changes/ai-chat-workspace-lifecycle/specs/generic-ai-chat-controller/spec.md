## ADDED Requirements

### Requirement: Canonical State Synchronization
The system SHALL synchronize conversation state with LearnLens to refresh generation status and message history without duplicate turn creation.

#### Scenario: Sync canonical state on resume
- **WHEN** canonical synchronization is requested for an active conversation
- **THEN** the controller SHALL fetch conversation status and message history, update the in-memory message list, and resume status polling if generation is still processing.

### Requirement: AI Chat Policy Capabilities
The system SHALL parse and expose learner-level access policy capabilities from the backend session.

#### Scenario: Policy exposes generation permission
- **WHEN** the session policy is parsed
- **THEN** `AiChatPolicyDto` SHALL expose `canGenerate` reflecting whether the student is authorized to send queries.
