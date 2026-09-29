## ADDED Requirements

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

## MODIFIED Requirements

### Requirement: Restored Speed Notification
The system SHALL display a temporary, non-blocking notification when a remembered playback speed is restored.

#### Scenario: Non-blocking speed indication on subsequent video load
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
