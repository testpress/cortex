# video-playback-speed Specification

## Purpose
TBD - created by archiving change remember-playback-speed. Update Purpose after archive.

## Requirements

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
- **WHEN** a subsequently opened video starts playing and restores a remembered speed other than the default (1x)
- **THEN** the system SHALL show a temporary notification indicating the restored speed with uppercase multiplier notation (e.g. "Playing at 3X")
- **AND** the notification MUST NOT appear on the currently playing video where the speed was originally chosen
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

### Requirement: In-Player Remember Playback Speed Prompt
The system SHALL display an in-player contextual prompt when the user changes playback speed on a video while the Remember Playback Speed setting is disabled.

#### Scenario: Displaying prompt on non-default speed change
- **WHEN** the user changes the playback speed to any value other than 1x during video playback
- **AND** the Remember Playback Speed setting is disabled
- **AND** the prompt has not been dismissed previously
- **THEN** the system MUST display an in-player prompt offering to remember the speed for future videos

#### Scenario: Accepting the prompt
- **WHEN** the user selects the affirmative action ("Yes") on the prompt
- **THEN** the system MUST enable the Remember Playback Speed setting globally
- **AND** save the current speed as the global playback speed
- **AND** dismiss the prompt banner

#### Scenario: Dismissing the prompt
- **WHEN** the user selects the negative action ("No") on the prompt
- **THEN** the system MUST dismiss the prompt banner
- **AND** persist the dismissal state so that the prompt is not shown again for subsequent speed changes
- **AND** keep the Remember Playback Speed setting disabled

#### Scenario: Prompt dismissal reset on manual toggle
- **WHEN** the user updates the Remember Playback Speed setting directly in the Settings screen
- **THEN** the system MUST reset the prompt dismissal state
