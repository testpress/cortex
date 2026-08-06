# exams-error-tracking Specification

## Purpose
Provides centralized, robust error and exception tracking for the exams module, capturing unexpected database, network, and runtime failures using the shared Sentry service.
## Requirements
### Requirement: Capturing Repository Exceptions
The system SHALL capture all unexpected errors, network request failures, and local processing exceptions occurring within the exams repository layers and report them to Sentry.

#### Scenario: Network failure during standalone exam start
- **WHEN** the user initiates a standalone exam and the API call fails or times out
- **THEN** the system catches the exception and reports it to Sentry via the SentryService wrapper with the appropriate error details

#### Scenario: Failure during answer submission flushing
- **WHEN** the system attempts to flush pending answers from the queue to the backend server and a network or mapping exception is encountered
- **THEN** the system reports the exception to Sentry, rolling back local state if necessary

#### Scenario: Heartbeat query failure
- **WHEN** a background heartbeat check fails due to an unexpected connection or response issue
- **THEN** the system logs the failure to Sentry as a warning to ensure monitoring of active exam session integrity

### Requirement: Capturing Provider & Screen Failures
The system SHALL capture unhandled exceptions within the exams providers and screen components to prevent silent failure states.

#### Scenario: Failed download of offline exam assets
- **WHEN** the user attempts to download an exam for offline use and asset downloading or filesystem caching fails
- **THEN** the system reports the failure to Sentry and notifies the user via Toast

#### Scenario: Database analytical page fetch failure
- **WHEN** retrieving subject analytics data from the remote source and parsing or saving to the local Drift database fails
- **THEN** the system reports the error to Sentry and rethrows to be handled by the UI pagination state

