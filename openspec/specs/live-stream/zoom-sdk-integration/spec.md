# live-stream/zoom-sdk-integration Specification

## Purpose
Integrates the native Zoom Meeting SDK into the courses lesson viewer to launch native classrooms and capture error logs in Sentry.
## Requirements
### Requirement: Lobby Launch Action
The courses `VideoConferenceViewer` SHALL retrieve the registered `MeetingService` from `meetingServiceProvider` and launch the Zoom classroom when the user taps the join button.

#### Scenario: Joining Zoom meeting from lobby
- **WHEN** user taps the join button with valid Zoom credentials
- **THEN** system calls the meeting service and launches the native Zoom meeting screen

### Requirement: Sentry Exception Logging
The courses `VideoConferenceViewer` SHALL catch any synchronous or asynchronous exceptions thrown during Zoom initialization/authentication, report them to Sentry via `sentryServiceProvider`, and show a toast error message.

#### Scenario: Logging Zoom authentication failure
- **WHEN** Zoom meeting join or authentication fails with an exception
- **THEN** system captures the exception in Sentry and displays an error toast

### Requirement: Dynamic SQLite Support
The application packaging SHALL conditionally resolve native database binaries based on the presence of the Zoom plugin, ensuring standard database compilation when Zoom is disabled.

#### Scenario: Database initialization without Zoom
- **WHEN** app is built without the Zoom dependency
- **THEN** system packages the standard SQLite binary and runs Drift databases successfully

