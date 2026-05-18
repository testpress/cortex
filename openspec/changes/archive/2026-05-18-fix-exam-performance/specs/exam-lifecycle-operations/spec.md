## ADDED Requirements

### Requirement: Heartbeat and Countdown Lifecycle Cleanup
The exam repository and player SHALL stop and cancel all periodic background timers, including the heartbeat timer and countdown timer, when the exam session is reset, exited, or disposed.

#### Scenario: Cancel timers on session reset
- **WHEN** the exam session is reset or repository is disposed
- **THEN** the heartbeat timer and countdown timer SHALL be cancelled and stopped immediately.
