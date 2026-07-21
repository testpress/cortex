# error-tracking Specification

## Purpose
TBD - created by archiving change add-sentry-error-tracking. Update Purpose after archive.
## Requirements
### Requirement: Global Network Error Tracking
The system SHALL capture any network request that throws an unhandled exception or DioException through the global `network_utils` request handler.

#### Scenario: Unhandled network failure
- **WHEN** a network request using `performNetworkRequest` fails and throws a DioException or unexpected error
- **THEN** the error is captured and reported to Sentry using the global `onNetworkErrorCapture` hook.

### Requirement: Isolate Background Sync Crash Tracking
The system SHALL initialize Sentry explicitly inside any Workmanager background isolates to ensure that crashes during offline syncs are captured correctly.

#### Scenario: Background sync encounters fatal error
- **WHEN** the `OfflineExamSyncWorker` background task throws an unhandled exception during execution
- **THEN** the error is caught by the isolate's initialized `SentryService` and reported accurately.

### Requirement: Sentry Decoupling
The system SHALL abstract Sentry types (such as `SentryLevel` and `SentryNavigatorObserver`) inside `core`'s `SentryService` to prevent tight coupling of domain packages to `sentry_flutter`.

#### Scenario: App routing uses navigation observer
- **WHEN** the app initializes its router in the `testpress` package
- **THEN** it creates the observer via `SentryService.createNavigatorObserver()` without importing `sentry_flutter`.

#### Scenario: Package throws an error with a specific severity
- **WHEN** a domain package like `testpress` needs to report an error with a warning level
- **THEN** it uses `AppErrorLevel.warning` instead of `SentryLevel.warning`.

