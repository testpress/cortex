## MODIFIED Requirements

### Requirement: Learning and Playback Preferences
The system SHALL provide controls for video playback behavior and quality, including a Remember Playback Speed toggle.

#### Scenario: Adjusting Video Quality
- **WHEN** user selects a quality option (Auto, High, Medium, or Low)
- **THEN** the system MUST store this preference and apply it to future video playback sessions.

#### Scenario: Toggling Auto-play
- **WHEN** user toggles the "Auto-play next lesson" switch
- **THEN** the system MUST enable or disable the automatic transition to the next lesson upon current lesson completion.

#### Scenario: Toggling Remember Playback Speed
- **WHEN** the user toggles the "Remember Playback Speed" switch in Playback Settings
- **THEN** the system MUST persist the toggle state
- **AND** apply it to subsequently opened videos

#### Scenario: Default Remember Playback Speed State
- **WHEN** a new user has not yet changed the Remember Playback Speed setting
- **THEN** the system MUST default the toggle to disabled
