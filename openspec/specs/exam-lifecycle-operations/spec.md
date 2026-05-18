# exam-lifecycle-operations Specification

## Purpose
TBD - created by archiving change exam-api-contract. Update Purpose after archive.
## Requirements
### Requirement: Exam Action Operations
The `DataSource` interface and its implementations (`HttpDataSource`, `MockDataSource`) SHALL support retrieving attempts and initiating/ending sections.

#### Scenario: Start and End Section Lifecycle
- **WHEN** `startSection` is called with a section ID or URL
- **WHEN** `endSection` is called with a section ID or URL
- **THEN** the API returns the updated section/attempt payload successfully

### Requirement: Heartbeat and Countdown Lifecycle Cleanup
The exam repository and player SHALL stop and cancel all periodic background timers, including the heartbeat timer and countdown timer, when the exam session is reset, exited, or disposed.

#### Scenario: Cancel timers on session reset
- **WHEN** the exam session is reset or repository is disposed
- **THEN** the heartbeat timer and countdown timer SHALL be cancelled and stopped immediately.

