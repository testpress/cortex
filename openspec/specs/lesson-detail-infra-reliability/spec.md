# lesson-detail-infra-reliability Specification

## Purpose
TBD - created by archiving change integrate-lesson-detail-infra. Update Purpose after archive.
## Requirements
### Requirement: Deterministic Lesson Detail Refresh Flow
The lesson-detail provider MUST distinguish between first-load and cached-incomplete refresh flows and expose deterministic outcomes for each path.

#### Scenario: First-load refresh failure
- **WHEN** No local lesson row exists and initial refresh fails
- **THEN** The provider MUST emit an error state.
- **AND** The provider MUST NOT emit a silent loading-only stream.

#### Scenario: Cached incomplete lesson refresh failure
- **WHEN** A local lesson row exists but is incomplete and background refresh fails
- **THEN** The provider MUST surface the refresh error to subscribers.
- **AND** The stream MUST remain recoverable via provider invalidation/retry.

### Requirement: Retry-ready Error Contract
Lesson-detail refresh errors MUST be propagated in a form that allows route/UI layers to present a retry action.

#### Scenario: Route-level retry after provider error
- **WHEN** The route receives an error from lesson-detail provider
- **THEN** It MUST be possible to trigger a retry by invalidating/refetching the provider for the same lesson id.

### Requirement: No Sensitive Logging in Detail Flow
Lesson-detail infrastructure MUST avoid logging sensitive values in diagnostics.

#### Scenario: Initialization and playback diagnostics
- **WHEN** SDK initialization or lesson-detail playback-related diagnostics are emitted
- **THEN** Logs MUST NOT include auth tokens, OTP values, signed media URLs, or raw asset identifiers.

