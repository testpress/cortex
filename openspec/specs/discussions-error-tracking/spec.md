# discussions-error-tracking Specification

## Purpose
Provides centralized, robust error and exception tracking for the discussions (forums and doubts) module, capturing unexpected database, network, and runtime failures using the shared Sentry service.
## Requirements
### Requirement: Forums Error Tracking
The system SHALL capture unexpected errors, network failures, and parsing errors occurring during forum thread/reply creation or loading and report them to Sentry.

#### Scenario: Failed to post a forum reply
- **WHEN** posting a forum reply fails due to a network or server error
- **THEN** the system catches the exception, reports it to Sentry via the `SentryService` wrapper, and displays an error toast to the user.

#### Scenario: Failed to create a forum post
- **WHEN** creating a forum post fails due to a network or server error
- **THEN** the system catches the exception, reports it to Sentry via the `SentryService` wrapper, resets the submission state, and displays an error toast.

### Requirement: Doubts Error Tracking
The system SHALL capture unexpected errors, network failures, and repository errors during doubt submission or replies and report them to Sentry.

#### Scenario: Failed to submit a doubt
- **WHEN** submitting a new doubt fails due to a network or server error
- **THEN** the system catches the exception, reports it to Sentry, and displays an error toast to the user.

#### Scenario: Failed to submit a doubt reply
- **WHEN** posting a doubt reply fails due to a network or server error
- **THEN** the system catches the exception, reports it to Sentry, and debug-logs the error.

