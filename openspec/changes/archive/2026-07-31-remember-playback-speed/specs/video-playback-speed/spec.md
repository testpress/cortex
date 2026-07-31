## ADDED Requirements

### Requirement: Remember Playback Speed Toggle
The system SHALL provide a Remember Playback Speed setting that enables or disables playback speed persistence.

#### Scenario: Default toggle state for new users
- **WHEN** a new user opens the application for the first time
- **THEN** the Remember Playback Speed setting MUST be disabled by default

#### Scenario: Persisting toggle selection
- **WHEN** the user toggles the Remember Playback Speed setting
- **THEN** the system MUST persist the setting across application sessions

#### Scenario: Disabled persistence
- **WHEN** the Remember Playback Speed setting is disabled
- **THEN** every video MUST start at the default speed (1x)
- **AND** playback speed changes MUST NOT be persisted
- **AND** any previously saved playback speed MUST be ignored

### Requirement: Global Playback Speed Restore
The system SHALL restore the last-used global playback speed when a video loads, while the Remember Playback Speed setting is enabled.

#### Scenario: Restoring the remembered speed
- **WHEN** the user opens a video and a remembered playback speed is saved
- **THEN** the video MUST start playing at the remembered speed
- **AND** the system MUST NOT display a confirmation dialog

#### Scenario: No remembered speed
- **WHEN** the user opens a video and no playback speed has been remembered yet
- **THEN** the video MUST start playing at the default speed (1x)

#### Scenario: Saving the current speed
- **WHEN** the user changes the playback speed while watching a video
- **AND** the Remember Playback Speed setting is enabled
- **THEN** the system MUST save the new speed as the global playback speed
- **AND** subsequently opened videos MUST start at that speed

### Requirement: Restored Speed Notification
The system SHALL display a temporary, non-blocking notification when a remembered playback speed is restored.

#### Scenario: Non-blocking speed indication
- **WHEN** a video starts playing with a remembered speed other than the default
- **THEN** the system SHALL show a temporary notification indicating the restored speed (e.g. "Playing at 3x")
- **AND** the notification MUST NOT block or interrupt video playback
- **AND** the notification MUST auto-dismiss without requiring user interaction

#### Scenario: Reset from restored speed notification
- **WHEN** the user taps the "Reset" action on the restored speed notification
- **THEN** the system MUST immediately change the playback speed of the current video to 1x
- **AND** the system MUST update the remembered playback speed to 1x
- **AND** subsequently opened videos MUST start at the default speed

### Requirement: Playback Speed Restoration Timing
The system SHALL apply the remembered playback speed without delaying or interrupting video playback.

#### Scenario: Immediate speed application
- **WHEN** the video player controller is created
- **THEN** the system MUST apply the effective playback speed as soon as possible during player initialization
- **AND** playback MUST continue without requiring user interaction

#### Scenario: Instant application of user changes
- **WHEN** the user selects a playback speed in the player
- **THEN** the system MUST immediately apply the selected speed to the currently playing video
- **AND** persist it as the global playback speed while the Remember Playback Speed setting is enabled
