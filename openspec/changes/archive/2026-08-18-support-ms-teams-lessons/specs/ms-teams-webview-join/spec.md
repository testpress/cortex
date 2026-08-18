## ADDED Requirements

### Requirement: MS Teams WebView Join
The system SHALL allow users to join MS Teams lessons using an in-app web view when tapping the "Attend Class" button.

#### Scenario: User clicks Attend Class on a Teams lesson
- **WHEN** the user taps "Attend Class" on a Video Conference lesson with the "teams" provider
- **THEN** the app requests Camera and Microphone permissions
- **AND** if granted, pushes a full-screen WebView loading the lesson's join URL wrapped in the standard `LessonDetailShell`
- **AND** the WebView permits necessary navigation redirects required by the MS Teams join flow

#### Scenario: User denies camera/microphone permissions
- **WHEN** the user denies permissions (or they are permanently denied)
- **THEN** the app displays a localized error toast ("Camera and microphone access is required. Enable them in Settings to join.")
- **AND** the app automatically pops the screen, returning the user to the syllabus

#### Scenario: User needs to exit the meeting
- **WHEN** the user is inside the Teams WebView (pre-join lobby or active call)
- **THEN** they can tap the native back button provided by the `LessonDetailShell` header to reliably exit the screen at any time

#### Scenario: Auto-join script fails
- **WHEN** the injected JavaScript for bypassing the Teams lobby fails
- **THEN** the error is silently reported to Sentry for tracking without disrupting the user's manual fallback flow
