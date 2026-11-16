## ADDED Requirements

### Requirement: App Lifecycle Resumption Sync
The system SHALL monitor application lifecycle state changes and trigger canonical conversation state synchronization when returning to the foreground.

#### Scenario: App returns to foreground with active chat
- **WHEN** the host application lifecycle changes to `AppLifecycleState.resumed` while `AiScreen` is mounted
- **THEN** the screen SHALL request the controller to refresh the canonical conversation status and messages.

### Requirement: Stopped Generation Message Display
The system SHALL display an assistant response that was stopped with its retained partial text and clear non-error stopped visual indicator.

#### Scenario: Rendering a stopped response
- **WHEN** an assistant message has generation status `stopped`
- **THEN** the system SHALL render the partial answer Markdown and display a subtle "Stopped" label below the card, omitting error cards and retry prompts.

### Requirement: Assistant Message Card State Modeling
The system SHALL model assistant message visual states using an explicit enum status to prevent conflicting state representations.

#### Scenario: Visual status resolution
- **WHEN** an assistant card renders
- **THEN** it SHALL resolve its rendering mode from an explicit `AiAssistantStatus` (completed, generating, failed, stopped).

### Requirement: Access Restriction Notice Display
The system SHALL display a prominent access restriction card when the learner's policy disallows generation.

#### Scenario: Displaying restricted access card
- **WHEN** learner access policy indicates `can_generate == false`
- **THEN** the system SHALL render a dedicated access card with a lock icon, bold title ("AI chat not available"), explanatory text directing them to contact their administrator, and lock the composer.
