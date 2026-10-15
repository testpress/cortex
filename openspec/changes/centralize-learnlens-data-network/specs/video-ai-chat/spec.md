## MODIFIED Requirements

### Requirement: AI Chat Session Authentication
The system SHALL authenticate with the LearnLens API by delegating lesson session acquisition and request execution to the centralized LearnLens data layer in `packages/core`.

#### Scenario: Video Lesson AI Session Delegation
- **WHEN** the user opens an AI-enabled video lesson
- **THEN** `packages/courses` SHALL delegate session creation and token lifecycle to `packages/core`'s `LearnLensSessionManager` and `LearnLensRepository`.
