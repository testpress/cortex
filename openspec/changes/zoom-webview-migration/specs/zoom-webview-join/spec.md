## ADDED Requirements

### Requirement: In-App Zoom WebView Join
The system SHALL allow users to join Zoom live classes using an in-app WebView screen when tapping the "Attend Class" button.

#### Scenario: User taps Attend Class on a Zoom live class
- **WHEN** the user taps "Attend Class" on a running or live Zoom lesson
- **THEN** the system SHALL check and request Camera and Microphone permissions
- **AND** if granted, navigate to the Zoom video conference screen wrapped in `LessonDetailShell`
- **AND** load the Zoom web client join URL with the meeting ID, passcode, and participant display name.

#### Scenario: User denies camera or microphone permissions
- **WHEN** camera or microphone permissions are denied or permanently denied
- **THEN** the system SHALL display a localized error toast indicating permissions are required
- **AND** pop back to the previous screen without attempting to load the meeting.

#### Scenario: Deep link handling in WebView
- **WHEN** the Zoom web page attempts to navigate to a native URI scheme (such as `zoomus://` or `intent://`)
- **THEN** the system SHALL prevent external navigation to keep the session inside the in-app WebView.

#### Scenario: Exiting the meeting
- **WHEN** the user is inside the Zoom WebView screen and taps the back button on `LessonDetailShell`
- **THEN** the WebView SHALL be disposed, releasing camera and microphone media streams, and return the user to the lesson lobby.

#### Scenario: Fallback when meeting cannot join
- **WHEN** the Zoom WebView encounters an unrecoverable loading error or join timeout
- **THEN** the system SHALL report the failure to Sentry and display a localized error toast to the user.
